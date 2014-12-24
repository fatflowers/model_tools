function [IN_radar, out_rect] = get_radar_bound(I_width, I_height, R_vertices)
fprintf('get radar_bound...\n');
radar_map = zeros(I_height, I_width);
for i = 1: length(R_vertices)
    radar_map(R_vertices(i, 1), R_vertices(i, 2)) = R_vertices(i, 3);
end


bound = [];
for i = 1: I_height
    for j = 1: I_width
        if radar_map(i, j) ~= 0
            bound = [bound; i, j];
            break;
        end
    end
end


for i = I_height: -1 : 1
    for j = I_width: -1 : 1
        if radar_map(i, j) ~= 0
            bound = [bound; i, j];
            break;
        end
    end
end

% erase duplicate
for i = 1: length(bound)
    for j = i+1: length(bound)
        temp = (bound(j, :) == bound(i, :));
        if temp(1,1) == 1 && temp(1,2) == 1
            bound(j, :) = [];
            break;
        end
    end
end
x_y = zeros(I_height * I_width, 2);
k = 1;
for i_x = 1 : I_height
   for i_y = 1 : I_width
       x_y(k, :) = [i_x, i_y];
       k = k + 1;
   end
end
IN_radar = inpolygon(x_y(:, 1), x_y(:, 2), bound(:, 1), bound(:, 2));

out_rect = [min(bound(:, 1)), max(bound(:, 1)); min(bound(:, 2)), max(bound(:, 2))];





        