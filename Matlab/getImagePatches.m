function detectedTranforms = getImagePatches(firstImage, secondImage, radius, angleChange, imageNumber)

imageNumber

imageSize1 = size(firstImage);
firstImageXCenter = imageSize1(1)/2;
firstImageYCenter = imageSize1(2)/2;

imageSize2 = size(secondImage);
secondImageXCenter = imageSize2(1)/2;
secondImageYCenter = imageSize2(2)/2;

cropedFirstImage = firstImage;
cropedSecondImage = secondImage;

%Variables for detection
detectedTranforms = {};
bestPatch = 0;
secondBestDiff = 0;
secondBestPatch = 0;
difference = intmax;
secondDiff = intmax;

%Patch matching params
windowWidth = 30;
patchSize = 32;
patchArea = patchSize*patchSize;
patchIntersectionThreshold = patchArea*0.3;

xTranslation = radius * (cosd(angleChange*imageNumber) - cosd(angleChange*(imageNumber - 1)));
yTranslation = radius * (sind(angleChange*imageNumber) - sind(angleChange*(imageNumber - 1)));

for firstXShift = -windowWidth:5:windowWidth
    for firstYShift = -windowWidth:5:windowWidth
        rectangle()
        %Create patch from first image
        patchX = imageSize1(1)/2 + firstXShift - patchSize/2;
        patchY = imageSize1(2)/2 + firstYShift - patchSize/2;
        patchRect = [patchX patchY patchSize patchSize];
        firstImagePatch = imcrop(cropedFirstImage, patchRect);
        
        bestPatch = 0;
        
        for xShift = -windowWidth:2:windowWidth
            for yShift = -windowWidth:2:windowWidth
                %Create patch from second image
                secondPatchX = secondImageXCenter + xShift - xTranslation - patchSize/2;
                secondPatchY = secondImageYCenter + yShift - yTranslation - patchSize/2;
                secondPatchRect = [secondPatchX secondPatchY patchSize patchSize];
                secondImagePatch = imcrop(cropedSecondImage, secondPatchRect);
                %                 imshow(firstImagePatch), figure, imshow(secondImagePatch);
                %                 pause(15);
                
                if size(firstImagePatch) == size(secondImagePatch)
                    currentDifference = sum(sum(imabsdiff(firstImagePatch, secondImagePatch)));
                    if currentDifference < difference
                        %Saving best result
                        bestPatch = secondImagePatch;
                        bestPatchRect = secondPatchRect;
                        difference = currentDifference;
                    end
                end
            end
        end
        
        patchIsNotGoodEnough = 0;
        
        for xShift = -windowWidth:2:windowWidth
            
            if patchIsNotGoodEnough
                break;
            end
            
            for yShift = -windowWidth:2:windowWidth
                %Create patch from second image
                secondPatchX = secondImageXCenter + xShift - xTranslation - patchSize/2;
                secondPatchY = secondImageYCenter + yShift - yTranslation - patchSize/2;
                secondPatchRect = [secondPatchX secondPatchY patchSize patchSize];
                secondImagePatch = imcrop(cropedSecondImage, secondPatchRect);
                
                if size(firstImagePatch) == size(secondImagePatch)
                    currentDifference = sum(sum(imabsdiff(firstImagePatch, secondImagePatch)));
                    
                    %Check if the new rect is really far away
                    if rectint(bestPatchRect, secondPatchRect) < patchIntersectionThreshold
                        if difference > 0.7* currentDifference
                            patchIsNotGoodEnough = 1;
                            break;
                        end
                    end
                end
            end
        end
        if patchIsNotGoodEnough == 0 
            if bestPatch ~= 0
                finalFirstImagePatch = firstImagePatch;
                finalBestPatch = bestPatch;
                finalBestPatchRect = bestPatchRect;
                finalFirstPatchRect = patchRect;
                
                detectedTranforms = [detectedTranforms,{[(patchRect(1) - firstImageXCenter) - (bestPatchRect(1) - secondImageXCenter) (patchRect(2) - firstImageYCenter) - (bestPatchRect(2) - secondImageYCenter)]}];
                
                patchNumber = size(detectedTranforms);
                patchNumber = patchNumber(2);
                
                %imwrite(finalFirstImagePatch, strcat('Patches/',sprintf('%d',imageNumber),'-',sprintf('%d',patchNumber),'FirstPatch.png'));
                %imwrite(finalBestPatch, strcat('Patches/',sprintf('%d',imageNumber),'-',sprintf('%d',patchNumber),'MatchingPatch.png'));
                patchOnFirstImage = insertShape(firstImage, 'rectangle', patchRect, 'LineWidth', 2);
                patchOnSecondImage = insertShape(secondImage, 'rectangle', bestPatchRect, 'LineWidth', 2);
                imwrite(patchOnFirstImage, strcat('Patches/',sprintf('%d',imageNumber),'-',sprintf('%d',patchNumber),'ImageWithPath.png'));
                imwrite(patchOnSecondImage, strcat('Patches/',sprintf('%d',imageNumber),'-',sprintf('%d',patchNumber),'ImageWithPath2.png'));
            end
        end
        difference = intmax;
        currentDifference = intmax;
    end   
end
celldisp(detectedTranforms);

detectedTranformsSize = size(detectedTranforms);

totalPatches = detectedTranformsSize(2)
if totalPatches == 0
    'Default'
    detectedTranforms = {[xTranslation yTranslation]};
end

end

%            bestFirstPatch = firstImagePatch;
%imshow(finalFirstImagePatch), figure, imshow(finalBestPatch), figure, imshow(finalSecondBestPatch), figure, imshow(cropedFirstImage), figure,imshow(cropedSecondImage) ;
%  finalBestPatchRect
%  secondBestPatchRect
%  finalFirstPatchRect

 