clear all;
close all;

%i=18;
n=4;
for i=1:n
I1=double(imread(['C:\Users\35682\Desktop\SMG\NIR\',num2str(i),'.tiff']))/255;
I2=double(imread(['C:\Users\35682\Desktop\SMG\VIS\',num2str(i),'.tiff']))/255;
%figure;imshow(I2);
level=1;
%tic;
[H, S, I3] = rgb2hsv(I2);
GI1=gradient(I1);
GI2=gradient(I3);%VIS
%figure;imshow(H);

alpha = [1 1 1];
window1 = 5;      
NHOOD1 = ones(window1);%5*5
J1 = entropyfilt(I1,NHOOD1)/8;
W1 = J1.^alpha(2);
%figure;imshow(uint8(W1*255));

I44=imread(['C:\Users\35682\Desktop\SMG\VIS\',num2str(i),'.tiff']);
G=rgb2gray(I44);
%figure;imshow(uint8(G));
G2=double(G);
[m,n]=size(G2);
a2=mean2(G2);

for x=1:m
    for y=1:n
        G2(x,y)=a2; 
    end
end

for x=1:m
    for y=1:n
        if(G2(x,y)*0.85<G(x,y))
            S22(x,y)=255;
        else S22(x,y)=0;
        end
    end
end
%figure;imshow(uint8(S22));

F = lp_fuse(I1*255, I3*255, level, 3, 5,GI2,G,S22,W1); 

%t22=toc;
%load t11;
%t11=t11+double(t22);
%save t11;

%figure;imshow(uint8(F));
I3(:,:,1) = double(H);
I3(:,:,2) = S;
I3(:,:,3) = F;%ÁÁ¶È²ãlpÈÚºÏ
I4 = hsv2rgb(I3);
%figure;imshow(uint8(I4));
imwrite(uint8(I4),strcat('C:\Users\35682\Desktop\SMG\result\',strcat(num2str(i),'.jpg')));
clc,clear,close;
end

