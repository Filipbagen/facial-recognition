# Facial Detection and Recognition

## Overview
This project, part of Linköping University’s [Advanced Image Processing (TNM034)](https://studieinfo.liu.se/en/kurs/tnm034) course, implemented facial recognition using image processing and machine learning. The program utilized the [Caltech Faces Dataset 1999](https://data.caltech.edu/records/6rjah-hdv18) and it trained a model to identify 16 out of 27 individuals, assigning each a unique ID. The program recognized faces within its training set and labels unknown faces as ‘0’. It integrates techniques like the Viola-Jones algorithm for detection, PCA and LDA for feature extraction and SVM for classification.

## Methods
* **Image Processing:** Involves manual feature extraction and comparison.
* **Machine Learning:** Uses the Viola-Jones algorithm for face detection and SVM for classification.
* **Image Degradation:** To test accuracy with varied data, the program applies a random rotation (±5 degrees), scaling (±10%), and brightness adjustment (±15%) to the input image.

## Datasets
* DB1: Contains images for recognition.
* DB2: Provides images with different backgrounds and lighting for testing robustness.

## Results
| Model           | Accuracy DB1   | Accuracy DB2   |
| -------------   | -------------  | -------------  |
| Fisherfaces     | 93.75%         |    89.47%      |
| Eigenfaces      | 25%            |     2.63%      |

## Technologies
* MATLAB with Computer Vision and Image Processing Toolboxes.
* Principal Component Analysis (PCA) and Fisher Linear Discriminant (FLD) for feature reduction and classification.

## Usage
To run the program:

1. Set the MATLAB working directory to the source directory
2. Execute the command ```id = tnm034(image, method);```

Where:

* `image`: The face image for recognition (from DB1 or DB2).
* `method`: The recognition method (‘fisherface’ or ‘eigenface’).
* `id`: The output, representing the recognized person’s ID (1-16) or 0 for unknown faces.
