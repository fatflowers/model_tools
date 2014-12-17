% compute the mean value of depth after fusion for each Radar node.

count_vertices = zeros(size(R_vertices, 1), 1);
mean_vertices = zeros(size(R_vertices, 1), 1);

for i = 1: I_height
    for j = 1: I_width
        if voronoi_map(i, j) ~= 0
            mean_vertices(voronoi_map(i, j)) = mean_vertices(voronoi_map(i, j)) + 1;
            count_vertices(voronoi_map(i, j)) = count_vertices(voronoi_map(i, j)) + 1;
        end
    end
end
