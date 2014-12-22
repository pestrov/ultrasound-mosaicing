function registrationError = getRegistrationErrorFor(radius)
addpath('getImagePacthes.m')
addpath('calculateTransformFromSet.m')
    totalImages = 72;
    previousRotatedImage = 0;
    previousMask = 0;
    registrationError = 0;

    angleChange = 360/totalImages;
    for imageNumber = 1:37
        image = imread(strcat('Croped',sprintf('%d',imageNumber+10),'.png'));
        [rotatedImage, cropRect] = adjustImage(image, angleChange*(imageNumber - 1), radius, [0 0]);
        imageMask = getImageMask(image, angleChange*(imageNumber - 1), radius);
        if imageNumber == 1
            %final = rotatedImage;
        else
            %final = max(final, rotatedImage);
            firstImagePart = immultiply(previousRotatedImage, imageMask);
            secondImagePart = immultiply(rotatedImage, previousMask);
%             detectedTranforms = getImagePatches(previousRotatedImage,rotatedImage, cropRect);
%             localTForm = calculateTransformFromSet(detectedTranforms);
%             if imageNumber == 10
%            imshow(firstImagePart), figure, imshow(secondImagePart);
%             end
            difference = imabsdiff(firstImagePart, secondImagePart);
            registrationError = registrationError + sum(sum(difference));
        end
        previousMask = imageMask;
        previousRotatedImage = rotatedImage;
        %imshow(final);
    end
%     registrationError
%     radius
  
