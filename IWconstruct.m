function [P] = IWconstruct( S )
% construct the initial weight maps
[r c N] = size(S);
[X Labels] = max(S,[],3); % find the labels of the maximum
clear X
%for i = 1:N
    mono = zeros(r,c);
    %mono(Labels==i) = 1;
    mono(Labels) = 1;
    %P(:,:,i) = mono;
%end
mono = zeros(r,c);

