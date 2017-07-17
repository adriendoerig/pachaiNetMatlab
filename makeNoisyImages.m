plotting = 0;

cd jpgs/easyNoNoise
nCopies = 20;
files = dir('*.jpg');
names = {files.name};

for img = 1:length(names)
    currImg = imread(names{img});
    currImg = rgb2gray(currImg);
    currImg = imresize(currImg, [60 100]);
    sz = size(currImg);
    cd ../trainVal/easy
    for i = 1:nCopies
        noisyImg = double(currImg) + 10*randn(sz(1), sz(2));
        noisyImg(noisyImg<0) = 0;
        noisyImg(noisyImg>255) = 255;
        noisyImg = uint8(noisyImg);
        if plotting
            figure(1)
            imshow(noisyImg)
            truesize
            drawnow
        end
        imwrite(noisyImg, [names{img}(1:end-4), '_', num2str(i), '.jpg'])
    end
    %percent done
    round(img/(2*length(names))*100)
    cd ../../easyNoNoise
end
cd ..

cd hardNoNoise
nCopies = 20;
files = dir('*.jpg');
names = {files.name};

for img = 1:length(names)
    currImg = imread(names{img});
    currImg = rgb2gray(currImg);
    currImg = imresize(currImg, [60 100]);
    sz = size(currImg);
    cd ../trainVal/hard
    for i = 1:nCopies
        noisyImg = double(currImg) + 20*randn(sz(1), sz(2));
        noisyImg(noisyImg<0) = 0;
        noisyImg(noisyImg>255) = 255;
        noisyImg = uint8(noisyImg);
        if plotting
            figure(1)
            imshow(noisyImg)
            truesize
            drawnow
        end
        imwrite(noisyImg, [names{img}(1:end-4), '_', num2str(i), '.jpg'])
    end
    %percent done
    round((length(names)+img)/(2*length(names))*100)
    cd ../../hardNoNoise
end

cd ../../..