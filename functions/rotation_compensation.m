function [rotatedImage] = rotation_compensation(img)
    figure;
    imshow(img);
    [x, y] = ginput(2);
    y_diff = y(1) - y(2);
    x_diff = x(1) - x(2);
    
    % Calculate the angle in radians
    angle_rad = atan2(y_diff, x_diff);
    
    % Convert angle to degrees
    angle_deg = rad2deg(angle_rad) - 180;
    
    % Rotate the cropped image
    rotatedImage = imrotate(img, angle_deg, 'bilinear', 'loose');
    
    % disp(['Angle relative to x-axis: ' num2str(angle_deg) ' degrees']);
    % figure;
    % subplot(1, 3, 1);
    % imshow(img);
    % title('Original Image');
    
    % subplot(1, 3, 3);
    % imshow(rotatedImage);
    % title(['Rotated Image (' num2str(angle_deg) ' degrees)']);
end

