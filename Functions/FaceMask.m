function faceMask = FaceMask(img)
    % Method 1: YCbCr color space
    YCbCr_image = rgb2ycbcr(img);
    Cb = YCbCr_image(:,:,2);
    Cr = YCbCr_image(:,:,3);

    % Define thresholds for skin color segmentation in YCbCr space
    Cb_min = 77;
    Cb_max = 127;
    Cr_min = 133;
    Cr_max = 173;

    % Create a binary mask based on the defined skin color thresholds
    skinMask = (Cb >= Cb_min & Cb <= Cb_max) & (Cr >= Cr_min & Cr <= Cr_max);

    % Method 2: HSV color space
    img_hsv = rgb2hsv(img);
    H = img_hsv(:,:,1);
    S = img_hsv(:,:,2);
    V = img_hsv(:,:,3);

    % Define thresholds for HSV space
    Hmin = 0;
    Hmax = 0.1; % Adjust according to the specific hue range for skin tones
    Smin = 0.15; % Adjust according to the specific saturation range for skin tones
    Vmin = 0.45; % Adjust according to the specific value/brightness range for skin tones

    % Create binary mask for HSV method
    mask_hsv = (H >= Hmin & H <= Hmax & S >= Smin & V >= Vmin);

    % Combine the masks
    combined_mask = skinMask & mask_hsv;

    % Morphological operations (optional)
    se = strel('disk', 90); % Adjust the size of the structuring element
    combined_mask = imclose(combined_mask, se);

    % Remove small connected components (noise)
    combined_mask = bwareaopen(combined_mask, 500);

    % Convert the logical mask to uint8
    combined_mask = uint8(combined_mask);

    % Apply the combined mask to the original image
    result_image = img .* repmat(combined_mask, [1, 1, 3]);

    faceMask = result_image;
end
