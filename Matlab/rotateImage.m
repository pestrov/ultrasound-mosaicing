function rotatedImage = rotateImage(image, angle, radius)
    imageRot = imrotate(image,angle);
    angleSin = sind(angle)
    angleCos = cosd(angle)
    if angleSin < 0
        rotatedImage = padarray(imageRot, [0 radius], 0, 'pre');
    elseif angleSin > 0
        rotatedImage = padarray(imageRot, [0 radius], 0, 'post');
    else 
        rotatedImage = padarray(imageRot, [0 radius/2], 0, 'both');
    end
    
    if angleCos < 0
        rotatedImage = padarray(rotatedImage, [radius 0], 0, 'pre');
    elseif angleCos > 0
        rotatedImage = padarray(rotatedImage, [radius 0], 0, 'post');
    else 
        rotatedImage = padarray(rotatedImage, [radius/2 0], 0, 'both');
    end  
      