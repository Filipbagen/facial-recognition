function [final_image] = sobel_eye_detection(image, AreaThreshold, EccentricityThreshold)
    grayI = rgb2gray(image);
    edges = edge(grayI, 'Sobel');
    
    se = strel('disk', 2);
    dilatedEdges = imdilate(edges, se);
    erodedEdges = imerode(dilatedEdges, se);
    
    props = regionprops(erodedEdges, 'BoundingBox', 'Area', 'Eccentricity');
    eyeCandidates = props([props.Area] > AreaThreshold & [props.Eccentricity] < EccentricityThreshold);
    
    % Creating a copy of the input image to draw rectangles on
    final_image = image;
    
    % Drawing rectangles around detected eye regions
    for k = 1 : length(eyeCandidates)
        final_image = insertShape(final_image, 'Rectangle', eyeCandidates(k).BoundingBox, 'Color', 'red', 'LineWidth', 2);
    end
end
