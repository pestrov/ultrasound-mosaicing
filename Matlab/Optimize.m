[radius,error] = fminbnd(@getRegistrationErrorFor, 130, 300)
%[radius,error] = fminsearch(@getRegistrationErrorFor, 250)

