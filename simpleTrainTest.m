%% Create Simple Deep Learning Network for Classification

%% Load and Explore the Image Data
% Load the configs sample data as an |ImageDatastore| object.

dataSet = imageDatastore('jpgs/trainVal', ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
    
%% 
% |imageDatastore| function labels the images automatically based on folder
% names and stores the data as an |ImageDatastore| object. An
% |ImageDatastore| object lets you store large image data, including data
% that do not fit in memory, and efficiently read batches of images during
% training of a convolutional neural network.

%% 
% Display some of the images in the datastore. 
figure;
perm = randperm(10000,20);
for i = 1:20
    subplot(4,5,i);
    imshow(dataSet.Files{perm(i)});
end

%%
% Check the number of images in each category. 
CountLabel = dataSet.countEachLabel;


%% 
% You must specify the size of the images in the input layer of the
% network. Check the size of the first image in |digitData| .
img = readimage(dataSet,1);
size(img)

%% Specify Training and Test Sets
% Divide the data into training and test sets, so that each category in the
% training set has trainingNumFiles images and the test set has the remaining images
% from each label.
trainingNumFiles = 8000;
% rng(1) % For reproducibility
% |splitEachLabel| splits the image files in |digitData| into two new datastores,
% |trainDigitData| and |testDigitData|.  
[trainDigitData,testDigitData] = splitEachLabel(dataSet, ...
				trainingNumFiles,'randomize'); 

%% Define the Network Layers
% Define the convolutional neural network architecture. 
layers = [imageInputLayer([60 100 1])
          convolution2dLayer(3,20)
          reluLayer
          maxPooling2dLayer(2,'Stride',2)
          convolution2dLayer(3,20)
          reluLayer
          maxPooling2dLayer(2,'Stride',2)
          convolution2dLayer(3,20)
          reluLayer
          maxPooling2dLayer(2,'Stride',2)
          fullyConnectedLayer(20)
          fullyConnectedLayer(2)
          softmaxLayer
          classificationLayer()] 


%%
% *Image Input Layer* An <docid:nnet_ref.bu4mb_9 imageInputLayer> is where
% you specify the image size, which, in this case, is 60-by-160-by-1. These
% numbers correspond to the height, width, and the channel size. You can also specify any data
% transformation at this layer, such as data normalization or data
% augmentation (randomly flip or crop the data). These are usually used to
% avoid overfitting. You do not need to shuffle the data as |trainNetwork|
% automatically does it at the beginning of the training.

%%
% *Convolutional Layer*
% In the convolutional layer, the first argument is |filterSize|, which is the
% height and width of the filters the training function uses while
% scanning along the images. The second argument is the number of
% filters, which is the number of neurons that connect to the same region
% of the output. This parameter determines the number of the feature maps.
% You can also define the |Stride| or learning rates for this layer in the
% call to <docid:nnet_ref.bu4i26l convolution2dLayer>.

%% 
% *ReLU Layer*
% The convolutional layer is followed by a nonlinear activation function.
% MATLAB uses the rectified linear unit function, specified by 
% <docid:nnet_ref.bu4mbw1 reluLayer>.

%%
% *Max-Pooling Layer*
% The convolutional layer (with the activation function) is usually
% followed by a down-sampling operation to reduce the number of parameters
% and as another way of avoiding overfitting. One way of down-sampling is
% max-pooling, which is specified by the <docid:nnet_ref.bu5lhn5
% maxPoolingLayer> function. This layer returns the maximum
% values of rectangular regions of inputs, specified by the first argument,
% |poolSize|. In this example, the size of the rectangular region is [2,2]. The optional
% argument |Stride| determines the step size the training function takes as
% it scans along the image. This max-pooling layer takes place between the
% convolutional layers when there are multiple of them in the network.

%%
% *Fully Connected Layer*
% The convolutional (and down-sampling) layers  are followed by one or more
% fully connected layers. As the name suggests, all neurons in a fully
% connected layer connect to the neurons in the layer previous to it. This
% layer combines all of the features (local information) learned by the
% previous layers across the image to identify the larger patterns. The
% last fully connected layer combines them to classify the images. That is
% why, the OutputSize parameter in the last fully connected layer is equal
% to the number of classes in the target data. 

%%
% *Softmax Layer* 
% The fully connected layer usually uses the softmax
% activation function for classification. You can add the softmax layer by
% using the <docid:nnet_ref.bu5lhgb softmaxLayer> function after the last
% fully connected layer.

%%
% *Classification Layer* 
% The final layer is the classification layer, defined by using the
% <docid:nnet_ref.bu5lho8 classificationLayer> function. This layer uses
% the probabilities returned by the softmax activation function for each
% input to assign it to one of the mutually exclusive classes.
% 
%% Specify the Training Options
% After defining the layers (network structure), specify the training
% options. Set the options to default settings for the stochastic gradient
% descent with momentum. Set the maximum number of epochs at 15 (an epoch
% is a full training cycle on the whole training data), and start the
% training with an initial learning rate of 0.0001.
options = trainingOptions('sgdm','MaxEpochs',150, ...
	'InitialLearnRate',0.0001);  

%% Train the Network Using Training Data
% Train the network you defined in layers, using the training data and the
% training options you defined in the previous steps.
convnet = trainNetwork(trainDigitData,layers,options);

%%
% |trainNetwork| displays the hardware it uses for training in the display
% window. It uses a GPU by default if there is one available (requires
% Parallel Computing Toolbox (TM) and a CUDA-enabled GPU with compute
% capability 3.0 and higher). If there is no available GPU, it uses a CPU.
% You can also specify the execution environment using the
% |'ExecutionEnvironment'| name-value pair argument in the call to
% |trainingOptions|.

%%
% The progress window shows the mini-batch loss and the mini-batch accuracy
% for the first iteration, last iteration and every 50 iterations in
% between. The mini-batch loss is the <docid:nnet_ref.bu80p30-3
% cross-entropy loss> and the mini-batch accuracy is the percentage of
% images in the current mini-batch that the network being trained correctly
% classifies.

%%
% It also shows the cumulative time it takes for training and the learning
% rate at that iteration. In this example, the base learning rate is fixed
% at 0.0001 through the entire training process. You can also adjust this
% and reduce the learning rate at certain number of epochs. For more
% details, see the |trainingOptions| function reference page.

%% Classify the Images in the Test Data and Compute Accuracy
% Run the trained network on the test set that was not used to train the
% network and predict the image labels (digits).
YTest = classify(convnet,testDigitData);
TTest = testDigitData.Labels;

%% 
% Calculate the accuracy. 
accuracy = sum(YTest == TTest)/numel(TTest)   

%%
% Accuracy is the ratio of the number of true labels in the test data
% matching the classifications from classify, to the number of images in
% the test data. In this case about 98% of the digit estimations match the
% true digit values in the test set.