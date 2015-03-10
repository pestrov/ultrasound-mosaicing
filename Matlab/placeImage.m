function [adjustedImage,newCenter] = placeImage(image, previousCenter, localTransfrom)
    absPositions = 0;
    boxXSize = 2300;
    boxYSize = 2000;
    adjustedImage = zeros(boxYSize,boxXSize);
    imageSize = size(image);
    
    if absPositions == 1
        xCoor = int32(localTransfrom(1)) + previousCenter(1) - int32(imageSize(2)/2);
        yCoor = int32(localTransfrom(2)) + previousCenter(2) - int32(imageSize(1)/2);
        newCenter = [int32(localTransfrom(1)), int32(localTransfrom(2))];
    else
        xCoor = previousCenter(1) + int32(localTransfrom(1)) - int32(imageSize(2)/2);
        yCoor = previousCenter(2) + int32(localTransfrom(2)) - int32(imageSize(1)/2);
        newCenter = [xCoor + imageSize(2)/2, yCoor + imageSize(1)/2];
    end
    adjustedImage(yCoor:yCoor + imageSize(1)-1, xCoor:xCoor + imageSize(2)-1) = image;
    