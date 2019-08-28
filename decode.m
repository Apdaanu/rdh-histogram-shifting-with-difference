function [ grayImage, payload ] = decode( embeddedImage, L )
    
    embeddedImage = double(embeddedImage);
    grayImage = embeddedImage;
    payload = double.empty;

    for i = 1:512
        for j = 1:512
            testVar = mod(i, 2);
            if testVar == 1;
                if i == 1 && j == 1
                    grayImage(i, j) = embeddedImage(1, 1);
                    continue;
                end
                if i ~= 1 && j == 1
                    testCase1 = abs(embeddedImage(i ,j)-grayImage(i-1, j)) < 2^(L+1);
                    if testCase1
                        if mod(abs(embeddedImage(i, j) - grayImage(i-1, j)), 2) == 0
                            payload = [payload 0];
                        elseif mod(abs(embeddedImage(i, j) - grayImage(i-1, j)), 2) == 1
                            payload = [payload 1];
                        end
                    end
                    testCase2 = embeddedImage(i, j) < grayImage(i-1, j);
                    testCase3 = embeddedImage(i, j) > grayImage(i-1, j);
                    if testCase1 && testCase2
                        grayImage(i, j) = embeddedImage(i, j) + ceil(abs(embeddedImage(i ,j)-grayImage(i-1, j))/2);
                    elseif testCase1 && testCase3
                        grayImage(i, j) = embeddedImage(i, j) - ceil(abs(embeddedImage(i ,j)-grayImage(i-1, j))/2);
                    elseif ~testCase1 && testCase2
                        grayImage(i, j) = embeddedImage(i, j) + 2^L;
                    elseif ~testCase1 && testCase3
                        grayImage(i, j) = embeddedImage(i, j) - 2^L;
                    else
                        grayImage(i, j) = embeddedImage(i, j);
                    end
                    continue;
                end
                testCase1 = abs(embeddedImage(i ,j)-grayImage(i, j-1)) < 2^(L+1);
                if testCase1
                    if mod(abs(embeddedImage(i, j) - grayImage(i, j-1)), 2) == 0
                        payload = [payload 0];
                    elseif mod(abs(embeddedImage(i, j) - grayImage(i, j-1)), 2) == 1
                        payload = [payload 1];
                    end
                end
                testCase2 = embeddedImage(i, j) < grayImage(i, j-1);
                testCase3 = embeddedImage(i, j) > grayImage(i, j-1);
                if testCase1 && testCase2
                    grayImage(i, j) = embeddedImage(i, j) + ceil(abs(embeddedImage(i ,j)-grayImage(i, j-1))/2);
                elseif testCase1 && testCase3
                    grayImage(i, j) = embeddedImage(i, j) - ceil(abs(embeddedImage(i ,j)-grayImage(i, j-1))/2);
                elseif ~testCase1 && testCase2
                    grayImage(i, j) = embeddedImage(i, j) + 2^L;
                elseif ~testCase1 && testCase3
                    grayImage(i, j) = embeddedImage(i, j) - 2^L;
                else
                    grayImage(i, j) = embeddedImage(i, j);
                end
            end
            if testVar == 0;
                j = 513 - j;
                if j == 512
                    testCase1 = abs(embeddedImage(i ,j)-grayImage(i-1, j)) < 2^(L+1);
                    if testCase1
                        if mod(abs(embeddedImage(i, j) - grayImage(i-1, j)), 2) == 0
                            payload = [payload 0];
                        elseif mod(abs(embeddedImage(i, j) - grayImage(i-1, j)), 2) == 1
                            payload = [payload 1];
                        end
                    end
                    testCase2 = embeddedImage(i, j) < grayImage(i-1, j);
                    testCase3 = embeddedImage(i, j) > grayImage(i-1, j);
                    if testCase1 && testCase2
                        grayImage(i, j) = embeddedImage(i, j) + ceil(abs(embeddedImage(i ,j)-grayImage(i-1, j))/2);
                    elseif testCase1 && testCase3
                        grayImage(i, j) = embeddedImage(i, j) - ceil(abs(embeddedImage(i ,j)-grayImage(i-1, j))/2);
                    elseif ~testCase1 && testCase2
                        grayImage(i, j) = embeddedImage(i, j) + 2^L;
                    elseif ~testCase1 && testCase3
                        grayImage(i, j) = embeddedImage(i, j) - 2^L;
                    else
                        grayImage(i, j) = embeddedImage(i, j);
                    end
                    continue;
                end
                testCase1 = abs(embeddedImage(i ,j)-grayImage(i, j+1)) < 2^(L+1);
                if testCase1
                    if mod(abs(embeddedImage(i, j) - grayImage(i, j+1)), 2) == 0
                        payload = [payload 0];
                    elseif mod(abs(embeddedImage(i, j) - grayImage(i, j+1)), 2) == 1
                        payload = [payload 1];
                    end
                end
                testCase2 = embeddedImage(i, j) < grayImage(i, j+1);
                testCase3 = embeddedImage(i, j) > grayImage(i, j+1);
                if testCase1 && testCase2
                    grayImage(i, j) = embeddedImage(i, j) + ceil(abs(embeddedImage(i ,j)-grayImage(i, j+1))/2);
                elseif testCase1 && testCase3
                    grayImage(i, j) = embeddedImage(i, j) - ceil(abs(embeddedImage(i ,j)-grayImage(i, j+1))/2);
                elseif ~testCase1 && testCase2
                    grayImage(i, j) = embeddedImage(i, j) + 2^L;
                elseif ~testCase1 && testCase3
                    grayImage(i, j) = embeddedImage(i, j) - 2^L;
                else
                    grayImage(i, j) = embeddedImage(i, j);
                end
            end
        end
    end

    grayImage = uint8(grayImage);

end

