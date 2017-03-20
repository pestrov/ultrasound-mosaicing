function displayImagesAtPositions(positions, startingImage, imageFolder)
xOfImages = [];
yOfImages = [];
newCenter = [1000.0 1000.0];
positionsSize = size(positions);
imagesNumber = 71;%positionsSize(2);

for imageNumber = 0:imagesNumber-1
    imageNumber
    image = imread(strcat('Output/','Rotated/',imageFolder,'/',sprintf('%d',imageNumber + startingImage),'.png'));
    [rotatedImage, newCenter] = placeImage(image,newCenter, positions{imageNumber + 1});
    xOfImages = [xOfImages, newCenter(1)];
    yOfImages = [yOfImages, -newCenter(2)];
    if imageNumber == 0
        final = rotatedImage;
    else
%         if any([2;3;4;5;6;7;10;12;13;14;15;16;17;19;20;21;22;23;25;28;34;35;50;51;52;53;54;55;56;57;61;67;68;71]==imageNumber)
%             'MISS'
%             continue
%         end
        if any([20;23;29;30;31;]==imageNumber)
            'MISS'
            continue
        end
        final = max(final, rotatedImage);
    end
end

%plot(xOfImages,yOfImages);
imshow(final,'DisplayRange',[0 255]);