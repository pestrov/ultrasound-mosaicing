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
% if imageNumber == 5
%     windowWidth = 150;
% end
% 
% if imageNumber > 22
%     if imageNumber < 34
%         windowWidth = 150;
%     end
% end
% 
% if imageNumber > 50
%     if imageNumber < 58
%         windowWidth = 150;
%     end
% end

patchSize = 32;
patchArea = patchSize*patchSize;
patchIntersectionThreshold = patchArea*0.3;

'Start'
%firstImageSpace = imcrop(firstImage, [firstImageXCenter*4/5 firstImageYCenter*4/5 firstImageXCenter * 1/5 firstImageYCenter * 1/5]);
%secondImageSpace = imcrop(secondImage, [secondImageXCenter*4/5 secondImageYCenter*4/5 secondImageXCenter * 1/5 secondImageYCenter * 1/5]);

%New code
[firstImageSpace firstImageRect] = imcrop(firstImage, [floor(firstImageXCenter*4/5) floor(firstImageYCenter*4/5) 99 99]);
[secondImageSpace secondImageRect] = imcrop(secondImage, [floor(secondImageXCenter*4/5) floor(secondImageYCenter*4/5)  99 99]);
%imshow(firstImageSpace,'DisplayRange',[0 255]);
%imshow(secondImageSpace,'DisplayRange',[0 255]);

firstImageSpaceSize = size(firstImageSpace);
secondImageSpaceSize = size(secondImageSpace);

firstPatches = im2col(firstImageSpace, [patchSize patchSize]);
secondPatches = im2col(secondImageSpace, [patchSize patchSize]);

secondPatchesSize = size(secondPatches);
totalTargetPatches = secondPatchesSize(2);
allDists = vl_alldist2(firstPatches, secondPatches);

[minDists, indexes] = min(allDists');

columns = cumsum(ones(size(indexes)));
allDists(sub2ind(size(allDists), columns, indexes)) = intmax;

[secondMinDists, secondMinIndexes] = min(allDists');
patchOverlap = patchSize/4;

h2 = firstImageSpaceSize(1);
for index = 1:totalTargetPatches
    i = indexes(index);
    i: min(patchOverlap, mod(i,h2)); %down
    i - min(patchOverlap, mod(i,h2)) + 1: i-1; %up
    i: h2: min(i+h2*patchOverlap,totalTargetPatches); %right
    max(i-h2*patchOverlap,1): h2: i; %left
end
%New code


x = meshgrid(1:4,1:4);
y = x';
patchSize = 2
xCoors = im2col(x,[patchSize patchSize])
yCoors = im2col(y,[patchSize patchSize]);
xCor = xCoors(10)
yCor = yCoors(10)
'Done'
%size(allDists)
pause(1000);

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


 