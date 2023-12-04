function [result] = tone_compensation(originalRGB)
    % gray_image = rgb2gray(image)
    % [counts, intensities] = imhist(gray_image, 2^16)
    % cumulative_counts = cumsum(counts)
    % index = find(cumulative_counts >= numel(gray_image) * 0.5, 1, 'first')
    % intensity = intensities(index)
    % %if(intensity < 0.5); intensity = 0.5; end
    % result = immultiply(image, 0.5 / intensity)

% % Perform intensity compensation for each color channel
% compensatedR = histeq(originalRGB(:,:,1));
% compensatedG = histeq(originalRGB(:,:,2));
% compensatedB = histeq(originalRGB(:,:,3));
% 
% % Combine the compensated channels to get the final RGB image
% result = cat(3, compensatedR, compensatedG, compensatedB);

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

