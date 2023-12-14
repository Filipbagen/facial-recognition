function croppedImage = crop_img(img, eyes)

    x1 = eyes(1);
    y1 = eyes(3);
    x2 = eyes(2);
    y2 = eyes(4);
    
    % Calculate the angle in radians
    angle_rad = atan2(y2 - y1, x2 - x1);

    % Initialization
    [imageHeight, imageWidth, ~] = size(img);
    centerX = floor(imageWidth/2 + 1);
    centerY = floor(imageHeight/2 + 1);
    
    % Pad
    padRow = round((imageHeight) / 2);
    padCol = round((imageWidth) / 2);
    zoomedImg = padarray(img, [padRow, padCol], 0, 'both');

    % Calculate translation values
    dx = centerX - x1;
    dy = centerY - y1;

    % Translate the image to position the left eye at the center
    translatedImage = imtranslate(zoomedImg, [dx, dy]);
    
    % Rotate the translated image around the center with padding
    rot = imrotate(translatedImage, 0, 'bicubic', 'loose');   

     % Initialization for rotated image
    [imageHeight2, imageWidth2, ~] = size(rot);
    centerX2 = floor(imageWidth2/2 + 1);
    centerY2 = floor(imageHeight2/2 + 1);

    % Calculate new coordinates for the second point after rotation
    newX = (x2 - x1) * cos(angle_rad) + (y2 - y1) * sin(angle_rad) + x1;
    
    eye_dist=newX-x1;
    
    % Define the cropping dimensions based on your requirements
    cropX = round(centerX2-(eye_dist/3)); % specify the starting X coordinate for cropping
    cropY = round(centerY2-((2/3)*eye_dist)); % specify the starting Y coordinate for cropping
    cropWidth = round((5/3)*(eye_dist)); % specify the width for cropping
    cropHeight = round((4/3)*cropWidth); % specify the height for cropping

    % Crop the rotated image
    croppedRotatedImage = rot(cropY : cropY + cropHeight - 1, cropX : cropX + cropWidth - 1, :);
    croppedImage = imresize(croppedRotatedImage,[400,300]);
end
