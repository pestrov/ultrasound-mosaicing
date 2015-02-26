% dcimage = dicomread('Horizontal/MUS(001).dcm');
% dcimage1 = dicomread('Horizontal/MUS(002).dcm');
%imshow(imcrop(dicomread('Horizontal/MUS(001).dcm'),[95  312  234  369]));
% cpselect(dcimage,dcimage1)

% HcropRect = [95  312  234  369];
%VcropRectOld = [1  347  272  423];
VcropRectLeg8 = [99   62  346  748]
%[X,Y,I2,VcropRect] = imcrop(dicomread('US 2-19-15/MUS(030).dcm'));
%38
 for imageNumber = 10:18
     image = dicomread(strcat('US 2-19-15/MUS(',sprintf('0%d',imageNumber),').dcm'));
     cropedImage = imcrop(image,VcropRectLeg8);
     imwrite(cropedImage, strcat('Crop',sprintf('%d',imageNumber),'.png'));
 end