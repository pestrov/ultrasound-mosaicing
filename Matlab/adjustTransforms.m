function positionsCellsArray = adjustTransforms(summedTransfroms)

totalTransfroms = numel(summedTransfroms);
radius = 2500;
angleChange = 360/totalTransfroms;

W(1,1) = 1;%X1
W(1,totalTransfroms) = -1;%Xn

W(totalTransfroms + 1,totalTransfroms + 1) = 1;%Y1
W(totalTransfroms + 1,totalTransfroms*2) = -1;%Yn

W(totalTransfroms*2 + 1, 1) = 1;%X1
W(totalTransfroms*2 + 2,totalTransfroms + 1) = 1;%Y1

for pair = 1:totalTransfroms-1
    W(pair+1, pair) = -1;%Xi
    W(pair+1, pair+1) = 1;%Xi+1
    W(totalTransfroms + pair + 1,totalTransfroms + pair) = -1;%Yi
    W(totalTransfroms + pair + 1,totalTransfroms + pair + 1) = 1;%Yi+1
    
    %Angular constraints
    W(totalTransfroms*2 + pair+2, pair) = -1;%Xi
    W(totalTransfroms*2 + pair+2, pair+1) = 1;%Xi+1
    W(totalTransfroms*2 + totalTransfroms + pair + 1,totalTransfroms + pair) = -1;%Yi
    W(totalTransfroms*2 + totalTransfroms + pair + 1,totalTransfroms + pair + 1) = 1;%Yi+1
end

deltas(totalTransfroms *2 + 1) = 700;
deltas(totalTransfroms *2 + 2) = 800;

for pair = 1:totalTransfroms
    deltas(pair) = summedTransfroms{pair}(1);
    deltas(totalTransfroms + pair) = summedTransfroms{pair}(2);
    if pair ~= totalTransfroms 
        deltas(totalTransfroms * 2 + 2 + pair) = radius * (cosd(angleChange*pair) - cosd(angleChange*(pair-1)));
        deltas(totalTransfroms * 3 + 1 + pair) = radius * (sind(angleChange*pair) - sind(angleChange*(pair-1)));
    end
end

deltas
W
positions = W\deltas'

positionsCellsArray = {};

for pair = 1:totalTransfroms
    positionsCellsArray = [positionsCellsArray,{[positions(pair) positions(pair+totalTransfroms)]}];
end    

