function binary_img = FaceMask(img)
    % light compensation of the input image
    img = white_patch(img);


    % Method 1: YCbCr color space
    YCbCr_image = rgb2ycbcr(img);
    Y = YCbCr_image(:,:,1);
    Cb = YCbCr_image(:,:,2);
    Cr = YCbCr_image(:,:,3);

    % Adjusted thresholds for skin color segmentation in YCbCr space
    Cb_min = 78;
    Cb_max = 130;
    Cr_min = 136;
    Cr_max = 168;


    % Threshold segmentation algorithm for skin
    skin_mask = (Cb >= Cb_min & Cb <= Cb_max) & (Cr >= Cr_min & Cr <= Cr_max) & Y >= 80 ;

    % Set the skin to white and the rest to black
    binary_img = uint8(skin_mask) * 255;

    % Fill holes in the binary image
    binary_img = imfill(binary_img, 'holes');
    
    se = strel('square', 11);
    binary_img = imclose(binary_img, se);
    
    % Expand for image (10) to work
    se2 = strel('sphere', 24);
    binary_img = imdilate(binary_img, se2);
end
