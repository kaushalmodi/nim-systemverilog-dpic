function [out] = mean_func_2(in)
tmp.mean = 0;
tmp.max = int32(0);
tmp.min = int32(0);

out.x1 = tmp;
out.x2 = tmp;
out.x3 = tmp;

for j = 1:3
    data = in(j).data;
    len = in(j).len;
    
    tmp.mean =mean(data(1:len));
    tmp.max = max(data(1:len));
    tmp.min = min(data(1:len));
    
    if (j==1)
        out.x1 = tmp;
    elseif (j==2)
        out.x2 = tmp;
    else
        out.x3 = tmp;
    end
end

end
