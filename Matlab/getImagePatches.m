function detectedTranforms = getImagePatches(firstImage, secondImage, radius, angleChange, imageNumber)
difference = intmax;
imageSize1 = size(firstImage)
firstImageXCenter = imageSize1(1)/2;
firstImageYCenter = imageSize1(2)/2;
imageSize2 = size(secondImage)
secondImageXCenter = imageSize2(1)/2
secondImageYCenter = imageSize2(2)/2
cropedFirstImage = firstImage;%imcrop(firstImage, cropRect);
cropedSecondImage = secondImage;%imcrop(secondImage, cropRect);
detectedTranforms = {};
windowWidth = 50;
bestPatch = 0;
secondBestDiff = 0;
secondBestPatch = 0;
 
xTranslation = radius * (cosd(angleChange*imageNumber) - cosd(angleChange*(imageNumber - 1)))
yTranslation = radius * (sind(angleChange*imageNumber) - sind(angleChange*(imageNumber - 1)))

for firstXShift = -windowWidth:5:windowWidth
    for firstYShift = -windowWidth:5:windowWidth
        %patchRect = [cropRect(3)/2+firstXShift cropRect(4)/2 + firstYShift 32 32];
        patchRect = [imageSize1(1)/2 + firstXShift imageSize1(2)/2 + firstYShift 32 32];
        firstImagePatch = imcrop(cropedFirstImage, patchRect);
        size(firstImagePatch);
        bestPatch = 0;

        for xShift = -windowWidth:5:windowWidth
            for yShift = -windowWidth:5:windowWidth
                secondPatchRect = [secondImageXCenter+xShift-xTranslation secondImageYCenter+yShift-yTranslation 32 32];
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