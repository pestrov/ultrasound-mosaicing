function imageMask = getImageMask(image, angle, radius)
    boxSize = 1400;
    angleSin = sind(angle+90);
    angleCos = cosd(angle+90);
    imageSize = size(image);
    image = uint8(ones(imageSize));

    tform = maketform('affine',[angleCos angleSin 0;
                               -angleSin angleCos 0;
                                0 0 1]);
    rotatedImage = imtransform(image,tform);
    rotatedImageSize = size(rotatedImage);
    xCenter = -boxSize/2;
    yCenter = -boxSize/2;
    xCoor = xCenter + rotatedImageSize(2)/2 - radius*cosd(angle);
    yCoor = yCenter + rotatedImageSize(1)/2 - radius*sind(angle);

    noTrform = maketform('affine',[1 0 0;
                                   0 1 0;
                                   0 0 1]);
    imageMask = imtransform(rotatedImage,noTrform, 'XData',[xCoor 0],'XYScale',[1], 'YData',[yCoor 0],'Size',[boxSize boxSize]);