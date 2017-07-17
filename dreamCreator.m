%% Deep Dream Images Using AlexNet
% This example shows how to generate images using |deepDreamImage| with the
% pretrained convolutional neural network AlexNet.
%
% Deep Dream is a feature visualization technique in deep learning that
% synthesizes images that strongly activate network layers. By visualizing
% these images, you can highlight the image features learned by a network.
% These images are useful for understanding and diagnosing network
% behavior.
%
% You can generate interesting images by visualizing the features of the
% layers towards the end of the network.
%
% The example uses Neural Network Toolbox(TM), Neural Network Toolbox Model
% _for AlexNet Network_ to generate the images. Optionally, you can use
% Image Processing Toolbox(TM) to display multiple images together.

% directory management
motherShip = fileparts(which(mfilename)); % The program directory
cd(motherShip) % go there just in case we are far away
addpath(genpath(motherShip)); % add the folder and subfolders to path
stimPath = [motherShip, '/jpgs/trainVal/hard/'];
outPath = [motherShip, '/dreamOutputs'];

myInputImg = 0; % input 0 to start from noise, otherwise start from input in stimPath
nImgs = 5;

channels = 1:12;
iterations = 10;
levels = 10;

%% Load Pretrained Network
% Load pretrained AlexNet Network (Neural Network Toolbox for AlexNet
% Model). If Neural Network Toolbox Model _for AlexNet Network_ is not
% installed, then the software provides a download link.
net = convnet;
net.Layers

%% Generate Images

for layer = 11 [2,5,8,11]
layer
    %% create dream
    % Choisir True (ou 1) pour utiliser sa propre image OU mettre False (ou 0) pour commencer
    % avec du bruit.
    if myInputImg
        % get file names 
        files = dir([stimPath,'*.jpg']);
        names = {files.name};
        for i = 1:nImgs
            currImg = names{i*20};
            img = imread([stimPath,currImg]);
            figure(2)
            imshow(img)
            I = deepDreamImage(net,layer,channels, ...
                'Verbose',true, ...
                'NumIterations',iterations, ...
                'PyramidLevels',levels, ...
                'InitialImage', img);
            
            cd(outPath)
            figure(1)
            montage(I)
            title([currImg(1:end-4), ' layer ', num2str(layer)])
            drawnow
            saveas(gcf,[currImg(1:end-4), ' layer', num2str(layer), ' iter', num2str(iterations), ...
                ' pyr', num2str(levels), '.jpg'])
            cd(motherShip)
        end
    else
        I = deepDreamImage(net,layer,channels, ...
            'Verbose',true, ...
            'NumIterations',iterations, ...
            'PyramidLevels',levels);
        cd(outPath)
        figure(1)
        montage(I)
        title([currImg(1:end-4), ' layer ', num2str(layer)])
        drawnow
        saveas(gcf,['random input', ' layer', num2str(layer), ' iter', num2str(iterations), ...
            ' pyr', num2str(levels), 'dream.jpg'])
        cd(motherShip)
   end
end