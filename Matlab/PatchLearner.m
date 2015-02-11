function PatchLearner(radius)

addpath('getImagePacthes.m')
addpath('calculateTransformFromSet.m')
addpath('placeImage.m')
addpath('displayImagesAtPositions.m')

totalImages = 72;
previousRotatedImage = 0;
localTranforms = {};
allTranforms = {};
angleChange = 360/totalImages;

for imageNumber = 1:72
    image = imread(strcat('VCroped',sprintf('%d',totalImages - imageNumber + 1),'.png'));
    rotatedImage = imageRotate(image, angleChange*(imageNumber - 1));
    imwrite(rotatedImage, strcat('VRotated',sprintf('%d',imageNumber),'.png'));
    if imageNumber ~= 1
        detectedTranforms = getImagePatches(previousRotatedImage,rotatedImage, radius, angleChange, imageNumber);
        localTForm = calculateTransformFromSet(detectedTranforms);
        localTForm
        localTranforms = [localTranforms, {localTForm}];
        allTranforms = [allTranforms, {detectedTranforms}];
        save('LocalTransforms.mat', 'localTranforms');
        save('AllDetectedTransforms.mat', 'allTranforms');
    end
    previousRotatedImage = rotatedImage;
end

celldisp(localTranforms);

xTranslation = radius * (cosd(angleChange*1) - cosd(angleChange*(totalImages)));
yTranslation = radius * (sind(angleChange*1) - sind(angleChange*(totalImages)));

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

