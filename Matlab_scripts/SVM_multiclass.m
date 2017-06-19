                            %% ST

% Proyect: Keyboard sounds recognition.

%% This script is aiming to compare both methods used to stract features
% through a SVM classification.

%% We load the data obtained in the script feature_extraction.m
xdata1 = [v_features_A_MFCC ; v_features_C_MFCC ; v_features_ENTER_MFCC ; v_features_M_MFCC ; v_features_O_MFCC ; v_features_R_MFCC ; v_features_SPACE_MFCC];
xdata2 = [v_features_A_CNN ; v_features_C_CNN ; v_features_ENTER_CNN ; v_features_M_CNN ; v_features_O_CNN ; v_features_R_CNN ; v_features_SPACE_CNN];
group = label_seven_keys;
rng(1); % For reproducibility
% Create an SVM template. It is good practice to standardize the predictors
t = templateSVM('Standardize',1);

%% Train Multiclass Model Using SVM Learners
Kfold = 10;
index = crossvalind('Kfold',group,Kfold);   
cp1 = classperf(group);
cp2 = classperf(group);

for i = 1:Kfold
    test = (index == i); 
    train = ~test;
    
    % svmtrain computes the SVM decision hyperplane using training samples
    % and a linear kernel.
    MFCC_Mdl = fitcecoc(xdata1(train,:),group(train,:),'Learners',t,'ClassNames',{'A','C','ENTER','M','O','R','SPACE'});
    CNN_Mdl = fitcecoc(xdata2(train,:),group(train,:),'Learners',t,'ClassNames',{'A','C','ENTER','M','O','R','SPACE'});
        
    % svmclassify uses the results of svmtrain to sort the data points.
    class_MFCC=predict(MFCC_Mdl,xdata1(test,:));
    class_CNN=predict(CNN_Mdl,xdata2(test,:));
    
    % classperf evaluates the goodness of the classification
    classification_MFCC=classperf(cp1,class_MFCC,test);
    classification_CNN=classperf(cp2,class_CNN,test);
end

%% Predict words with multiclass SVM
%word = v_features_MARCO;
%label = predict(MFCC_Mdl,word);
