% R_vertices = load('depth_map.depth');
% % % % 
% % % [voronoi_map, voronoi_depth_map, PS_3D] = voronoi_2(R_vertices);
% % % 
% [IN_radar, out_rect] = get_radar_bound(700, 700, R_vertices);
% 
% [voronoi_map, voronoi_depth_map] = get_voronoi(IN_radar, out_rect, R_vertices, 700, 700);

result = combine_mine(R_vertices, voronoi_map, voronoi_depth_map, IN_radar);

% exit(1);