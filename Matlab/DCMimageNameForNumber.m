%Default image names for different image numbers
function imageName = DCMimageNameForNumber(imageNumber)

    if imageNumber < 10
        imageName = strcat('/MUS(00',sprintf('%d',imageNumber),').dcm');
    elseif imageNumber < 100
        imageName = strcat('/MUS(0',sprintf('%d',imageNumber),').dcm');
    else
        imageName = strcat('/MUS(',sprintf('%d',imageNumber),').dcm');
    end
   