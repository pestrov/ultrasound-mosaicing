function displayImagesAtPositions(positions)
xOfImages = [];
yOfImages = [];
center = [4500.0 2400.0];
for imageNumber = 36:72
    imageNumber
    image = imread(strcat('VRotated',sprintf('%d',imageNumber),'.png'));
    [rotatedImage, newCenter] = placeImage(image,center, positions{imageNumber});
    xOfImages = [xOfImages, newCenter(1)];
    yOfImages = [yOfImages, newCenter(2)];
    if imageNumber == 36
        final = rotatedImage;
    else
        final = max(final, rotatedImage);
    end
end
xOfImages
yOfImages
%plot(xOfImages,yOfImages);
imshow(final,'DisplayRange',[0 255]);
