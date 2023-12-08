function [eyes, mouth] = face_boundary(img)

    % Get eye properties
    eye_props = regionprops(EyeFilter(img), 'Centroid');

    % Get mouth position to find eyes
    [~, mouth] = MouthMap(img);
    x_mouth = mouth(1);
    y_mouth = mouth(2);

    % The number of detected eyes is determined 
    number_eyes = numel(eye_props);

    % Early exit if not enough eye candidates
    if number_eyes < 2
        eyes = [];
        return;
    end

    % Extract centroids
    centroids = reshape([eye_props.Centroid], 2, number_eyes)';
    x_eyes = centroids(:, 1);
    y_eyes = centroids(:, 2);

    % Filter eyes above the mouth
    valid_eyes = y_eyes < y_mouth;
    x_eyes = x_eyes(valid_eyes);
    y_eyes = y_eyes(valid_eyes);

    % Prepare for combinations
    [X1, X2] = meshgrid(x_eyes, x_eyes);
    [Y1, Y2] = meshgrid(y_eyes, y_eyes);

    % Filter out combinations not meeting the criteria
    valid_combinations = X1 < x_mouth & x_mouth < X2;
    eye_pairs = [X1(valid_combinations) Y1(valid_combinations) X2(valid_combinations) Y2(valid_combinations)];

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

        % Check distances
        if abs(dist1 - dist2) < min_dist && dist1 < 1.5 * current_distance && dist2 < 1.5 * current_distance         
            min_dist = abs(dist1 - dist2);            
            eyes = [x1 y1; x2 y2];
        end
    end

    % If no eyes are found
    if ~exist('eyes', 'var')
        eyes = [];
    end
end
