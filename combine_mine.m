function [result_combined] = combine_mine(R_vertices, voronoi_map, voronoi_depth_map, IN_radar, SFSpath, size_image)
fprintf('combine...\n');
if nargin() == 4
    SFSpath = 'lros12-24.depth';
    size_image = 700;
end


SSF_depth_min = -0.9445;
SSF_depth_max = -0.003;
%%
% load Shape From Shading depth
SFS_ascii = load(SFSpath);
SFS_ascii = mapminmax(SFS_ascii', 0, 1)';
SFS_depth = zeros(size_image, size_image);
for i = 1 : size_image
    for j = 1 : size_image
        SFS_depth(i, j) = SFS_ascii((i - 1) * size_image + j);
        if SFS_depth(i, j) == 0 && IN_radar((i-1)*size_image + j) == 1
            SFS_depth(i, j) = voronoi_depth_map(i, j);
        end
    end
end


%%
% fusion
PQ = paddedsize([size_image;size_image]);
[U, V] = dftuv(PQ(1), PQ(2));

a = 0.01;
a0 = 0.2;
H_low = 2*a ./ (a^2 + U.^2 + V.^2);
H_high = (a^2 + U.^2 + V.^2) ./ ((2*a0*a)+(1-a0)*(a^2 + U.^2 + V.^2))  ;
H = ((2*a0*a)+(1-a0)*(a^2 + U.^2 + V.^2)) ./ (a^2 + U.^2 + V.^2);

F_voronoi = fft2(voronoi_depth_map, size(H, 1), size(H, 2));
F_SFS = fft2(SFS_depth, size(H, 1), size(H, 2));

% result = ifft2(F_SFS - H .* F_SFS + H .* F_voronoi);
result = ifft2((1 - H) .* F_SFS +  2*F_voronoi);
result = result(1:size_image, 1:size_image);

%%
% get the fused result
count_vertices = zeros(length(R_vertices), 1);
mean_vertices = zeros(length(R_vertices), 1);
for i = 1: size_image
    for j = 1: size_image
        if voronoi_map(i, j) ~= 0
            mean_vertices(voronoi_map(i, j)) = mean_vertices(voronoi_map(i, j)) + result(i, j);
            count_vertices(voronoi_map(i, j)) = count_vertices(voronoi_map(i, j)) + 1;
        end
    end
end

zero_flag = zeros(length(R_vertices), 1);
for i = 1: length(R_vertices)
    if count_vertices(i) == 0
        mean_vertices(i) = 0;
        zero_flag(i) = 1;
    else
        mean_vertices(i) = mean_vertices(i) / count_vertices(i);
    end
end

result_col = mapminmax(mean_vertices', SSF_depth_min, SSF_depth_max)';
% result  = mean_vertices;
% set the zero depth to 0
for i = 1: length(R_vertices)
    if zero_flag(i) == 1
        result_col(i) = 0;
    end
end

% resultT = zeros(length(R_vertices), 1);
% for i = 1 : length(R_vertices)
%     resultT(i) = result((R_vertices(i,1) - 1), R_vertices(i,2));
% end
% resultT = mapminmax(resultT', SSF_depth_min, 0.7)';
dlmwrite('depth_combined.tmp', result_col, '%3.6f\n', '');
fprintf('Fusion done\n');

result = mapminmax(result, SSF_depth_min, SSF_depth_max);
result_combined = zeros(size_image, size_image);
for i = 1: size_image
    for j = 1: size_image
        if voronoi_depth_map(i, j) == 0 && SFS_depth(i, j) == SSF_depth_min
            result_combined(i, j) = 0;
        else
            if voronoi_depth_map(i, j) == 0
                result_combined(i, j) = SFS_depth(i, j);
            else
                if SFS_depth(i, j) == SSF_depth_min
                    result_combined(i, j) = voronoi_depth_map(i, j);
                else
                    result_combined(i, j) = result(i, j);
                end
            end
        end
    end
end

                

