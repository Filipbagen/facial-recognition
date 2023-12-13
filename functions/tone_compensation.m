function [result] = tone_compensation(originalRGB)

    % Separate the image into three channels (R, G, B)
    redChannel = originalRGB(:, :, 1);
    greenChannel = originalRGB(:, :, 2);
    blueChannel = originalRGB(:, :, 3);

    % Adjust the tone and intensity for each channel using imadjust
    adjustedRedChannel = imadjust(redChannel);
    adjustedGreenChannel = imadjust(greenChannel);
    adjustedBlueChannel = imadjust(blueChannel);

    % Combine the adjusted channels to get the final adjusted image
    result = cat(3, adjustedRedChannel, adjustedGreenChannel, adjustedBlueChannel);
end
