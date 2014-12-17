%% 
% 对于VarName1, VarName2点，求泰森多边形
% 之后对于每一个泰森多边形i_C，将图像上对应区域的点标为i_C
% 


%%
I_width = 700;
I_height = 700;
R_vertices = [VarName1, VarName2];
[V, C] = voronoin(R_vertices);
V(1,:)=[I_width, I_height];
voronoi_map = zeros(I_width, I_height);

for i_C = 1 : length(C)
    if all(C{i_C}) ~= 1
       xv_yv = zeros(length(C{i_C}), 2);
       % put all the points indexed by C{i_C} into x_y
       for i_i_C = 1 : length(C{i_C})
           xv_yv(i_i_C, :) = V(C{i_C}(i_i_C), :);
       end

       % 求i_C块泰森多边形的外界矩形
    %    min_x = min(int32(xv_yv(:, 1))) - 1;
       min_x = min(int32(xv_yv(:, 1)));
       if min_x < 0
           min_x = 1;
       end
    %    max_x = max(int32(xv_yv(:, 1))) + 1;
       max_x = max(int32(xv_yv(:, 1)));
       if max_x > I_height
           max_x = I_height;
       end
       min_y = min(int32(xv_yv(:, 2)));
    %    min_y = min(int32(xv_yv(:, 2))) - 1;
       if min_y < 0
           min_y = 1;
       end
       max_y = max(int32(xv_yv(:, 2)));
    %    max_y = max(int32(xv_yv(:, 2))) + 1;
       if max_y > I_width
           max_y = I_width;
       end

       x_y = zeros((max_x - min_x + 1) * (max_y - min_y + 1), 2);
       k = 1;
       for i_x = min_x : max_x
           for i_y = min_y : max_y
               x_y(k, :) = [i_x, i_y];
               k = k + 1;
           end
       end

    %   [IN, ON] = inpolygon(x_y(:, 1), x_y(:, 2), xv_yv(:, 1), xv_yv(:, 2));
       IN = myinpolygon(x_y(:, 1), x_y(:, 2), xv_yv(:, 1), xv_yv(:, 2));  
       for i = 1 : length(IN)
           if IN(i) == 1
               if voronoi_map(x_y(i, 1), x_y(i, 2)) ~= 0
                   sprintf('got an error!!\n');
                   continue;
               end
               voronoi_map(x_y(i, 1), x_y(i, 2)) = i_C;
           end

    %        if ON(i) == 1 && voronoi_map(x_y(i, 1), x_y(i, 2)) == 0
    %            voronoi_map(x_y(i, 1), x_y(i, 2)) = i_C;
    %        end
       end   
    end
end


% check if there is some duplicate vertices
% t = [VarName1, VarName2];
% for i = 1 : size(t, 1)
%     temp = t(i, :);
%     for j = 2 : size(t, 1)
%         if i ~= j 
%             if (temp == t(j, :))
%               sprintf('%d %d\n', i, j);
%             end
%         end
%     end
% end
