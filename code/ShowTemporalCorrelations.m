clear;clc;
% For demo purposes:

% Config:
datasetToUse = 1; %% For MPIIDPEye
% datasetToUse = 2; %% For MPIIPrivacEye
selectedFeatureIdx = 9; % Feature from datasets. Check datasets for more info.
selectedMinTVal = 5; % Start timepoint
selectedMaxTVal = 200; % End timepoint
shouldOriginalSignalUsed = 0; % 0 for differences, 1 for original signals.

if datasetToUse == 1
    ReadMPIIDPEye;
    load('./DifferenceMatrices/MPIIDPEyeDifference.mat', 'differenceMatrix');
elseif datasetToUse == 2
    ReadMPIIPrivacEye;
    load('./DifferenceMatrices/MPIIPrivacEyeDifference.mat', 'differenceMatrix');
end

startOfProcessing = 1;
r1Observations = []; 
r2Observations = [];
r3Observations = [];
evaluatedRawMat = [];
numberOfRecordingTypes = 3;

if shouldOriginalSignalUsed == 1
    evaluatedRawMat = pamiFeaturesAll;
else
    evaluatedRawMat = differenceMatrix;
end

for idx = 1:size(recordingSizeArr, 1)
    currentArrSize = recordingSizeArr(idx,1);
    startOfCurrentBlock = startOfProcessing;
    endOfCurrentBlock = startOfCurrentBlock + currentArrSize - 1;
    currentBlock = evaluatedRawMat(startOfCurrentBlock:endOfCurrentBlock,:);
    fetchedSignal = currentBlock(selectedMinTVal:selectedMaxTVal, selectedFeatureIdx);
    
    if mod(idx,numberOfRecordingTypes) == 1
        r1Observations = [r1Observations, fetchedSignal];
    elseif mod(idx,numberOfRecordingTypes) == 2
        r2Observations = [r2Observations, fetchedSignal];
    else
        r3Observations = [r3Observations, fetchedSignal];
    end
    
    startOfProcessing = startOfProcessing + currentArrSize;
end
totalObs = {r1Observations, r2Observations, r3Observations};

globalCorrCoefMat = [];
for rIdx = 1:numberOfRecordingTypes
   evaluatedMat = totalObs{rIdx};
   foundCorrCoefs = [];
   for cIdx = 2:size(evaluatedMat,1)
       corrCoeff = corrcoef(evaluatedMat(1,:), evaluatedMat(cIdx,:));
       fetchedCoeff = corrCoeff(1,2);
       foundCorrCoefs = [foundCorrCoefs; fetchedCoeff];
   end
   globalCorrCoefMat = [globalCorrCoefMat, foundCorrCoefs];
end

figure
plot(selectedMinTVal+1:selectedMaxTVal, globalCorrCoefMat(:,1), 'Color', '#fdae61', 'Marker', 'o', 'LineStyle', '-', 'MarkerSize',18, 'LineWidth', 3)
hold on
plot(selectedMinTVal+1:selectedMaxTVal, globalCorrCoefMat(:,2), 'Color', '#2b83ba', 'Marker', '+', 'LineStyle', '--', 'MarkerSize',18, 'LineWidth', 3)
hold on
plot(selectedMinTVal+1:selectedMaxTVal, globalCorrCoefMat(:,3), 'Color', '#7fc97f', 'Marker', '^', 'LineStyle', ':', 'MarkerSize',18, 'LineWidth', 3)
grid on

legend('Document Type-1','Document Type-2', 'Document Type-3', 'FontWeight', 'bold', 'Interpreter','latex',...
       'Location', 'northeast','NumColumns', 3, 'FontSize',30)
set(gcf, 'Position',  [5, 50, 1900, 500])
set(gca, 'FontWeight', 'bold', 'FontSize',40, 'TickLabelInterpreter', 'latex');
xlabel('$$\Delta{t}$$', 'Interpreter','latex')
ylabel('Correlation coefficients', 'Interpreter','latex', 'FontSize', 25)
xticks(0:20:200)

axis tight

xlim([0 selectedMaxTVal + selectedMinTVal])

if shouldOriginalSignalUsed == 0
    ylim([-0.8 0.8])
    yticks(-0.8:0.2:0.8)
else
    ylim([0.2 1]) 
    yticks(0.2:0.1:1)
end

ax = gca;
ax.GridAlpha = 0.3;