function [translatedImage] = random_translate(img)

  % Calculate translation values
    dx = -50 * rand(); %random between -50 and 0
    dy = 50 * rand(); %random between 0 and 50

    % Translate the image to position the left eye at the center
    translatedImage = imtranslate(img, [dx, dy]);

end

