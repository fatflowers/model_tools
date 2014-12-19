%���ɡ�integration of shape from shading and stereo���ĸ���ҶƵ����
function [freq] = frequency(S,fl)

freq = zeros(1, S);

for i = 1: S/2
    freq(i) = -0.5 + i/(S * fl);
    freq(i + S/2) = i/(S * fl);
end
    