function [eye_map] = illumination_based_method(input_img)
    image = rgb2ycbcr(input_img);
    
    Y_channel = image(:, :, 1);
    Cb_channel = image(:, :, 2);
    Cr_channel = image(:, :, 3);
    
    % Assuming you have the Cb and Cr channels as Cb_channel and Cr_channel
    % Normalize the channels to the range [0, 1]
    Cb_normalized = double(Cb_channel) / 255;
    Cr_normalized = double(Cr_channel) / 255;
    
    % Replace zero values in the Cr_normalized to avoid division by zero
    Cr_normalized(Cr_normalized == 0) = eps; % 'eps' is the smallest positive value in MATLAB
    
    % Calculate the EyeMapC with normalized channels
    EyeMapC = (1/3) * (Cb_normalized.^2 + Cr_normalized.^2 + (Cb_normalized ./ Cr_normalized));
    
    % Since we are working with normalized values, there is no need to clip the values at this stage
    
    % Normalize for display purposes
    EyeMapC = mat2gray(EyeMapC); % Normalize the result to the range [0, 1] for display
    
    % Define the structuring element 'g'. 
    % You will need to choose an appropriate size based on the expected size of the eyes.
    g = strel('disk', 6);  % '5' is just an example size.
    
    % Perform morphological dilation on the Y channel
    Y_dilated = imdilate(Y_channel, g);
    
    % Perform morphological erosion on the Y channel
    Y_eroded = imerode(Y_channel, g);
    
    % Calculate the EyeMapL according to the provided equation
    EyeMapL = Y_dilated ./ (Y_eroded + 1);
    
    % Normalize for display purposes
    EyeMapL = mat2gray(EyeMapL);  % Normalize the result to the range [0, 1] for display
    
    % Step 1: Dilate EyeMapC (if necessary, otherwise skip to Step 2)
    % Assuming dilation is needed for EyeMapC as well
    EyeMapC_dilated = imdilate(EyeMapC, g);
    
    % Step 2: Masking - threshold EyeMapC to create a mask
    % Otsu's method is used here to find a threshold for the binary mask
    EyeMapC_threshold = graythresh(EyeMapC_dilated);
    EyeMapC_binaryMask = imbinarize(EyeMapC_dilated, EyeMapC_threshold);
    
    % Step 3: Combine EyeMapL and EyeMapC by element-wise multiplication
    EyeMap_combined = EyeMapL .* EyeMapC_binaryMask;
    
    % Normalize for display purposes
    eye_map = mat2gray(EyeMap_combined);
end

