function PatchLearner(radius)
addpath('getImagePacthes.m')
addpath('calculateTransformFromSet.m')
    totalImages = 72;
    previousRotatedImage = 0;
    previousMask = 0;
    registrationError = 0;
    localTranforms = {};
    angleChange = 360/totalImages;
    for imageNumber = 1:5
        image = imread(strcat('VCropedImages/VCroped',sprintf('%d',totalImages - imageNumber),'.png'));
        rotatedImage = imageRotate(image, angleChange*(imageNumber - 1));
        %[rotatedImage, cropRect] = adjustImage(image, angleChange*(imageNumber - 1), radius, [0 0]);
        %imageMask = getImageMask(image, angleChange*(imageNumber - 1), radius);
        if imageNumber == 1
            %final = rotatedImage;
        else
            %final = max(final, rotatedImage);
            %firstImagePart = immultiply(previousRotatedImage, imageMask);
            %secondImagePart = immultiply(rotatedImage, previousMask);
            detectedTranforms = getImagePatches(previousRotatedImage,rotatedImage, radius, angleChange, imageNumber);
            localTForm = calculateTransformFromSet(detectedTranforms);
            localTranforms = [localTranforms, {localTForm}];

        end
       % previousMask = imageMask;
        previousRotatedImage = rotatedImage;
    end
    
celldisp(localTranforms);
summedTransfroms = [{[0.0 0.0]}, localTranforms]
    
totalTransfroms = numel(summedTransfroms);

W(1,1) = 1;%X1
W(1,totalTransfroms) = -1;%Xn
W(totalTransfroms + 1,totalTransfroms + 1) = 1;%Y1
W(totalTransfroms + 1,totalTransfroms*2) = -1;%Yn

W(totalTransfroms*2 + 1, 1) = 1;%Y1
W(totalTransfroms*2 + 2,totalTransfroms + 1) = -1;%Yn

for pair = 1:totalTransfroms-1
    W(pair+1, pair) = -1;%Xi
    W(pair+1, pair+1) = 1;%Xi+1
    W(totalTransfroms + pair + 1,totalTransfroms + pair) = -1;%Yi
    W(totalTransfroms + pair + 1,totalTransfroms + pair + 1) = 1;%Yi+1
    deltas(pair) = summedTransfroms{pair}(1);
    deltas(totalTransfroms + pair) = summedTransfroms{pair}(2);
end
for pair = 1:totalTransfroms
    deltas(pair) = summedTransfroms{pair}(1);
    deltas(totalTransfroms + pair) = summedTransfroms{pair}(2);
end
deltas
W
positions = deltas/W

%     for imageNumber = 1:2
%         image = imread(strcat('Croped',sprintf('%d',imageNumber),'.png'));
%         [rotatedImage, ~] = adjustImage(image, angleChange*(imageNumber - 1), radius, summedTransfroms{imageNumber});
%         if imageNumber == 1
%             final = rotatedImage;
%         else
%             final = max(final, rotatedImage);
%             
%         end
%     end
%     imshow(final);
  



