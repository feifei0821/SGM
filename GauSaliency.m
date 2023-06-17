%{
function [ S ] = GauSaliency( H )
% Using the local average of the absolute value of H to construct the 
% saliency maps
N = size(H,3);
S = zeros(size(H,1),size(H,2),N);
for i=1:N
%se = fspecial('gaussian',11,5);%原文参数高斯低通滤波，11*11
se = fspecial('gaussian',3,2);%原文参数高斯低通滤波，11*11
%se = fspecial('gaussian',3,0.5);
S(:,:,i) = imfilter(H(:,:,i),se,'replicate');
end
S = S + 1e-12; %avoids division by zero
HJ=sum(S,3);
out_scale = scaleSVM(S,0,1);
figure;imshow(out_scale*10);
figure;imshow(out_scale*20);
figure;imshow(out_scale*100);
%S = S./repmat(sum(S,3),[1 1 N]);       %Normalize the saliences in to [0-1]
S=out_scale;
end
%}
function [ S ] = GauSaliency( H )
% Using the local average of the absolute value of H to construct the 
% saliency maps
N = size(H,3);
S = zeros(size(H,1),size(H,2),N);
for i=1:N
%se = fspecial('gaussian',11,5);%原文参数高斯低通滤波，11*11
se = fspecial('gaussian',3,2);%原文参数高斯低通滤波，11*11
%se = fspecial('gaussian',3,0.5);
S(:,:,i) = imfilter(H(:,:,i),se,'replicate');
end