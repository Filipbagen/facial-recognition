function queryWeights = project_onto_eigenfaces(inputImage, eigenfaces, meanFace)

    queryImg = inputImage;
    queryImgGray = im2gray(queryImg);
    queryImgVector = reshape(queryImgGray, 1, []);

    queryImgMeanSubtracted = double(queryImgVector) - meanFace;
    queryWeights = queryImgMeanSubtracted * eigenfaces;
end
