function  drawImage(radius)
    totalImages = 72;
    previousRotatedImage = 0;
    previousMask = 0;
    registrationError = 0;

    angleChange = 360/totalImages;
    for imageNumber = 1:37
        image = imread(strcat('Croped',sprintf('%d',imageNumber),'.png'));
        rotatedImage = adjustImage(image, angleChange*(imageNumber - 1), radius);
        if imageNumber == 1
            final = rotatedImage;
        else
            final = max(final, rotatedImage);
        end
        
    end
    imshow(final);
  