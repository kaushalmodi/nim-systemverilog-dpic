function [out] = mean_func_3(in)
tmp.mean = 0;
tmp.max = int32(0);
tmp.min = int32(0);

out.x1 = tmp;
out.x2 = tmp;
out.x3 = tmp;

for j = 1:3
    if (j==1)
    data = in.x1.data;
    len  = in.x1.len;
    elseif (j==2)
    data = in.x2.data;
    len  = in.x2.len;
    else
    data = in.x3.data;
    len  = in.x3.len;
    end
    
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
