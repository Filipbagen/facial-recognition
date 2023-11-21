function queryWeights = projectOntoEigenfaces(queryImagePath, eigenfaces, meanFace, commonSize)
    queryImg = imread(queryImagePath);
    queryImgGray = im2gray(queryImg);
    queryImgResized = imresize(queryImgGray, commonSize);
    queryImgVector = reshape(queryImgResized, 1, []);

    queryImgMeanSubtracted = double(queryImgVector) - meanFace;
    queryWeights = queryImgMeanSubtracted * eigenfaces;
end
