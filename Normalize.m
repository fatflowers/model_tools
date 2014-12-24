%��һ���Ĳ��������F�еĵ��ֵ����256����������Ϊ255

%F:Դ����
%frame��Ŀ������
%originFrame����flagΪ1��originFrame�ж�Ӧ��ֵΪ�㣬��frame�ж�Ӧλ�õ�ֵΪ0
function [frame] = Normalize(F, originFrame, flag, max)

frame = zeros(1, max);
%% ���Ҳû���ð�����
low = 255000000;
high = -25000000;
for y = 0: max-1
    for x = 1: max
        if low > F(x+y*max) 
            low = F(x+y*max);
        end
        
        if high < F(x+y*max)
            high = F(x+y*max);        
        end
    end
end
%%
for y = 0: max-1
    for x = 1: max
        s = x+y*max;
        if flag == 1 && originFrame(s) == 0
            frame(s) = 0;
        elseif F(s) < 256
            frame(s) = F(s);
        else
            frame(s) = 255;
        end
    end
end