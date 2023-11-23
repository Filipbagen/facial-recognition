function [zoomedImage] = Remake_scale(img)
    
 % Get the size of the image
    [rows, cols, ~] = size(img);

    % Calculate the center of the image
    centerX = floor(cols / 2);
    centerY = floor(rows / 2);

    min=0.5;
    max=1.5;

    % Generate a random tone change factor
    scalingFactor = rand() * (max - min) + min;

    % Generate a random scaling factor within the specified range
    %scalingFactor = randi([scaleRange(1), scaleRange(2)]);

    % Calculate the cropping box
    cropBox = [centerX - floor(cols * scalingFactor / 2), ...
               centerY - floor(rows * scalingFactor / 2), ...
               floor(cols * scalingFactor), ...
               floor(rows * scalingFactor)];

    % Crop and resize the image
    zoomedImage = imcrop(imresize(img, scalingFactor), cropBox);
   


    % Display the original and zoomed-in images (optional)
    figure;
    subplot(1, 2, 1);
    imshow(img);
    title('Original Image');

    subplot(1, 2, 2);
    imshow(zoomedImage);
    title(['Zoomed-In Image (Scale: ' num2str(scalingFactor) ')']);
end

