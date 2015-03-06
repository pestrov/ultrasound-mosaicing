function  drawImage(radius)
    totalImages = 72;
    previousRotatedImage = 0;
    previousMask = 0;
    registrationError = 0;
    load('PAngles.mat','Pangles')
    center = [700.0 600.0];
    angleChange = 360/totalImages;
    start = 1;
    finish = 72;
    for imageNumber = start:finish
%         if mod(imageNumber,3) == 0 || mod(imageNumber,3) == 1
%             continue
%         end
        image = imread(strcat('Phantom/Rot',sprintf('%d',imageNumber),'.png'));
        xTranslation = radius * cosd(Pangles(imageNumber));
        yTranslation = radius * sind(Pangles(imageNumber));
        [rotatedImage, newCenter] = placeImage(image,center, [xTranslation yTranslation]);
        %rotatedImage = adjustImage(image, angles(imageNumber), radius, [0 0]);
        %imwrite(rotatedImage, strcat('Leg8/Rot',sprintf('%d',imageNumber),'.png'));
        if imageNumber == start
            final = rotatedImage;
        else
            final = max(final, rotatedImage);
        end
        
    end
 imshow(final,'DisplayRange',[0 255]);
  