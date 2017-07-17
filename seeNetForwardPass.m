% directory management
motherShip = fileparts(which(mfilename)); % The program directory
cd(motherShip) % go there just in case we are far away
addpath(genpath(motherShip)); % add the folder and subfolders to path
stimPath = [motherShip, '/jpgs/trainVal/hard/'];

% get file names and create stimuli order
files = dir([stimPath,'*.jpg']);
names = {files.name};

nImgs = 100;

for i = 1:nImgs
    cd(stimPath)
    img = imread(names{i*10});
    cd(motherShip)
    imgClass = classify(convnet,img);
    
    figure(1)
    imshow(img)
    title(['class = ', char(imgClass)])
    drawnow
    pause(0.1)
end


