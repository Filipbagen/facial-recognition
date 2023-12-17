function [eyes, mouth] = face_boundary(img)

    % Get eye properties
    eye_props = regionprops(eye_filter(img), 'Centroid');

    % Get mouth position to find eyes
    [~, mouth] = mouth_map(img);
    x_mouth = mouth(1);
    y_mouth = mouth(2);

    % The number of detected eyes is determined 
    number_eyes = numel(eye_props);

    % If there are no eyes, display a message and exit
    if number_eyes < 1
        disp('No eyes detected.');
        eyes = [];
        return;
    end

    % Extract centroids
    centroids = reshape([eye_props.Centroid], 2, number_eyes)';
    x_eyes = centroids(:, 1);
    y_eyes = centroids(:, 2);

    % Set some_value as a percentage of the mouth height to get rid off
    % false-positive values
    some_value_percentage = 20; % Worked the best for all images
    some_value = some_value_percentage / 100 * y_mouth;
    y_threshold = y_mouth - some_value;


    % Prepare for combinations
    [X1, X2] = meshgrid(x_eyes, x_eyes);
    [Y1, Y2] = meshgrid(y_eyes, y_eyes);

    % Filter out combinations not meeting the criteria
    valid_combinations = X1 < x_mouth & x_mouth < X2 & Y1 < y_mouth & Y2 < y_threshold;
    eye_pairs = [X1(valid_combinations) Y1(valid_combinations) X2(valid_combinations) Y2(valid_combinations)];

    % If there are no valid combinations, exit
    if isempty(eye_pairs)
        disp('Exiting early: No valid eye pairs after combinations.');
        eyes = [];
        % return;

    else 

        % Calculate distances
        distances = sqrt((eye_pairs(:,1) - eye_pairs(:,3)).^2 + (eye_pairs(:,2) - eye_pairs(:,4)).^2);
    
        % Initialize minimum distance
        min_dist = Inf;
    
        % Iterate over valid combinations
        for i = 1:size(eye_pairs, 1)
            % Extract pair
            x1 = eye_pairs(i, 1);
            y1 = eye_pairs(i, 2);
            x2 = eye_pairs(i, 3);
            y2 = eye_pairs(i, 4);
            current_distance = distances(i);
    
            % Calculate mouth-eye distances
            dist1 = sqrt((x1 - x_mouth)^2 + (y_mouth - y1)^2);
            dist2 = sqrt((x2 - x_mouth)^2 + (y_mouth - y2)^2);
            
            % Making sure that the eye pair have similar y-coordinate (otehrwise not a pair)
            some_value_percentage = 5; 
            some_value = some_value_percentage / 100 * size(img, 1);
    
    
            % Check distances and y-coordinate threshold
            if abs(dist1 - dist2) < min_dist && dist1 < 1.5 * current_distance && dist2 < 1.5 * current_distance && abs(y1 - y2) < some_value
                min_dist = abs(dist1 - dist2);            
                eyes = [x1 y1; x2 y2];
            end
    
        end
    end




    % % Visualization of the results
    % if ~isempty(eyes)
    %     % Display the original image
    %     figure;
    %     imshow(img);
    %     hold on; % Keep the image displayed while plotting points
    % 
    %     % Plot the eye coordinates
    %     plot(eyes(:,1), eyes(:,2), 'r+', 'MarkerSize', 10, 'LineWidth', 2); % Eyes with red cross
    % 
    %     % Plot the mouth coordinates if mouth is detected
    %     if ~isempty(mouth)
    %         plot(mouth(1), mouth(2), 'b+', 'MarkerSize', 10, 'LineWidth', 2); % Mouth with blue cross
    %     end
    % 
    %     hold off; % Release the hold to prevent further plotting on this image
    %     title('Detected Facial Features');
    % end




    % If no eyes are found
    if ~exist('eyes', 'var')
        eyes = [];
        disp('Exiting: No valid eyes found.');
    end
end
