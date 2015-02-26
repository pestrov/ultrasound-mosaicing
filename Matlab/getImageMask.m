function imageMask = getImageMask(image, angle, radius)
    center = [1200.0 1000.0];
    imageSize = size(image);
    image = uint8(ones(imageSize));

    angleSin = sind(angle+90);
    angleCos = cosd(angle+90);

    tform = maketform('affine',[angleCos angleSin 0;
                               -angleSin angleCos 0;
                                0 0 1]);
    rotatedImage = imtransform(image,tform);
  
    xTranslation = radius * cosd(angle);
    yTranslation = radius * sind(angle);
    [imageMask, newCenter] = placeImage(rotatedImage, center, [xTranslation yTranslation]);