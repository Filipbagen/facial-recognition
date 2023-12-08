function [FMEM] = EyeFilter(img)
    % Combining Eye Map and Face Mask to detect the eyes 
    FMEM = EyeMap(img) & FaceMask(img);

    % Create a mask to remove white areas from the bottom up to 25% of the image
    [rows, cols] = size(FMEM);
    maskBottom = ones(rows, cols);
    
    % Define the percentage of the image height to remove (25% from the bottom)
    removePercentageBottom = 0.25;
    removeRowsBottom = round(rows * removePercentageBottom);
    
    % Apply the mask to FMEM
    maskBottom(end - removeRowsBottom + 1:end, :) = 0;
    FMEM = FMEM & maskBottom;

    % Create a mask to remove white areas from the top down to 25% of the image
    maskTop = ones(rows, cols);
    
    % Define the percentage of the image height to remove (25% from the top)
    removePercentageTop = 0.25;
    removeRowsTop = round(rows * removePercentageTop);
    
    % Apply the mask to FMEM
    maskTop(1:removeRowsTop, :) = 0;
    FMEM = FMEM & maskTop;

    % Create a mask to remove white areas from the left and right sides
    maskLeftRight = ones(rows, cols);
    
    % Define the percentage of the image width to remove (10% from each side)
    removePercentageLR = 0.20;
    removeColsLR = round(cols * removePercentageLR);
    
    % Apply the mask to FMEM
    maskLeftRight(:, 1:removeColsLR) = 0;
    maskLeftRight(:, end - removeColsLR + 1:end) = 0;
    FMEM = FMEM & maskLeftRight;

    % Remove small white blobs - Adjust the minimum blob size based on your requirements
    minBlobSize = 238; 
    FMEM = bwareaopen(FMEM, minBlobSize);
end
