% Hämtad från: https://se.mathworks.com/help/images/ref/illumwhite.html

function [outputImg] = white_patch(img)
    A_lin = rgb2lin(img);
    
    topPercentile = 5;
    illuminant = illumwhite(A_lin, topPercentile);
    
    B_lin = chromadapt(A_lin, illuminant, "ColorSpace", "linear-rgb");
    outputImg = lin2rgb(B_lin);

end