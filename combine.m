%ʵ�֡�integration of shape from shading and stereo���е��ں��㷨
function combine(R_vertices, voronoi_map, voronoi_depth_map, PS_3D, SSFpath, size)
% voronoi_depth_map
%���ͼΪ256 X 256��С
if nargin() == 4
    SSFpath = 'LRos1.depth';
    size = 728;
end

a = 0.01;
a0 = 0.2;


% voronoi_depth_map = load('mozart-st.ascii');

% if length(depth_ss) ~= length(voronoi_depth_map)
%     exit();
% end
%%
% ����SSF���ͼ
depth_ss = load(SSFpath);
depth_ssf = zeros(size, size);
for i = 0: size-1
    for j = 1: size
        depth_ssf(i + 1, j) = depth_ss(i * size + j);        
    end
end
%%
%���ͼ������Ȧ��ֵ��Ϊ0
for i = i: size
    for j = 1: size
        if j < 3 || j > size - 3 || i < 3 || i > size - 3
            depth_ssf(i, j) = 0;
            voronoi_depth_map(i, j) = 0;
        end
    end
end
            

%�������ͼ��FFT
fft_ss = fft(depth_ss);
fft_st = fft(voronoi_depth_map);

%shape from shading��Ƶ����ʵ�����鲿
real_ss = real(fft_ss);
imag_ss = imag(fft_ss);

%shape from stereo��Ƶ����ʵ�����鲿
real_st = real(fft_st);
imag_st = imag(fft_st);

%�ںϺ�Ľ��
real_combine = zeros(1, size * size);
imag_combine = zeros(1, size * size);

%���ͼ������Ȧ��ֵ��Ϊ0
for i = i: size
    for j = 1: size
        if j < 3 || j > size - 3 || i < 3 || i > size - 3
            real_ss(i, j) = 0;
            imag_ss(i, j) = 0;
            real_st(i, j) = 0;
            imag_st(i, j) = 0;
        end
    end
end

freq = frequency(size, 1);


%FFT����������ͼ���������е��㷨�����ں�
for i = 1: size
    for j = 1: size
        omega = sqrt(freq(i) + freq(j));
        
        H = (a*a / (2*a0*a +(1-a0)*a*a))  /  ((a*a + omega*omega) / (2*a0*a + (1 - a0)*(a*a + omega*omega)));
        
%         index = (i - 1) * size + j;
        
        real_combine(i, j) = real_ss(i, j) * (1 - H) + real_st(i, j) * H;
        imag_combine(i, j) = imag_ss(i, j) * (1 - H) + imag_st(i, j) * H;
    end
end

depth_combine = ifft(real_combine + imag_combine*i);
% Normalize(depth_combine, voronoi_depth_map, 1, size);

% plot_3d(real(depth_combine));

% compute the mean value of depth after fusion for each Radar node.

count_vertices = zeros(size(R_vertices, 1), 1);
mean_vertices = zeros(size(R_vertices, 1), 1);

for i = 1: I_height
    for j = 1: I_width
        if voronoi_map(i, j) ~= 0
            mean_vertices(voronoi_map(i, j)) = mean_vertices(voronoi_map(i, j)) + depth_combine(i, j);
            count_vertices(voronoi_map(i, j)) = count_vertices(voronoi_map(i, j)) + 1;
        end
    end
end
% write the combined depth into file depth_combined.tmp, which to be used
% in python

dlmwrite('depth_combined.tmp', num2str(mapminmax('reverse', (mean_vertices./count_vertices)', PS_3D)', '%3.6f\n'));




