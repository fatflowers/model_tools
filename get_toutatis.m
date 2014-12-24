I = imread('KeJianGuang.bmp');
BW=im2bw(I,graythresh(I));
% imshow(BW);
% figure;
%????
[H,L] = bwboundaries(BW,'noholes');
% [H,L] = bwboundaries(BW);
maxsize = 0;
maxi = 0;
for i = 1 : length(H)
    if(length(H{i}) > maxsize )
        maxi = i;
        maxsize = length(H{i}) ;
    end
end

result = uint8(zeros(700, 700));

x_y = zeros(490000, 2);
for i = 1 :700
    for j = 1:700
        x_y((i-1)*700 + j, :) = [i, j];
    end
end

IN = inpolygon(x_y(:, 1), x_y(:, 2), H{maxi}(:, 1), H{maxi}(:, 2)); 

temp = imread('KeJianGuang.bmp');
for i = 1: 490000
    if IN(i) == 1
        result(x_y(i, 1), x_y(i, 2)) = uint8(temp(x_y(i, 1), x_y(i, 2)));
    end
end

imshow(result);
imwrite(result, 'toutatis_clean.bmp');
