function [eyes, mouth] = find_eyes(img)


    %%%%%% Lighting compensation - Gray World & White Patch %%%%%
    % GW = GrayWorld(img);
    % imshow(GW)
    img = white_patch(img);
    % imshow(WP)


    %%%%%%%%%%%%%% Face Boundary %%%%%%%%%%%%%%%%%%%%%%%% 
    % Assuming you have the input image 'img'
    [eyes, mouth] = face_boundary(img);

    % If no eyes, error
    if isempty(eyes)
        error('no eyes');
    end

    % Display the original image
    % figure;
    % imshow(img);
    % title('Eyes and mouth');
    % hold on;
    % 
    % %Plot the mouth center
    % plot(mouth(1), mouth(2), 'r*', 'MarkerSize', 10, 'LineWidth', 5);
    % 
    % %Plot the detected eyes
    % if ~isempty(eyes)
    %     plot(eyes(1, 1), eyes(1, 2), 'go', 'MarkerSize', 10, 'LineWidth', 5); % Left eye
    %     plot(eyes(2, 1), eyes(2, 2), 'bo', 'MarkerSize', 10, 'LineWidth', 5); % Right eye
    % end
    % hold off;
end
