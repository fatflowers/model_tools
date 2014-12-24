I_width = 700;
I_height = 700;
R_vertices = [VarName1, VarName2];

R_map = zeros(I_height, I_width);
for i = 1 : size(R_vertices, 1)
    R_map(R_vertices(i, 1), R_vertices(i, 2)) = 1;
end

