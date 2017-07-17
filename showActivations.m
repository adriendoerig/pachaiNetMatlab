% directory management
motherShip = fileparts(which(mfilename)); % The program directory
cd(motherShip) % go there just in case we are far away
addpath(genpath(motherShip)); % add the folder and subfolders to path
stimPath = [motherShip, '/jpgs/trainVal/easy/'];
outPath = [motherShip, '/activationOutputs'];

nImgs = 5;
files = dir([stimPath,'*.jpg']);
names = {files.name};

net = convnet;
layerNames = cell(1,length(net.Layers));
for l = 1:length(net.Layers)
    layerNames{l} = net.Layers(l).Name;
end

%% Generate Images

for i = 1:nImgs
    currImg = names{i*20};
    img = imread([stimPath,currImg]);

    cd(outPath)
    for layer = 2:length(layerNames)-2
        A = activations(net,img, layerNames{layer},'OutputAs','channels');
        sz = size(A);
        A = reshape(A,[sz(1) sz(2) 1 sz(3)]);
        
        figure(1)
        montage(mat2gray(A))
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        title([currImg(1:end-4), ' layer ', layerNames{layer}])
        waitforbuttonpress
        saveas(gcf,[currImg(1:end-4), ' layer ', layerNames{layer}, ' activations.jpg'])
    end
    cd(motherShip)
    
end