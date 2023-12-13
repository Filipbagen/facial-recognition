function fisherWeights = project_onto_fisherfaces(inputImage, fisherfaces, meanFace)
    queryImg = im2gray(inputImage);
    queryImgVector = double(reshape(queryImg, 1, [])) - meanFace;
    fisherWeights = queryImgVector * fisherfaces;
end
