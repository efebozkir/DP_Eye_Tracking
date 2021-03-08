clc;clear;
% Set this accordingly:
datasetToUse = 1; %% For MPIIDPEye
% datasetToUse = 2; %% For MPIIPrivacEye

if datasetToUse == 1
    ReadMPIIDPEye;
    differenceOutputPath = './DifferenceMatrices/MPIIDPEyeDifference.mat';
elseif datasetToUse == 2
    ReadMPIIPrivacEye;
    differenceOutputPath = './DifferenceMatrices/MPIIPrivacEyeDifference.mat';
end

calculateDifferencesAndStore(pamiFeaturesAll, recordingSizeArr, differenceOutputPath);