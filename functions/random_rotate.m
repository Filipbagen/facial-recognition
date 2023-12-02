function [rotatedImage] = random_rotate(Img)

    rotationRange = [-5, 5];  % Rotation range in degrees
    
    % Generate a random rotation angle within the specified range
    rotationAngle = randi([rotationRange(1), rotationRange(2)])
    
    % Rotate the cropped image
    rotatedImage = imrotate(Img, rotationAngle, 'bilinear', 'crop');
    
end

