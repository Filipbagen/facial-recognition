function [rotatedImage] = random_rotate(Img)

    rotationRange = [-5, 5];  % Rotation range in degrees
    
    % Generate a random rotation angle within the specified range
    rotationAngle = randi([rotationRange(1), rotationRange(2)])
    
   % Rotate the image
    rotatedImage = imrotate(Img, rotationAngle, 'bilinear', 'crop');

    % Create a binary mask based on values close to zero in each channel of the rotated image
    binaryMask = all(abs(rotatedImage) < 1e-6, 3);  % Tolerance for floating-point errors

    % Apply the mask to retain the original background for each channel
    for channel = 1:3
        rotatedImage(:,:,channel) = rotatedImage(:,:,channel) .* ~binaryMask + Img(:,:,channel) .* binaryMask;
    end
    
end

