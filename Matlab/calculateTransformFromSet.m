function bestTransform = calculateTransformFromSet(detectedTranforms)

totalTransfroms = numel(detectedTranforms);
%make a better randomizer
poolSize = round(totalTransfroms/2)
totalTransfroms;
bestTransform = 0;
for poolSet = 1:totalTransfroms
    pool = {};
    notPool = {};
    for tIndex = 0:poolSize-1
        pool = [pool, detectedTranforms{mod(poolSet+tIndex,totalTransfroms)+1}];
    end
    
    for tIndex = poolSize:totalTransfroms-1
        notPool = [notPool, detectedTranforms{mod(poolSet+tIndex,totalTransfroms) + 1}];
    end
%     celldisp(pool);
%     celldisp(notPool);
    
    sumX = 0;
    sumY = 0;
    
    for i = 1: poolSize
        sumX = sumX + pool{i}(1);
        sumY = sumY + pool{i}(2);
    end
    
    xTform = sumX/poolSize;
    yTform = sumY/poolSize;
    
    xTformSq = xTform^2;
    yTformSq = yTform^2;
    errorLevel = 0.2;
    
    newPool = pool;
    for i = 1: totalTransfroms - poolSize
        if (notPool{i}(1)^2 - xTformSq)/xTformSq < errorLevel
            if (notPool{i}(2)^2 - yTformSq)/yTformSq < errorLevel
                newPool = [newPool, notPool{i}];
            end
        end
    end
    
    if numel(newPool) > round(totalTransfroms * 3 / 4)
        sumX = 0;
        sumY = 0;
        for i = 1: numel(newPool)
            sumX = sumX + newPool{i}(1);
            sumY = sumY + newPool{i}(2);
        end
        finalXTfrom = sumX/numel(newPool)
        finalYTform = sumY/numel(newPool)
        bestTransform = [finalXTfrom finalYTform]
    end
    
end

if bestTransform == 0
    bestTransform = [0 0];
end