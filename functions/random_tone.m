function [adjustedImage] = random_tone(img)
  
    % Define the range for the random tone change (-30% to 30%)
    minToneChange = 0.75;
    maxToneChange = 1.12;

    % Generate a random tone change factor
    toneChangePercentage = rand() * (maxToneChange - minToneChange) + minToneChange;

    % Adjust the tone of the image (only brightness)
    adjustedImage = img * toneChangePercentage;
    
    % Ensure the adjusted image is within the valid range [0, 1]
    adjustedImage = max(min(adjustedImage, 1), 0);
end
