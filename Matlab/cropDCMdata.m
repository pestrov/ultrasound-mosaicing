%Transform raw DCM data to croped png. Use manualCrop if want to set
%different then default cropping rect
function cropDCMdata(startImage, totalImages, folderName, manualCrop)
    %Default cropping value
    cropRect = [99   90  346  748];
    
    if manualCrop == 1
        [~,~,~,cropRect] = imcrop(strcat(inputFolder,DCMSubPath,folderName,DCMimageNameForNumber(startImage)));
    end
    
    addpath('fileContstants.m')
    addpath('DCMimageNameForNumber.m');
    mkdir(strcat('Output/','Croped/',folderName));
    
    for imageNumber = 0:totalImages - 1
        image = dicomread(strcat('Input/','DCM/',folderName,DCMimageNameForNumber(imageNumber+startImage)));
        cropedImage = imcrop(image,cropRect);
        imwrite(cropedImage, strcat('Output/','Croped/',folderName,'/',sprintf('%d',imageNumber+1),'.png'));
    end