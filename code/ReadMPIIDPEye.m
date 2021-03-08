% For demonstration purposes:
relativeFilePath = './datasets/MPIIDPEye/Eye_Movement_Features/'
filenamePrefix = 'Data_P';
filenameMid = '_R';
filenameSuffix = '_Pami_Features_52.csv';

participantCounter = 20;
recordingCounter = 3;

filepathPrefix = strcat(relativeFilePath, filenamePrefix);
recordingSizeArr = [];
pamiFeaturesAll = [];
minPamiFeatures = [];
maxPamiFeatures = [];

for participantId = 1:participantCounter
    for recordingId = 1:recordingCounter
        fullFilePath =  strcat(filepathPrefix, int2str(participantId), filenameMid, int2str(recordingId), filenameSuffix);
        completePamiTable = readtable(fullFilePath, 'ReadVariableNames',false);
        pamiFeatures = completePamiTable(:,:);
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

