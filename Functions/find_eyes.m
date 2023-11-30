function [eyes] = find_eyes(img)

    %%%%%%%%%%%%%%%% Crop the Image %%%%%%%%%%%%%%%%%%%%%
    [rows, cols, ~] = size(img);

    % Calculate the cropping margins (10% on each side)
    cropMarginRows = round(0.1 * rows);
    cropMarginCols = round(0.1 * cols);

    % Crop the image
    img = imcrop(img, [cropMarginCols, cropMarginRows, cols - 2*cropMarginCols, rows - 2*cropMarginRows]);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%% Lighting compensation - Gray World & White Patch %%%%%
    % GW = GrayWorld(img);
    % imshow(GW)
    WP = white_patch(img);
    % imshow(WP)


    %%%%%%% Color Space + FaceMask  %%%%%%%%%%%%%%%%%%%%%
    testFM = FaceMask(WP);
    %imshow(testFM)

    %%%%%%%%%%%% Eye map: Chrominance & Luminance %%%%%%%%%%%%
    binaryEyeMap = EyeMap(WP);
    %imshow(binaryEyeMap)


    %%%%%%%%%%%%%% Tidigare kod för att hitta circles från ansikte %%%
    %[FMEM, circle, randii] = EyeFilter(WP);
    [FMEM] = EyeFilter(WP);
    %imshow(FMEM)

    % circle;
    % centersStrong5 = circle(1:2,:);
    % radiiStrong5 = randii(1:2);
    % viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');

    % BW1 = edge(FMEM,'sobel');
    % imshow(BW1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%% Mouth map? %%%%%%%%%%%%%%%%%%%%%%%%%
    [mouth_Map, mouth_center] = MouthMap(WP);
    %imshow(mouth_Map)

    % disp('Mouth Center Coordinates:');
    % disp(mouth_center)


    %%%%%%%%%%%%%% Face Boundary %%%%%%%%%%%%%%%%%%%%%%%% 
    % Assuming you have the input image 'img'
    [eyes, mouth] = face_boundary(WP);

    % Display the original image
    figure;
    imshow(WP);
    hold on;

    %Plot the mouth center
    plot(mouth(1), mouth(2), 'r*', 'MarkerSize', 10);

    %Plot the detected eyes
    if ~isempty(eyes)
        plot(eyes(1, 1), eyes(1, 2), 'go', 'MarkerSize', 10); % Left eye
        plot(eyes(2, 1), eyes(2, 2), 'bo', 'MarkerSize', 10); % Right eye
    end

    hold off;
    
    eyes;
end

