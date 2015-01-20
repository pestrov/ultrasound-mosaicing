function detectedTranforms = getImagePatches(firstImage, secondImage, radius, angleChange, imageNumber)

imageSize1 = size(firstImage)
firstImageXCenter = imageSize1(1)/2;
firstImageYCenter = imageSize1(2)/2;

imageSize2 = size(secondImage);
secondImageXCenter = imageSize2(1)/2
secondImageYCenter = imageSize2(2)/2

cropedFirstImage = firstImage;
cropedSecondImage = secondImage;

%Variables for detection
detectedTranforms = {};
bestPatch = 0;
secondBestDiff = 0;
secondBestPatch = 0;
difference = intmax;

%Patch matching params
windowWidth = 50;
patchSize = 80;
 
xTranslation = radius * (cosd(angleChange*imageNumber) - cosd(angleChange*(imageNumber - 1)))
yTranslation = radius * (sind(angleChange*imageNumber) - sind(angleChange*(imageNumber - 1)))

for firstXShift = -windowWidth:5:windowWidth
    for firstYShift = -windowWidth:5:windowWidth
        firstXShift = 0;
        firstYShift = 0;
        %Create patch from first image
        patchX = imageSize1(1)/2 + firstXShift - patchSize/2;
        patchY = imageSize1(2)/2 + firstYShift - patchSize/2;
        patchRect = [patchX patchY patchSize patchSize]
        firstImagePatch = imcrop(cropedFirstImage, patchRect);
        
        bestPatch = 0;

        for xShift = -windowWidth:5:windowWidth
            for yShift = -windowWidth:5:windowWidth
                xShift = 0;
                yShift = 0;
                
                %Create patch from second image
                secondPatchX = secondImageXCenter + xShift - xTranslation - patchSize/2;
                secondPatchY = secondImageYCenter + yShift - yTranslation - patchSize/2;
                secondPatchRect = [secondPatchX secondPatchY patchSize patchSize]
                secondImagePatch = imcrop(cropedSecondImage, secondPatchRect);
                
%                 imshow(firstImagePatch), figure, imshow(secondImagePatch);
%                 pause(15);
    
                if size(firstImagePatch) == size(secondImagePatch)
                    currentDifference = sum(sum(imabsdiff(firstImagePatch, secondImagePatch)));
                    if currentDifference < difference
                        if bestPatch
                           if (rectint(bestPatchRect, secondPatchRect) < 0.5) && (currentDifference < 0.8 * difference)
                                secondBestPatch = bestPatch;
                                secondBestPatchRect = bestPatchRect;
                           else
                               secondBestPatch = 0;
                               secondBestPatchRect = 0;
                           end
                        end
                        bestPatch = secondImagePatch;
                        bestPatchRect = secondPatchRect;
                        difference = currentDifference;
                    end
                end
            end
        end
        
        if secondBestPatch
            finalFirstImagePatch = firstImagePatch;
            finalBestPatch = bestPatch;
            finalSecondBestPatch = secondBestPatch;
            finalBestPatchRect = bestPatchRect;
            finalSecondBestPatchRect = secondBestPatchRect;
            finalFirstPatchRect = patchRect;
            finalBestPatchRect;
            detectedTranforms = [detectedTranforms,{[(patchRect(1) - firstImageXCenter) - (bestPatchRect(1) - secondImageXCenter) (patchRect(2) - firstImageYCenter) - (bestPatchRect(2) - secondImageYCenter)]}];
            
        end
        difference = intmax;
        currentDifference = intmax;
        bestPatch = 0;
    end
end

%            bestFirstPatch = firstImagePatch;
%imshow(finalFirstImagePatch), figure, imshow(finalBestPatch), figure, imshow(finalSecondBestPatch), figure, imshow(cropedFirstImage), figure,imshow(cropedSecondImage) ;
 finalBestPatchRect
 secondBestPatchRect
 finalFirstPatchRect
 celldisp(detectedTranforms);