function [rotatedImage] = random_rotate(Img)

    rotationRange = [-5, 5];  % Rotation range in degrees
    
    % Generate a random rotation angle within the specified range
    rotationAngle = randi([rotationRange(1), rotationRange(2)]);
    
    % Rotate the cropped image
    rotatedImage = imrotate(Img, rotationAngle, 'bilinear', 'crop');
    
    
    
    % Display the original, scaled, and rotated images (optional)
    % figure;
    % subplot(1, 3, 1);
    % imshow(Img);
    % title('Original Image');
    
    % subplot(1, 3, 3);
    % imshow(rotatedImage);
    % title(['Rotated Image (' num2str(rotationAngle) ' degrees)']);

end

