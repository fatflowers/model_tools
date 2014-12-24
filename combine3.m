% 直接将SSF的结果放到三维模型上
function [result] = combine3(R_vertices, voronoi_map, voronoi_depth_map, PS_3D, SSFpath, size)
if nargin() == 4
    SSFpath = 'lros12-21-2.ucf';
    size = 700;
end


% depth_ss = load('mozart-sh.ascii');
% depth_st = load('mozart-st.ascii');
% 
% if length(depth_ss) ~= length(depth_st)
%     exit();
% end

depth_ss = load(SSFpath);
result = zeros(length(R_vertices), 1);
for i = 1 : length(R_vertices)
    result(i) = depth_ss((R_vertices(i,1) - 1) * size + R_vertices(i,2));
end




dlmwrite('depth_combined.tmp', result, '%3.6f\n', '');



