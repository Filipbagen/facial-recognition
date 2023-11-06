function [outputImg] = WhitePatch(img)
A_lin = rgb2lin(img);

topPercentile = 5;
illuminant = illumwhite(A,topPercentile);

B_lin = chromadapt(A_lin,illuminant,"ColorSpace","linear-rgb");
outputImg = lin2rgb(B_lin);

end

%% Hämtad från: https://se.mathworks.com/help/images/ref/illumwhite.html