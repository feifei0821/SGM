function [W] = GuidOptimize( I, P, r, eps)
N = size(I,3);%1
I = double(I)/255;%Ô´»Ò¶ÈÍ¼Ïñ
for i=1:N
P(:,:,i) = double(P(:,:,i));
W(:,:,i) = guidedfilter(I(:,:,i), P(:,:,i), r, eps);
%figure;imshow(uint8(W));
end
%{
W = uint8(W.*255); % Remove values which are not in the [0-1] range
W = double(W)/255;
W = W + 1e-12; %Normalization
W = W./repmat(sum(W,3),[1 1 N]);
%}