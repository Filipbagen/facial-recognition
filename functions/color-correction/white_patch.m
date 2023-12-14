% Hämtad från: https://se.mathworks.com/help/images/ref/illumwhite.html

function [outputImg] = white_patch(img)
    A_lin = rgb2lin(img);
    
    topPercentile = 7;
    illuminant = illumwhite(A_lin, topPercentile);
    
    B_lin = chromadapt(A_lin, illuminant, "ColorSpace", "linear-rgb");
    outputImg = lin2rgb(B_lin);

end

%     % Split image to each channel
%     im_R = img(:,:,1);
%     im_G = img(:,:,2);
%     im_B = img(:,:,3);
% 
%     % Get max value for each channel
%     max_R = double(max(im_R(:)));
%     max_G = double(max(im_G(:)));
%     max_B = double(max(im_B(:)));
% 
%     % Normalize each channel
%     out_R = uint8((double(im_R) / max_R) * 255);
%     out_G = uint8((double(im_G) / max_G) * 255);
%     out_B = uint8((double(im_B) / max_B) * 255);
% 
%     % Combine the normalized channels
%     outputImg = cat(3, out_R, out_G, out_B);