function out_scale = scaleSVM(c,lower,upper)
%   设置归一化范围 [lower ,upper]
%   按列进行归一化
[m,n]=size(c);                              %%获取行数m 和 列数  n         
Cmax=zeros(1,n);                         
Cmin=zeros(1,n);                         
for i=1:n
     Cmax(1,i)=max(c(:,i));                 %%Cmax用来保存每一列中的最大值
end
for i=1:n
    Cmin(1,i)=min(c(:,i));                  %%Cmin用来保存每一列中的最小值
end
for i=1:m
    for j=1:n
        c(i,j)=lower+(upper-lower)*(c(i,j)-Cmin(1,j))/(Cmax(1,j)-Cmin(1,j));  %%执行前述的公式进行归一化
    end
end
out_scale=c;
end