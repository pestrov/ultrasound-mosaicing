% addpath('adjustImage.m')
% addpath('getImageMask.m')
% addpath('getRegistrationErrorFor.m')
% addpath('PatchLearner.m')
% [radius,error] = fminbnd(@getRegistrationErrorFor, 250, 400)

A = [-1 1 0;
    0 -1 1;
    1 0 -1
    1 0 0;]
B = [7 8 9];
x = B/A
% radius = 309;
% PatchLearner(radius);
