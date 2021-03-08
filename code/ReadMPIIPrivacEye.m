% For demonstration purposes:
relativeFilePath = 'datasets/MPIIPrivacEye/Features_and_Ground_Truth/'
filenamePrefix = 'P';
filenameMid = '_R';
filenameSuffix = '_data.csv';

participantCounter = 20;
recordingCounter = 3;
totalNumberOfEyeMovementFeatures = 52;

filepathPrefix = strcat(relativeFilePath, filenamePrefix);
recordingSizeArr = [];
pamiFeaturesAll = [];
minPamiFeatures = [];
maxPamiFeatures = [];

for participantId = 1:participantCounter
    % These participantIds do not exist in the dataset, skip. 
    % It makes 17 participants in total.
    if participantId == 4 || participantId == 6 || participantId == 15
        continue;
    end
    for recordingId = 1:recordingCounter
        fullFilePath =  strcat(filepathPrefix, int2str(participantId), filenameMid, int2str(recordingId), filenameSuffix);
        completePamiTable = readtable(fullFilePath, 'ReadVariableNames',false);
        pamiFeatures = completePamiTable(:,1:totalNumberOfEyeMovementFeatures);
        pamiFeaturesArr = pamiFeatures{:,:};
        pamiFeaturesAll = [pamiFeaturesAll; pamiFeaturesArr];
        recordingSizeArr = [recordingSizeArr; size(pamiFeaturesArr, 1)];
    end
end

currentBlockStartIndx = 1;
startEndIndexMatRawPami = [];
for idx = 1:size(recordingSizeArr, 1)
    currentArrSize = recordingSizeArr(idx,1);
    startOfCurrentBlock = currentBlockStartIndx;
    endOfCurrentBlock = startOfCurrentBlock + currentArrSize - 1;
    currentBlock = pamiFeaturesAll(startOfCurrentBlock:endOfCurrentBlock,:);
    startEndVector = [startOfCurrentBlock, endOfCurrentBlock];
    
    startEndIndexMatRawPami = [startEndIndexMatRawPami; startEndVector];
    currentBlockStartIndx = currentBlockStartIndx + currentArrSize;
end
