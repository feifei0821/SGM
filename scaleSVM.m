function out_scale = scaleSVM(c,lower,upper)
%   ���ù�һ����Χ [lower ,upper]
%   ���н��й�һ��
[m,n]=size(c);                              %%��ȡ����m �� ����  n         
Cmax=zeros(1,n);                         
Cmin=zeros(1,n);                         
for i=1:n
     Cmax(1,i)=max(c(:,i));                 %%Cmax��������ÿһ���е����ֵ
end
for i=1:n
    Cmin(1,i)=min(c(:,i));                  %%Cmin��������ÿһ���е���Сֵ
end
for i=1:m
    for j=1:n
        c(i,j)=lower+(upper-lower)*(c(i,j)-Cmin(1,j))/(Cmax(1,j)-Cmin(1,j));  %%ִ��ǰ���Ĺ�ʽ���й�һ��
    end
end
out_scale=c;
end