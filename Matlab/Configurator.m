function registrationError = getRegistrationErrorFor(radius)
addpath('adjustImage.m')
totalImages = 72;
radius = 400
totalDiff = 0;
previousRotatedImage;
previousMask;

angleChange = 360/totalImages;
for imageNumber = 1:37
    image = imread(strcat('Croped',sprintf('%d',imageNumber),'.png'));
    
    rotatedImage = adjustImage(image, angleChange*(imageNumber - 1), radius);
    imageMask = getImageMask(image, angleChange*(imageNumber - 1), radius);
    
    if imageNumber == 1
        final = rotatedImage;
    else
        final = max(final, rotatedImage);
        firstImagePart = immultiply(previousRotatedImage, imageMask);
        secondImagePart = immultiply(rotatedImage, previousMask);
        
        difference = imabsdiff(firstImagePart, secondImagePart);
        totalDiff = totalDiff + sum(sum(difference));
    end 
    previousMask = imageMask;
    previousRotatedImage = rotatedImage;
    %imshow(final);
end


