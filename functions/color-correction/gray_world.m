% Hämtad från: https://se.mathworks.com/help/images/ref/illumgray.html

function [outputImg] = gray_world(img)
    
    % Gray world - test 
    A_lin = rgb2lin(img);
    percentiles = 10;
    
    illumination = illumgray(A_lin, percentiles);
    
    B_lin = chromadapt(A_lin, illumination, "ColorSpace","linear-rgb");
    outputImg = lin2rgb(B_lin);
end