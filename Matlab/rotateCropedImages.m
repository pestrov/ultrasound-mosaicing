%Rotate croped png images. You need to put angles.mat file witj angles
%array in the Input/DCM/foldername for that and set withAnglesFile to 1.
%Default angles are used otherwise
function  rotateCropedImages(startImage, totalImages, folderName, withAnglesFile)
    angles = loadAngles(totalImages, folderName, withAnglesFile);
    
    mkdir(strcat('Output/','Rotated/',folderName));
    
    for imageNumber = startImage:totalImages
        image = imread(strcat('Output/','Croped/',folderName,'/',sprintf('%d',imageNumber),'.png'));
        rotatedImage = rotateImage(image, angles(imageNumber));
        imwrite(rotatedImage, strcat('Output/','Rotated/',folderName,'/',sprintf('%d',imageNumber),'.png'));
    end
    
function angles = loadAngles(totalImages, folderName, withAnglesFile)
    angles = [];
    
    if withAnglesFile == 1
        load(strcat('Input/','DCM/',folderName,'/angles.mat'),'angles');
    else
        angleChange = 360/totalImages;
        for imageNumber = 0:totalImages-1
            angles = [angles, angleChange * imageNumber];
        end
    end
        
        