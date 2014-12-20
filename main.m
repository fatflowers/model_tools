R_vertices = load('depth_map.depth');

[voronoi_map, voronoi_depth_map, PS_3D] = voronoi_(R_vertices);

combine(R_vertices, voronoi_map, voronoi_depth_map, PS_3D)

exit(1);