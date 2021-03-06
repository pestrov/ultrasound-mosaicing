function rotatedImage = rotateImage(image, angle)
    %We start from the right
    angleSin = sind(angle+90);
    angleCos = cosd(angle+90);

    tform = maketform('affine',[angleCos angleSin 0;
                               -angleSin angleCos 0;
                                0 0 1]);
    rotatedImage = imtransform(image,tform);