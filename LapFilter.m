function [ H ] = LapFilter( G )
%Conduct Laplacian filtering on each source image
%L = [0 1 0; 1 -4 1; 0 1 0]; % The 3*3 laplacian filter
L = [0 -1 0; -1 4 -1; 0 -1 0]; % The 3*3 laplacian filter
%L = [-1 -1 -1; -1 8 -1; -1 -1 -1];
N = size(G,3);
G = double(G)/255;
H = zeros(size(G,1),size(G,2),N); % Assign memory �����ڴ�
for i = 1:N
    H(:,:,i) = abs(imfilter(G(:,:,i),L,'replicate'));%������������ı߽����ֵ�ٶ��������������߽�ֵ��
    %H(:,:,i) = abs(imfilter(G(:,:,i),L,'replicate'));%abs�����ֵ
end
end
