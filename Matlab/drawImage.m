function  drawImage(radius)
    totalImages = 72;
    previousRotatedImage = 0;
    previousMask = 0;
    registrationError = 0;
    load('Angles.mat','angles')
    center = [1200.0 1000.0];
    angleChange = 360/totalImages;
    start = 41;
    finish = 71;
    for imageNumber = start:finish
%         if mod(imageNumber,3) == 0 || mod(imageNumber,3) == 1
%             continue
%         end
        image = imread(strcat('Leg8/Rot',sprintf('%d',imageNumber),'.png'));
        xTranslation = radius * cosd(angles(imageNumber));
        yTranslation = radius * sind(angles(imageNumber));
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
  