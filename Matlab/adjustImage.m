function [adjustedImage, cropRect] = adjustImage(image, angle, radius, localTransfrom)
    boxSize = 1400;
    angleSin = sind(angle+90);
    angleCos = cosd(angle+90);
    imageSize = size(image);

    tform = maketform('affine',[angleCos angleSin 0;
                               -angleSin angleCos 0;
                                0 0 1]);
    rotatedImage = imtransform(image,tform);
    rotatedImageSize = size(rotatedImage);
    xCenter = -boxSize/2;
    yCenter = -boxSize/2;
    xCoor = xCenter + rotatedImageSize(2)/2 - radius*cosd(angle) - double(localTransfrom(1))
    yCoor = yCenter + rotatedImageSize(1)/2 - radius*sind(angle) - double(localTransfrom(2))

    noTrform = maketform('affine',[1 0 0;
                                   0 1 0;
                                   0 0 1]);
    adjustedImage = imtransform(rotatedImage,noTrform, 'XData',[xCoor 0],'XYScale',[1], 'YData',[yCoor 0],'Size',[boxSize boxSize]);
    cropRect = [int16(-xCoor)  int16(-yCoor)  rotatedImageSize(2)  rotatedImageSize(1)];