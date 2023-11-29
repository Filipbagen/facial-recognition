function [eyes, mouth] = face_boundary(img)
    % Get eye properties
    eye_props = regionprops(EyeFilter(img), 'Centroid');
    
    % Get mouth position to find eyes
    [~, mouth] = MouthMap(img);

    % Find values for all eye candidates 
    n_eyes = numel(eye_props);

    % Empty variables
    dist_eyes = zeros(n_eyes, 1); 
    eye_candidates = zeros(2, 2, n_eyes);
    index = 0;

    % Save center of mouth to variables
    x_mouth = mouth(1);
    y_mouth = mouth(2);

    % If we have more than 2 eye candidates
    if n_eyes > 1
        % Loop through eye candidates
        for i = 1:n_eyes
            for j = i+1:n_eyes
                y1 = eye_props(i).Centroid(2);
                y2 = eye_props(j).Centroid(2);
                x1 = eye_props(i).Centroid(1);
                x2 = eye_props(j).Centroid(1);

                % Save pair of eyes 
                eye_pairs = [x1 y1; x2 y2];

                % Only saves eyes with smaller y-value than mouth
                % and one eye on both sides of mouth
                if(y_mouth > y1 && y_mouth > y2)                
                    if(x1 < x_mouth && x_mouth < x2)
                        % Save all confirmed eye pair to eye candidates
                        index = index + 1;
                        eye_candidates(:, :, index) = eye_pairs;                                                           
                        dist_eyes(index) = sqrt((x1 - x2)^2 + (y1 - y2)^2);   
                    end
                end 
            end
        end
    else
        eyes = [];  % Not enough eye candidates
        return;
    end

    % Save only 2 eye candidates
    min_dist = Inf;
    for i = 1:index
        y1 = eye_candidates(1, 2, i);
        y2 = eye_candidates(2, 2, i);
        x1 = eye_candidates(1, 1, i);
        x2 = eye_candidates(2, 1, i);

        % Dist between mouth and both eyes
        dist1 = sqrt((x1 - x_mouth)^2 + (y_mouth - y1)^2);
        dist2 = sqrt((x2 - x_mouth)^2 + (y_mouth - y2)^2);

        % Find minimum dist difference between mouth and eyes
        % Distance between eyes should be smaller than 1.5 times the 
        % distance between eye and mouth (1.5 is tested and gave the best result)
        if abs(dist1 - dist2) < min_dist && dist1 < 1.5 * dist_eyes(i) && dist2 < 1.5 * dist_eyes(i)         
            min_dist = abs(dist1 - dist2);            
            eyes = eye_candidates(:, :, i);
        end
    end
end
