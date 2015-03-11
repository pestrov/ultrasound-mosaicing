ultrasound-mosaicing
====================

Ultrasound Mosaicing Project 

Turning multiple images of a limb scan into a joint image:
![Input1:](https://github.com/pestrov/ultrasound-mosaicing/blob/master/1.png)
![Input2:](https://github.com/pestrov/ultrasound-mosaicing/blob/master/2.png)
![Output:](https://github.com/pestrov/ultrasound-mosaicing/blob/master/Output.png)



Procedure:

1. Put a folder DCM images into Matlab/Input/DCM/ folder.
2. Run cropDCMdata to transfer it to png format, cropping the limb part of the image.
	- You should pass the starting image number, number of images and wether you want to set the crop rect yourself or use the default rect. 	
	— Example for coping 36 images from folder “NewScan”, with first image name “MUS(062)”: cropDCMdata(62, 36, ‘NewScan’, 1)
Images would be saves to the corresponding folder in the Output folder.
3. Put an “angles.mat” file with an array of image angles save in a variable “angle” (run Matlab’s save(‘angles.mat’, ‘angles’) ) in corresponding DCM folder.
4. Run rotateCropedImages to rotate images to their angles.
5. Run drawImage() with some radius to see the basic image.
6. Run Optimze to get the best radius for registration initialization.
7. Run patchLeaner with that radius to get the patches and perform images registration.
8. Run displayImagesAtPositions() with the cells array of image positions learned.