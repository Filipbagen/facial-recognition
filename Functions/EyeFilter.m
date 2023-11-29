function [FMEM, circles, randii] = EyeFilter(img)
    % Combining Eye Map and Face Mask to detect the eyes 
    FMEM = EyeMap(img) & FaceMask(img);

    % Create a mask to remove white areas from the bottom up to 25% of the image
    [rows, cols] = size(FMEM);
    maskBottom = ones(rows, cols);
    
    % Define the percentage of the image height to remove (25% from the bottom)
    removePercentage = 0.25;
    removeRows = round(rows * removePercentage);
    
    % Apply the mask to FMEM
    maskBottom(end - removeRows + 1:end, :) = 0;
    FMEM = FMEM & maskBottom;

    % Create a mask to remove white areas from the top down to 25% of the image
    maskTop = ones(rows, cols);
    
    % Define the percentage of the image height to remove (25% from the top)
    removePercentage = 0.25;
    removeRows = round(rows * removePercentage);
    
    % Apply the mask to FMEM
    maskTop(1:removeRows, :) = 0;
    FMEM = FMEM & maskTop;

    % Remove small white blobs
    minBlobSize = 230; % Adjust the minimum blob size based on your requirements
    FMEM = bwareaopen(FMEM, minBlobSize);

    radiusRange = [4, 20]; % Adjust the radius range based on expected eye size
    sensitivity = 0.80; % Adjust the sensitivity based on your images
    [circles, randii] = imfindcircles(FMEM, radiusRange, 'Sensitivity', sensitivity);
end
