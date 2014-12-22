% dcimage = dicomread('Horizontal/MUS(001).dcm');
% dcimage1 = dicomread('Horizontal/MUS(002).dcm');
%imshow(imcrop(dicomread('Horizontal/MUS(001).dcm'),[95  312  234  369]));
% cpselect(dcimage,dcimage1)

HcropRect = [95  312  234  369];
VcropRect = [1  347  272  423];
%[X,Y,I2,VcropRect] = imcrop(dicomread('Vertical/MUS(001).dcm'))
%38
 for imageNumber = 10:72
     image = dicomread(strcat('Vertical/MUS(0',sprintf('%d',imageNumber),').dcm'));
     cropedImage = imcrop(image,VcropRect);
     imwrite(cropedImage, strcat('VCroped',sprintf('%d',imageNumber),'.png'));
 end