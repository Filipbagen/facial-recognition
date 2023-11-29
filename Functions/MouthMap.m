function [mouth_Map, mouth_center] = MouthMap(img)
    % Convert RGB image to YCbCr Components
    YCbCr = rgb2ycbcr(img);

    % Convert to double and extract Cb & Cr
    Cb = double(YCbCr(:,:,2));
    Cr = double(YCbCr(:,:,3));

    % Computations 
    Cr2 = Cr.^2;
    Cr2n = 255.*(Cr2-min(Cr2))./(max(Cr2)-min(Cr2));

    CrCb = Cr./Cb;
    CrCbn = 255.*(CrCb-min(CrCb))./(max(CrCb)-min(CrCb));

    % Calculate parameter (n)
    n = 0.95*(mean2(Cr2n)/mean2(CrCbn));

    % Generate mouth map
    m_map = (Cr2) .* ((Cr2)-n.*(CrCb)).^2;

    % Dilation with a disk-shaped structuring element
    r = 10; 
    SE = strel('disk', r);

    % Dilated 
    m_map2 = imdilate(m_map,SE);

    % Normalize final output, avoiding division by zero
    max_m_map2 = max(m_map2(:));
    if max_m_map2 ~= 0
        normalized_m_map2 = m_map2 ./ max_m_map2;
    else
        normalized_m_map2 = m_map2;  % Avoid division by zero, output the original map
    end

    % Apply a threshold to make pixels below a certain intensity black
    threshold = 0.89; % Adjust the threshold as needed
    binary_mask = normalized_m_map2 > threshold;

    % Keep only the largest connected components (the mouth)
    num_largest_components = 1;  % Adjust as needed
    mouth_Map = bwareafilt(binary_mask, num_largest_components);

    % Find properties of connected regions in the mouth map
    mouth_props = regionprops(mouth_Map, 'Centroid', 'MajoraxisLength', 'MinoraxisLength', 'Orientation');

    % Initialize mouth_center
    mouth_center = [];

    % Check if there is at least one region in the mouth map
    if ~isempty(mouth_props)
        mouth_center = mouth_props.Centroid;
    end
end
