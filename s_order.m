function [ diffImage ] = s_order( grayImage )
%S_ORDER: This function traverses the image in an inverse s-order manner
%         and produces the difference values.
grayImage = double(grayImage);
diffImage = double(512);

for i = 1:512
    for j = 1:512
        testVar = mod(i, 2);
        if testVar == 1;
            if i == 1 && j == 1
                diffImage(i, j) = grayImage(1, 1);
                continue;
            end
            if i ~= 1 && j == 1
                diffImage(i, j) = grayImage(i, j) - grayImage(i-1, j);
                continue;
            end
            diffImage(i, j) = grayImage(i, j) - grayImage(i, j-1);
        end
        if testVar == 0;
            j = 513 - j;
            if j == 512
                diffImage(i, j) = grayImage(i, j) - grayImage(i-1, j);
                continue;
            end
            diffImage(i, j) = grayImage(i, j) - grayImage(i, j+1);
        end
    end
end

end