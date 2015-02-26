function registrationError = getRegistrationErrorFor(radius)
center = [1200.0 1000.0];
addpath('getImagePacthes.m')
addpath('calculateTransformFromSet.m')
    previousRotatedImage = 0;
    previousMask = 0;
    registrationError = 0;
    load('Angles.mat','angles')
    for imageNumber = 1:71
        rotatedImage = imread(strcat('Leg8/Rot',sprintf('%d',imageNumber),'.png'));
        xTranslation = radius * cosd(angles(imageNumber));
        yTranslation = radius * sind(angles(imageNumber));
        [rotatedImage, newCenter] = placeImage(rotatedImage, center, [xTranslation yTranslation]);
        
        image = imread(strcat('Leg8/Crop',sprintf('%d',imageNumber),'.png'));
        imageMask = getImageMask(image, angles(imageNumber), radius);

        if imageNumber == 1
            %final = rotatedImage;
        else
           
            firstImagePart = immultiply(previousRotatedImage, imageMask);
            secondImagePart = immultiply(rotatedImage, previousMask);
            difference = imabsdiff(firstImagePart, secondImagePart);
            registrationError = registrationError + sum(sum(difference));
        end
        previousMask = imageMask;
        previousRotatedImage = rotatedImage;
    end
     registrationError
     radius
  
