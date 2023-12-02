function [degraded_image] = degrade_img(img)

    % Convert originalImage to double for processing
    img = im2double(img);

    % Rotates the image (max +/-5 degrees),
    img = random_rotate(img);
    
    % Scales the image (max +/- 10%)
    img = random_scale(img);
    
    % Adjusts tone(contrast and brightness) and temperature (max +/- 30%)
    %img = random_tone(img);

    degraded_image = im2uint8(img);
    % degraded_image = img;
    
end