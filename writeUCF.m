%%
% Code for write a matrix into a UCF image.
% Format of UCF image is quite simple: 4 bytes of type, 4 bytes of maxX, 4 bytes of maxY, then maxX * maxY bytes of content.
% 
% Author: sunlei sunleihit@qq.com
%%
function [] = writeUCF(image, varargin)
if nargin > 1
    type = varargin{1};
else
    type = int32(0);
end

if nargin > 2
    outfile = varargin{2};
else
    outfile = 'out.ucf';
end

fprintf('Start to write file %s ...\n', outfile);

fid = fopen(outfile, 'wb');
if fid <= 0
    error('Failed open file');
end

fwrite(fid, type, 'int');

fwrite(fid, size(image, 1), 'int');
fwrite(fid, size(image, 2), 'int');

for i = 1: size(image, 1)
    if fwrite(fid, image(i, :), 'uchar') ~= size(image, 2)
        error(['failed to write the ' num2str(i) 'th row']);
    end
end
        
fprintf('Finished.\n');


