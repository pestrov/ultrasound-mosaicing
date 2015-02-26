function displayImagesAtPositions(positions)
xOfImages = [];
yOfImages = [];
center = [1000.0 400.0];
for imageNumber = 1:5
    imageNumber
    image = imread(strcat('Leg8/Rot',sprintf('%d',imageNumber),'.png'));
    [rotatedImage, newCenter] = placeImage(image,center, positions{imageNumber});
%     shift = [0 0];
%     shift = [20 -25];
%     if imageNumber > 10
%         shift = [-10 25];
%     end
%     if imageNumber > 30
%         shift = [0 0];
%     end
%     center = [center(1) + shift(1) center(2)+ shift(2)];
    xOfImages = [xOfImages, newCenter(1)];
    yOfImages = [yOfImages, -newCenter(2)];
    if imageNumber == 1
        final = rotatedImage;
    else
        final = max(final, rotatedImage);
    end
end
xOfImages
yOfImages
%plot(xOfImages,yOfImages);
imshow(final,'DisplayRange',[0 255]);


%(36-72)
%   xShift = -90;
%     yShift = 40;
%     if imageNumber < 52
%         xShift = 10;
%         yShift = 100;
%     end
%     if imageNumber > 61
%         xShift = -60;
%         yShift = -30;
%     end
%      if imageNumber > 69
%         xShift = -40;
%         yShift = -30;
%     end