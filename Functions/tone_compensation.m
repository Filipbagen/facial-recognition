function [result] = tone_compensation(originalRGB)

    % % Separate the image into three channels (R, G, B)
    % redChannel = originalRGB(:, :, 1);
    % greenChannel = originalRGB(:, :, 2);
    % blueChannel = originalRGB(:, :, 3);
    % 
    % 
    % %Adjust the tone and intensity for each channel using imadjust
    % adjustedRedChannel = imadjust(redChannel);
    % adjustedGreenChannel = imadjust(greenChannel);
    % adjustedBlueChannel = imadjust(blueChannel);
    % 
    % %Combine the adjusted channels to get the final adjusted image
    % result = cat(3, adjustedRedChannel, adjustedGreenChannel, adjustedBlueChannel);

    %% grayworld
    % Split the image to r, g and b channels
    r = originalRGB(:,:,1);
    g = originalRGB(:,:,2);
    b = originalRGB(:,:,3);
    
    % Compute mean:
    r_avg = mean(r);
    g_avg = mean(g);
    b_avg = mean(b);
    
    % Compute the gain for the red and green channel:
    alpha = g_avg/r_avg;
    beta = g_avg/b_avg;
    
    % Compute color corrected image
    r_sensor = alpha*r;
    g_sensor = g;
    b_sensor = beta*b;
    
    result = cat(3, r_sensor,g_sensor,b_sensor);
    result=result*0.9;

end
