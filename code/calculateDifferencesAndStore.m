function calculateDifferencesAndStore(pamiFeaturesArg, recordingSizeArrArg, outputDiffPathArg)

    differenceMatrix = [];
    startOfProcessingId = 1;
    recordingSizeArrLocal = recordingSizeArrArg;
    pamiFeaturesAllLocal = pamiFeaturesArg;
    
    for idx = 1:size(recordingSizeArrLocal, 1)
        currentArrSize = recordingSizeArrLocal(idx,1);
        startOfCurrentBlock = startOfProcessingId;
        endOfCurrentBlock = startOfCurrentBlock + currentArrSize - 1;
        
        currentBlock = pamiFeaturesAllLocal(startOfCurrentBlock:endOfCurrentBlock, :);

        for i  = 1:size(currentBlock,1)
            if i == 1
               zeroVect = zeros(1,size(currentBlock,2));
               currentDiff = currentBlock(i,:) - zeroVect;
               differenceMatrix = [differenceMatrix; currentDiff];
            else
                currentDiff = currentBlock(i,:) - currentBlock(i-1,:);
                differenceMatrix = [differenceMatrix; currentDiff];
            end
        end
        
        startOfProcessingId = startOfProcessingId + currentArrSize;
        idx
    end
    save(outputDiffPathArg, 'differenceMatrix');
end

