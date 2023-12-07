function [binaryEyeMap] = EyeMap(img)
    % Convert the image to YCbCr color space
    YCbCr_image = rgb2ycbcr(img);
    
    % Extract the chrominance components (Cb and Cr)
    y = double(YCbCr_image(:,:,1));
    Cb = double(YCbCr_image(:,:,2));
    Cr = double(YCbCr_image(:,:,3));
    Cr_neg = 1 - Cr; 
    
    % Compute the chrominance-based eye map (EyeMapC)
    EyeMapC = (1/3) * ( (Cb.^2) + (Cr_neg.^2) + (Cb./Cr) );
    EyeMapC = EyeMapC./max(EyeMapC(:));
    
    % Morphological operations on the luminance component (optional)
    se = strel('disk', 7); % Adjust the size of the structuring element
    y_dilate = imdilate(y, se);
    y_erode = imerode(y, se);
    
    % Compute the luminance-based eye map (EyeMapL)
    EyeMapL = y_dilate./(y_erode + 1);
    EyeMapL = EyeMapL./max(EyeMapL(:));
    
    % Combine the chrominance and luminance eye maps
    output = EyeMapC .* EyeMapL;
    
%     % Dilate the final binary eye map for better visualization
%     binaryEyeMap = imdilate(output, se);
    
     % Adjust the threshold value based on your requirements
    threshold = 0.48; 
   
    % Apply the threshold to create a binary image
    binaryEyeMap = output > threshold;

    % Dilate the final binary eye map for better visualization
    binaryEyeMap = imdilate(binaryEyeMap, se);
    
    % Apply circular Hough transform to find circles
%     radiusRange = [6, 10]; % Adjust the radius range based on expected eye size
%     sensitivity = 0.80; % Adjust the sensitivity based on your images
%     [circles, randii] = imfindcircles(binaryEyeMap, radiusRange, 'Sensitivity', sensitivity);
end
