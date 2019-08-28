function [ finalRelMat ] = rle( bitStream )
N = 1;
relMat = [];
finalRelMat = [];
finalBitStream = [];
for i = 1:length(bitStream)
    finalBitStream = [finalBitStream bitStream(i, :)];
end

finalBitStream = [finalBitStream nan];

for i = 1:numel(finalBitStream) -1
    if finalBitStream(i) == finalBitStream(i+1)
        N = N + 1;
    else
        valuecode = finalBitStream(i);
        lengthcode = N;
        relMat = [relMat; valuecode lengthcode];
        N = 1;
    end
end
relMat = uint8(relMat);
maxVal = max(max(relMat));

base = 0;
while 2^base < maxVal
    base = base + 1;
end

for i = 1:numel(relMat)/2
    finalRelMat = [finalRelMat int2str(relMat(i, 1)) dec2bin(relMat(i, 2), maxVal)];
end

finalRelMat = [dec2bin(base+1, 10) finalRelMat];
finalRelMat = uint8(finalRelMat);

for i = 1:length(finalRelMat)
    if finalRelMat(i) == 48
        finalRelMat(i) = 0;
    elseif finalRelMat(i) == 49
        finalRelMat(i) = 1;
    end
end

end

