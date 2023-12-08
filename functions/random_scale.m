function [zoomedImg] = random_scale(img)
    
    % Original dimensions
    [rows, cols, ~] = size(img);
    
    % Generate a random zoom factor between 0.9 and 1.1
    zoomFactor = 0.9 + 0.2 * rand();
 
    % Resize the image
    resizedImg = imresize(img, zoomFactor);
    
    % Get the size of the resized image
    [rowsResized, colsResized, ~] = size(resizedImg);
    
    % Depending on whether the image is zoomed in or out, crop or pad it
    if zoomFactor > 1
        % Zoomed in - Crop the image
        startRow = round((rowsResized - rows) / 2);
        startCol = round((colsResized - cols) / 2);
        zoomedImg = resizedImg(startRow + 1:startRow + rows, startCol + 1:startCol + cols, :);
    else
        % Zoomed out - Pad the image with the original image
        
        % Calculate padding amounts for each dimension
        padRow = round((rows - rowsResized) / 2);
        padCol = round((cols - colsResized) / 2);
        
        % Ensure padding doesn't exceed the original image size
        padRow = min(padRow, size(img, 1));
        padCol = min(padCol, size(img, 2));
        
        % Initialize the zoomed image with the original content
        zoomedImg = img(1:rows, 1:cols, :);
        
        % Update the padded region with the resized content
        zoomedImg(padRow + 1:padRow + rowsResized, padCol + 1:padCol + colsResized, :) = resizedImg;
    end

end
