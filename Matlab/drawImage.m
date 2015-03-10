function  drawImage(startImage, totalImages, radius, folderName, withAnglesFile)
    
    angles = loadAngles(totalImages, folderName, withAnglesFile);
    center = [1000.0 1000.0];
    for imageNumber = startImage:totalImages
        image = imread(strcat('Output/','Rotated/',folderName,'/',sprintf('%d',imageNumber),'.png'));
        xTranslation = radius * cosd(angles(imageNumber));
        yTranslation = radius * sind(angles(imageNumber));
        [rotatedImage, newCenter] = placeImage(image,center, [xTranslation yTranslation]);
        if imageNumber == startImage
            final = rotatedImage;
        else
            final = max(final, rotatedImage);
        end
        
    end
 imshow(final,'DisplayRange',[0 255]);
 
 function angles = loadAngles(totalImages, folderName, withAnglesFile)
    angles = [];
    
    if withAnglesFile == 1
        load(strcat('Input/','DCM/',folderName,'/angles.mat'),'angles');
    else
        angleChange = 360/totalImages;
        for imageNumber = 0:totalImages-1
            angles = [angles, angleChange * imageNumber];
        end
    end
  