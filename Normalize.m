%归一化的操作，如果F中的点的值大于256，则将它设置为255

%F:源数据
%frame：目的数据
%originFrame：若flag为1且originFrame中对应点值为零，则frame中对应位置的值为0
function [frame] = Normalize(F, originFrame, flag, max)

frame = zeros(1, max);
%% 这段也没有用啊……
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