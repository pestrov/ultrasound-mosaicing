function PatchLearner(radius)

addpath('getImagePacthes.m')
addpath('calculateTransformFromSet.m')
addpath('placeImage.m')
addpath('displayImagesAtPositions.m')

totalImages = 71;
previousRotatedImage = 0;
localTranforms = {};
allTranforms = {};
angleChange = 360/totalImages;
load('Angles.mat','angles')
start = 1;
finish = 10;

for imageNumber = start:finish
    rotatedImage = imread(strcat('Leg8/Rot',sprintf('%d',imageNumber),'.png'));
%     rotatedImage = imageRotate(image, angleChange*(imageNumber - 1));
%     imwrite(rotatedImage, strcat('VRotated',sprintf('%d',imageNumber),'.png'));
    if imageNumber ~= start
        detectedTranforms = getImagePatches(previousRotatedImage,rotatedImage, radius, angles(imageNumber), imageNumber);
        celldisp(detectedTranforms);
        localTForm = calculateTransformFromSet(detectedTranforms);
        localTForm
        
        %cpselect(previousRotatedImage, rotatedImage);
        %pause(1000);
        
        localTranforms = [localTranforms, {localTForm}];
        allTranforms = [allTranforms, {detectedTranforms}];
        save('LocalTransforms.mat', 'localTranforms');
        save('AllDetectedTransforms.mat', 'allTranforms');
    end
    previousRotatedImage = rotatedImage;
end

pause(1000);
celldisp(localTranforms);

% xTranslation = radius * (cosd(angleChange*1) - cosd(angleChange*(totalImages)));
% yTranslation = radius * (sind(angleChange*1) - sind(angleChange*(totalImages)));

xTranslation = radius * (cosd(0) - cosd(355));
yTranslation = radius * (sind(0) - sind(355));

summedTransfroms = [{[xTranslation yTranslation]}, localTranforms];

save('Transforms.mat', 'summedTransfroms');
%load('Transforms.mat', 'summedTransfroms');    

positions = adjustTransforms(summedTransfroms)
displayImagesAtPositions(positions);
  
for transform = 1:71
    detectedTranforms = allTranforms{transform};
    localTForm = calculateTransformFromSet(detectedTranforms);
	localTranforms = [localTranforms, {localTForm}];
end

