function displayImagesAtPositions(positions, startingImage, imageFolder)
xOfImages = [];
yOfImages = [];
newCenter = [1300.0 800.0];
positionsSize = size(positions);
imagesNumber = 14;%positionsSize(2);

for imageNumber = 0:imagesNumber-1
    
    imageNumber
    image = imread(strcat('Output/','Rotated/',imageFolder,'/',sprintf('%d',imageNumber + startingImage),'.png'));
    [rotatedImage, newCenter] = placeImage(image,newCenter, positions{imageNumber + 1});
    xOfImages = [xOfImages, newCenter(1)];
    yOfImages = [yOfImages, -newCenter(2)];
    if imageNumber == 0
        final = rotatedImage;
    else
        final = max(final, rotatedImage);
    end
end

%plot(xOfImages,yOfImages);
imshow(final,'DisplayRange',[0 255]);