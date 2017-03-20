function patchLearner(radius,folderName)

start = 1;
finish = 71;

addpath('getImagePacthes.m')
addpath('calculateTransformFromSet.m')
addpath('placeImage.m')
addpath('displayImagesAtPositions.m')

totalImages = length(dir(fullfile(strcat('Output/','Rotated/',folderName),'*.png')));

previousRotatedImage = 0;
localTranforms = {};
allTranforms = {};
load(strcat('Input/','DCM/',folderName,'/angles.mat'),'angles');
xCors = [];
yCors = [];

mkdir(strcat('Output/','Data/',folderName,'/Patches'));
mkdir(strcat('Output/','Data/',folderName));

for imageNumber = start:finish
    imageNumber
    rotatedImage = imread(strcat('Output/','Rotated/',folderName,'/',sprintf('%d',imageNumber),'.png'));
    if imageNumber ~= start
        detectedTranforms = getImagePatches(previousRotatedImage,rotatedImage, radius, angles, imageNumber, folderName);
        localTForm = calculateTransformFromSet(detectedTranforms);
        xCors = [xCors, localTForm(1)];
        yCors = [yCors, localTForm(2)];
        xFinal = cumsum(xCors)
        yFinal = cumsum(yCors)
        
        localTranforms = [localTranforms, {localTForm}];
        allTranforms = [allTranforms, {detectedTranforms}];
        
        save(strcat('Output/', 'Data/', folderName, '/LocalTransforms.mat'), 'localTranforms');
        save(strcat('Output/', 'Data/', folderName, '/AllDetectedTransforms.mat'), 'allTranforms');
    end
    previousRotatedImage = rotatedImage;
end

celldisp(localTranforms);

pause(1000);

% xTranslation = radius * (cosd(angleChange*1) - cosd(angleChange*(totalImages)));
% yTranslation = radius * (sind(angleChange*1) - sind(angleChange*(totalImages)));

xTranslation = radius * (cosd(0) - cosd(355));
yTranslation = radius * (sind(0) - sind(355));

summedTransfroms = [{[xTranslation yTranslation]}, localTranforms];

save('Transforms.mat', 'summedTransfroms');
%load('Transforms.mat', 'summedTransfroms');    

positions = adjustTransforms(summedTransfroms)
displayImagesAtPositions(positions,imageFolder);
  
for transform = 1:71
    detectedTranforms = allTranforms{transform};
    localTForm = calculateTransformFromSet(detectedTranforms);
	localTranforms = [localTranforms, {localTForm}];
end

