% function [rotatedImage] = random_rotate(Img)
% 
%     rotationRange = [-5, 5];  % Rotation range in degrees
% 
% 
%     % Generate a random rotation angle within the specified range
%     rotationAngle = randi([rotationRange(1), rotationRange(2)]);
% 
% 
%     rotated = imrotate(Img, rotationAngle, 'bicubic');
%     crop_upper = max(find(diag(rotated) ~= 0));
%     crop_lower = min(find(diag(rotated) ~= 0));
%     crop_diff = crop_upper-crop_lower;
%     rotatedImage = imcrop(rotated, [crop_lower, crop_lower, crop_diff, crop_diff]);
% 
% 
% 
%     % Rotate the cropped image
%     % rotatedImage = imrotate(Img, rotationAngle, 'bilinear', 'crop');
% 
% end


function [rotatedImage] = random_rotate(Img)
    % Rotation range in degrees
    rotationRange = [-5, 5]; 

    % Generate a random rotation angle within the specified range
    rotationAngle = randi(rotationRange);

    % Rotate the image using 'loose' option to prevent any cropping
    rotated = imrotate(Img, rotationAngle, 'bicubic', 'crop');

    % Find the size of the rotated image
    [rotHeight, rotWidth, ~] = size(rotated);
    
    % Calculate the size of the largest rectangle that fits inside the rotated image
    % while maintaining the original aspect ratio
    origAspectRatio = size(Img, 2) / size(Img, 1);
    if rotWidth / rotHeight > origAspectRatio
        % If the rotated width is too wide, adjust it to maintain aspect ratio
        newWidth = rotHeight * origAspectRatio;
        cropX = (rotWidth - newWidth) / 2;
        cropWidth = newWidth;
        cropY = 0;
        cropHeight = rotHeight;
    else
        % If the rotated height is too tall, adjust it to maintain aspect ratio
        newHeight = rotWidth / origAspectRatio;
        cropY = (rotHeight - newHeight) / 2;
        cropHeight = newHeight;
        cropX = 0;
        cropWidth = rotWidth;
    end

    % Crop the image to the calculated coordinates
    rotatedImage = imcrop(rotated, [cropX, cropY, cropWidth, cropHeight]);
end


function cropCoords = getCropCoordinates(ang, originalWidth, originalHeight, rotatedSize)
    % Compute bounding box size
    bb_w = originalWidth * cos(ang) + originalHeight * sin(ang);
    bb_h = originalWidth * sin(ang) + originalHeight * cos(ang);

    % Compute the gamma angle
    if originalWidth < originalHeight
        gamma = atan2(bb_w, bb_h);
    else
        gamma = atan2(bb_h, bb_w);
    end

    % Compute delta angle
    delta = pi - ang - gamma;

    % Compute length 'd' based on the longer dimension of the original image
    length = max(originalWidth, originalHeight);
    d = length * cos(ang);
    a = d * sin(ang) / sin(delta);

    % Compute crop coordinates
    y = a * cos(gamma);
    x = y * tan(gamma);

    % Adjust crop size based on the rotated image size
    crop_w = min(bb_w - 2 * x, rotatedSize(2));
    crop_h = min(bb_h - 2 * y, rotatedSize(1));

    % Make sure the crop coordinates are within the image bounds
    x = max(0, x);
    y = max(0, y);

    cropCoords = struct('x', x, 'y', y, 'w', crop_w, 'h', crop_h);
end

