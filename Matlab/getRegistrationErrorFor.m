function registrationError = getRegistrationErrorFor(radius)
center = [1200.0 1200.0];
    previousRotatedImage = 0;
    previousMask = 0;
    registrationError = 0;
    load('Input/DCM/US 3-5-15/Angles.mat','angles')
    for imageNumber = 1:72
        rotatedImage = imread(strcat('Output/Rotated/US 3-5-15/',sprintf('%d',imageNumber),'.png'));
        xTranslation = radius * cosd(angles(imageNumber));
        yTranslation = radius * sind(angles(imageNumber));
        [rotatedImage, newCenter] = placeImage(rotatedImage, center, [xTranslation yTranslation]);
        
        image = imread(strcat('Output/Croped/US 3-5-15/',sprintf('%d',imageNumber),'.png'));
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
  
