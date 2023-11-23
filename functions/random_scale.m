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
        % Zoomed out - Pad the image
        padRow = round((rows - rowsResized) / 2);
        padCol = round((cols - colsResized) / 2);
        zoomedImg = padarray(resizedImg, [padRow, padCol], 0, 'both');
        zoomedImg = zoomedImg(1:rows, 1:cols, :); % Ensure the image size matches the original
    end
    
    % Display the original and zoomed images
    % subplot(1,2,1), imshow(img), title('Original Image');
    % subplot(1,2,2), imshow(zoomedImg), title(['Zoomed Image (Scale: ' num2str(zoomFactor) ')']);

end

