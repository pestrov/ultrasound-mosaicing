function detectedTranforms = getImagePatches(firstImage, secondImage, radius, angles, imageNumber, folderName)

imageSize1 = size(firstImage);

firstImageXCenter = imageSize1(2)/2;
firstImageYCenter = imageSize1(1)/2;

imageSize2 = size(secondImage);
secondImageXCenter = imageSize2(2)/2;
secondImageYCenter = imageSize2(1)/2;

cropedFirstImage = firstImage;
cropedSecondImage = secondImage;

%Variables for detection
detectedTranforms = {};
bestPatch = 0;
secondBestDiff = 0;
secondBestPatch = 0;
difference = intmax;
secondDiff = intmax;
patchNumber = 0;

%Patch matching params
windowWidth = 50;
if imageNumber == 5
    windowWidth = 150;
end

if imageNumber > 22
    if imageNumber < 34
        windowWidth = 150;
    end
end

if imageNumber > 50
    if imageNumber < 58
        windowWidth = 150;
    end
end

patchSize = 32;
patchArea = patchSize*patchSize;
patchIntersectionThreshold = patchArea*0.3;

%angleChange = angles(imageNumber);
xTranslation = radius * (cosd(angles(imageNumber)) - cosd(angles(imageNumber - 1)))
yTranslation = radius * (sind(angles(imageNumber)) - sind(angles(imageNumber - 1)))
        
%xTranslation = radius * (cosd(angleChange*imageNumber) - cosd(angleChange*(imageNumber - 1)));
%yTranslation = radius * (sind(angleChange*imageNumber) - sind(angleChange*(imageNumber - 1)));

for firstXShift = -windowWidth:5:windowWidth
    firstXShift
    for firstYShift = -windowWidth:5:windowWidth
        
        %Create patch from first image
        patchX = firstImageXCenter + firstXShift - patchSize/2;
        patchY = firstImageYCenter + firstYShift - patchSize/2;
        patchRect = [patchX patchY patchSize patchSize];
        firstImagePatch = imcrop(cropedFirstImage, patchRect);
        
        %patchOnFirstImage = insertShape(firstImage, 'rectangle', patchRect, 'LineWidth', 2);
        %imwrite(patchOnFirstImage, strcat('AllPatches/',sprintf('%d',1),'-',sprintf('%d',firstXShift),'-',sprintf('%d',firstYShift),'ImagePatch.png'));

        
        bestPatch = 0;
        
        for xShift = -windowWidth:5:windowWidth
            for yShift = -windowWidth:5:windowWidth
                %Create patch from second image
                secondPatchX = secondImageXCenter + xShift - xTranslation - patchSize/2;
                secondPatchY = secondImageYCenter + yShift - yTranslation - patchSize/2;
                secondPatchRect = [secondPatchX secondPatchY patchSize patchSize];
                secondImagePatch = imcrop(cropedSecondImage, secondPatchRect);
                %imshow(firstImagePatch), figure, imshow(secondImagePatch);
                %pause(15);
                
                %patchOnSecondImage = insertShape(secondImage, 'rectangle', secondPatchRect, 'LineWidth', 2);
                %imwrite(patchOnSecondImage, strcat('AllPatches/',sprintf('%d',imageNumber),'-',sprintf('%d',xShift),'-',sprintf('%d',yShift),'ImagePatch.png'));
                
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
        
        for xShift = -windowWidth:5:windowWidth
            
            if patchIsNotGoodEnough
                break;
            end
            
            for yShift = -windowWidth:5:windowWidth
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
                patchNumber = patchNumber(2)
                
                patchOnFirstImage = insertShape(firstImage, 'rectangle', patchRect, 'LineWidth', 2);
                patchOnSecondImage = insertShape(secondImage, 'rectangle', bestPatchRect, 'LineWidth', 2);
                
                imwrite(patchOnFirstImage, strcat('Output/','Data/',folderName,'/Patches/',sprintf('%d',imageNumber),' - ',sprintf('%d',patchNumber),' ImageWithPatch.png'));
                imwrite(patchOnSecondImage, strcat('Output/','Data/',folderName,'/Patches/',sprintf('%d',imageNumber),' - ',sprintf('%d',patchNumber),' ImageWithPatch 2.png'));
            end
        end
        
        difference = intmax;
        currentDifference = intmax;
    end 
    if patchNumber > 20
        break
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


 