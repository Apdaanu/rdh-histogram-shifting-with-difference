rgbImage = imread('lenna.png');
grayImage = rgb2gray(rgbImage);
grayImage = double(grayImage);
transformedImage = grayImage;
embeddedImage = zeros(512, 512);
locationMap = zeros(512, 512);

diffImage = s_order(grayImage);
diffImageAbs = abs(diffImage);

freqMatrix = zeros(1, 512);

for i = 1:512
    for j = 1:512
        diffVal = diffImageAbs(i, j) + 1;
        freqMatrix(diffVal) = freqMatrix(diffVal) + 1;
    end
end

payload = (randi([0 1],20000,1))';

temp = 0;
indexVal = 0;
while temp < numel(payload)
    temp = temp + freqMatrix(indexVal + 1);
    indexVal = indexVal + 1;
end

temp = 1;
L = 0;
while temp < indexVal
    temp = temp*2;
    L = L + 1;
end

for i = 1:512
    for j = 1:512
        if transformedImage(i, j) < 2^L
            transformedImage(i, j) = transformedImage(i, j) + 2*L;
            locationMap(i, j) = 1;
        end
        if transformedImage(i, j) > 255-2^L
            transformedImage(i, j) = transformedImage(i, j) - 2*L;
            locationMap(i, j) = 1;
        end
    end
end

locationMapCompressed = rle(locationMap);
finalBitstream = [locationMapCompressed payload];
embeddedImage = transformedImage;

m = 1;
for i = 1:512
    for j = 1:512
        testVar = mod(i, 2);
        if testVar == 1
            if diffImageAbs(i, j) >= 2^L
                if i == 1 && j == 1
                    continue;
                end
                if i ~= 1 && j == 1
                    if transformedImage(i, 1) >= transformedImage(i -1, 1)
                        embeddedImage(i, 1) = transformedImage(i, 1) + 2^L;
                    
                    elseif transformedImage(i, 1) < transformedImage(i -1, 1)
                        embeddedImage(i, 1) = transformedImage(i, 1) - 2^L;                        
                    end
                    continue;
                end
                if transformedImage(i, j) >= transformedImage(i, j -1)
                    embeddedImage(i, j) = transformedImage(i, j) + 2^L;
                elseif transformedImage(i, j) < transformedImage(i, j -1)
                    embeddedImage(i, j) = transformedImage(i, j) - 2^L;
                end
            end

            if diffImageAbs(i, j) < 2^L
                if i ~= 1 && j == 1
                    if transformedImage(i, j) >= transformedImage(i -1, 1)
                        embeddedImage(i, j) = transformedImage(i, j) + diffImageAbs(i, j) + finalBitstream(m);
                        m = m + 1;
                    
                    elseif transformedImage(i, j) < transformedImage(i -1, 1)
                        embeddedImage(i, j) = transformedImage(i, j) - (diffImageAbs(i, j) + finalBitstream(m));
                        m = m  + 1;
                    end    
                    continue;
                end
                if transformedImage(i, j) >= transformedImage(i, j -1)
                    embeddedImage(i, j) = transformedImage(i, j) + diffImageAbs(i, j) + finalBitstream(m);
                    m = m + 1;
                
                elseif transformedImage(i, j) < transformedImage(i, j -1)
                    embeddedImage(i, j) = transformedImage(i, j) - (diffImageAbs(i, j) + finalBitstream(m));
                    m = m  + 1;
                end
            end
        end

        if testVar == 0
            j = 513 - j;
            if diffImageAbs(i, j) >= 2^L
                if j == 512
                    if transformedImage(i, 512) >= transformedImage(i -1, 512)
                        embeddedImage(i, j) = transformedImage(i, j) + 2^L;
                    
                    elseif transformedImage(i, 512) < transformedImage(i -1, 512)
                        embeddedImage(i, j) = transformedImage(i, j) - 2^L;
                    end
                    continue;
                end
                if transformedImage(i, j) >= transformedImage(i, j +1)
                    embeddedImage(i, j) = transformedImage(i, j) + 2^L;
                
                elseif transformedImage(i, j) < transformedImage(i, j +1)
                    embeddedImage(i, j) = transformedImage(i, j) - 2^L;
                end
            end

            if diffImageAbs(i, j) < 2^L
                if j == 512
                    if transformedImage(i, 512) >= transformedImage(i -1, 512)
                        embeddedImage(i, j) = transformedImage(i, j) + diffImageAbs(i, j) + finalBitstream(m);
                        m = m + 1;
                    
                    elseif transformedImage(i, j) < transformedImage(i -1, 512)
                        embeddedImage(i, j) = transformedImage(i, j) - (diffImageAbs(i, j) + finalBitstream(m));
                        m = m  + 1;
                    end
                    continue;
                end
                if transformedImage(i, j) >= transformedImage(i, j +1)
                    embeddedImage(i, j) = transformedImage(i, j) + diffImageAbs(i, j) + finalBitstream(m);
                    m = m + 1;
                
                elseif transformedImage(i, j) < transformedImage(i, j +1)
                    embeddedImage(i, j) = transformedImage(i, j) - (diffImageAbs(i, j) + finalBitstream(m));
                    m = m  + 1;
                end
            end
        end

        if m > numel(finalBitstream)
            break;
        end
    end
    if m > numel(finalBitstream)
        break;
    end
end

grayImage = uint8(grayImage);
transformedImage = uint8(transformedImage);
embeddedImage = uint8(embeddedImage);