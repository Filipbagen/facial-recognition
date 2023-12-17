% function queryWeights = project_onto_eigenfaces(inputImage, eigenfaces, meanFace)
% 
%     queryImg = inputImage;
%     queryImgGray = im2gray(queryImg);
%     queryImgVector = reshape(queryImgGray, 1, []);
% 
%     queryImgMeanSubtracted = double(queryImgVector) - meanFace;
%     queryWeights = queryImgMeanSubtracted * eigenfaces;
% end


function queryWeights = project_onto_eigenfaces(inputImage, eigenfaces, meanFace)

    % Reshape the image to a vector
    queryImgVector = double(reshape(inputImage, 1, []));

    % Subtract the mean face from the query image vector
    queryImgMeanSubtracted = queryImgVector - meanFace;

    % Project the mean subtracted vector onto the eigenfaces space
    queryWeights = queryImgMeanSubtracted * eigenfaces;
end
