function [binaryEyeMap, circles, randii] = EyeMap(img)
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
    se = strel('disk', 5); % Adjust the size of the structuring element
    y_dilate = imdilate(y, se);
    y_erode = imerode(y, se);
    
    % Compute the luminance-based eye map (EyeMapL)
    EyeMapL = y_dilate./(y_erode + 1);
    EyeMapL = EyeMapL./max(EyeMapL(:));
    
    % Combine the chrominance and luminance eye maps
    output = EyeMapC .* EyeMapL;
   
    % Use Otsu's method to automatically determine the threshold
    threshold = graythresh(output);

    % Apply the threshold to convert to a binary image
    binaryEyeMap = imbinarize(output, threshold);

    % Remove small objects 
    binaryEyeMap = bwareaopen(binaryEyeMap, 80);

    % Dilate the final binary eye map for better visualization
    binaryEyeMap = imdilate(binaryEyeMap, se);

    % Apply circular Hough transform to find circles
    radiusRange = [10, 55]; % Adjust the radius range based on expected eye size
    sensitivity = 0.75; % Adjust the sensitivity based on your images
    [circles, randii] = imfindcircles(binaryEyeMap, radiusRange, 'Sensitivity', sensitivity);
    
end
