function Output = MouthMap(img)

% Convert RGB image to YCbCr Components
YCbCr = rgb2ycbcr(img);

%  % Convert to double and extract Cb & Cr
Cb = double(YCbCr(:,:,2));
Cr = double(YCbCr(:,:,3));

% Compulations 
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

% Dialted 
m_map2 = imdilate(m_map,SE);

% Normalize final output, avoiding division by zero
 max_m_map2 = max(m_map2(:));
 if max_m_map2 ~= 0
     Output = m_map2 ./ max_m_map2;
 else
     Output = m_map2;  % Avoid division by zero, output the original map
 end

%Output = m_map2./max(m_map2(:));

end