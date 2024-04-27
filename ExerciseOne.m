
function ExerciseOne

colourImage = imread("TestImage.jpg");

%Task 1 Carrying out Image Enhancement
stretchedImage = ImageEnhancement(colourImage);

%We define a threshold say 
threshold = 150;

%Task 2. Binarization
binaryMask = Binarization(stretchedImage, threshold);

%Task3. Morphological Operators
MorphologicalFiltering(stretchedImage, binaryMask);

end



%Task 1
%------------------------------------------------------------------------
function stretchedImage = ImageEnhancement(colourImage)

% Converting the coloured image to greyscale
greyImage = rgb2gray(colourImage);

% a.Visualizing the initial image and corresponding histogram
figure; 
subplot(2, 1, 1);
imshow(greyImage); % displaying the grey scale image
title("Grey Scale Image");

subplot(2, 1, 2);
imhist(greyImage); % displaying the histogram of the grey image
title("Grey Image Histogram");
xlabel('Pixel Intensity');
ylabel('Frequency');


%c. Enhancing the image using contrast stretching
[frequency, intensity] = imhist(greyImage);

Imax = max(intensity(frequency > 0)); % gives the maximum intensity number
Imin = min(intensity(frequency > 0)); % gives the minimum intensity number

disp(['Maximum intensity value: ', num2str(Imax)]);
disp(['Minimum intensity value: ', num2str(Imin)]);

%Computing stretched image and scaling with maximum grey value
stretchedImage = (double(greyImage) - Imin) * (255 / (Imax - Imin));

% setting the two thresholds [0, 255] range
stretchedImage(stretchedImage < 0) = 0;
stretchedImage(stretchedImage > 255) = 255;

% Convert stretched image back to 8bits
stretchedImage = uint8(stretchedImage);


% Display the stretched image and its histogram
figure;
subplot(2, 1, 1);
imshow(stretchedImage); % displaying the stretched image
title("Stretched Image");

subplot(2, 1, 2);
imhist(stretchedImage); % displaying the histogram of the stretched image
title("Stretched Image Histogram");
xlabel('Pixel Intensity');
ylabel('Frequency');

end


%Task 2: Binarization
%-----------------------------------------------------------------------
function binaryMask = Binarization(stretchedImage, threshold)

binaryMask = stretchedImage < threshold; % Binary mask with 1 for foreground and 0 for background

% Display the binary mask
figure;
imshow(binaryMask);
title('Binary Mask (0: Background, 1: Foreground)');

end

%Task 3: Morphological operators
%------------------------------------------------------------------------
function MorphologicalFiltering(stretchedImage, binaryMask)

%3a.Successively applying morphological opening and closing on the mask
%Defining a structuring element assuming a radius of 5
structElement = strel('disk', 5);

%Performing opening on the binary mask
openingMask = imopen(binaryMask, structElement);

%Performing closing from the opening mask
closingMask = imclose(openingMask, structElement);

%3b.Visualizing the overlay of the contrast enhanced image and the final filtered mask

%Display the filtered binary mask
figure;
imshow(closingMask);
title('Filtered Binary Mask (0: Background, 1: Foreground)');

% Visualizing the overlay of the stretched image and the final filtered mask
overlayImage = stretchedImage;
overlayImage(closingMask) = 255; %setting foreground pixels to white

% Display the overlay image
figure;
imshow(overlayImage);
title('Overlay of Stretched Image and Filtered Mask');

end