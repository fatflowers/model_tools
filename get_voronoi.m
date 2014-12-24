%%
% 自己实现一个voronoi图，判断一个点在哪个区域中的方法是，由这个点的位置一圈圈的逐渐向外扩展，直到找到一个雷达坐标为止
function [voronoi_map, voronoi_depth_map] = get_voronoi(IN_radar, out_rect, R_vertices, I_width, I_height)
fprintf('get voronoi...\n');
voronoi_map = zeros(I_height, I_width);
voronoi_depth_map = zeros(I_height, I_width);
radar_depth_map = zeros(I_height, I_width);
radar_map_id = zeros(I_height, I_width);

% 归一化
R_vertices(:, 3) = (mapminmax(R_vertices(:, 3)', 0, 1))';
for i = 1: length(R_vertices)
    radar_depth_map(R_vertices(i, 1), R_vertices(i, 2)) = R_vertices(i, 3);
    radar_map_id(R_vertices(i, 1), R_vertices(i, 2)) = i;
end

for i = out_rect(1, 1): out_rect(1, 2)
    for j = out_rect(2, 1): out_rect(2, 2)
%         fprintf('dealing with i=%d j=%d\n', i, j);
          if IN_radar((i-1)*I_width + j) == 1
              if radar_depth_map(i, j) ~= 0
                  voronoi_map(i, j) = radar_map_id(i, j);
                  voronoi_depth_map(i, j) = radar_depth_map(i, j);
              else
                  w = 1;
                  while(w < I_width)
                      flag = 0;
                      
                      start_x = max(i-w, out_rect(1, 1));
                      end_x = min(i+w, out_rect(1, 2));
                      
                      start_y = max(j-w, out_rect(2, 1));
                      end_y = min(j+w, out_rect(2, 2));
                      
                      if start_x > end_x || start_y > end_y
                          w = w + 1;
                          continue;
                      end
                      % 正方形第一条边                      
                      array = radar_depth_map(start_x, start_y : end_y);                      
                      for k = 1: length(array)
                          if array(k) ~= 0
                              voronoi_map(i, j) = radar_map_id(start_x, start_y - 1 + k);
                              voronoi_depth_map(i, j) = radar_depth_map(start_x, start_y - 1 + k);
                              flag = 1;
                              break;
                          end
                      end
                      if flag == 1
                          w = w + 1;
                          break;
                      end
                      
                      % 正方形第二条边
                      array = radar_depth_map(start_x : end_x, end_y);                      
                      for k = 1: length(array)
                          if array(k) ~= 0
                              voronoi_map(i, j) = radar_map_id(start_x - 1 + k, end_y);
                              voronoi_depth_map(i, j) = radar_depth_map(start_x - 1 + k, end_y);
                              flag = 1;
                              break;
                          end
                      end
                      if flag == 1
                          w = w + 1;
                          break;
                      end
                      
                      % 正方形第三条边
                      array = radar_depth_map(end_x, start_y : end_y);                      
                      for k = 1: length(array)
                          if array(k) ~= 0
                              voronoi_map(i, j) = radar_map_id(end_x, start_y - 1 + k);
                              voronoi_depth_map(i, j) = radar_depth_map(end_x, start_y - 1 + k);
                              flag = 1;
                              break;
                          end
                      end
                      if flag == 1
                          w = w + 1;
                          break;
                      end
                      
                      % 正方形第四条边
                      array = radar_depth_map(start_x : end_x, start_y);                      
                      for k = 1: length(array)
                          if array(k) ~= 0
                              voronoi_map(i, j) = radar_map_id(start_x-1 + k, start_y);
                              voronoi_depth_map(i, j) = radar_depth_map(start_x - 1 + k, start_y);
                              flag = 1;
                              break;
                          end
                      end
                      if flag == 1
                          w = w + 1;
                          break;
                      end
                      w = w + 1;
                  end
                  if w > I_width
                      fprintf('holy shit!!\n');
                  end
              end                          
          end
    end
end

a=1;