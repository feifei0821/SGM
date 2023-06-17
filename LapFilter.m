function [ H ] = LapFilter( G )
%Conduct Laplacian filtering on each source image
%L = [0 1 0; 1 -4 1; 0 1 0]; % The 3*3 laplacian filter
L = [0 -1 0; -1 4 -1; 0 -1 0]; % The 3*3 laplacian filter
%L = [-1 -1 -1; -1 8 -1; -1 -1 -1];
N = size(G,3);
G = double(G)/255;
H = zeros(size(G,1),size(G,2),N); % Assign memory 分配内存
for i = 1:N
    H(:,:,i) = abs(imfilter(G(:,:,i),L,'replicate'));%复制输入数组的边界外的值假定等于最近的数组边界值。
    %H(:,:,i) = abs(imfilter(G(:,:,i),L,'replicate'));%abs求绝对值
end
end
