clear all;
close all;
%t=imread('a1.jpg');
n=36;
for i=1:n;
t=imread(['D:\研究生\近红外与可见光融合\sourceimages\VIS\',num2str(i),'.tiff']);
[m,n,z]=size(t);

y=0+0.05*randn(m,n);%二维高斯分布矩阵 0是均值 0.1是标准差

%先将其double化，再除以255 便于后面计算
t1=double(t)/255;
[H, S, V] = rgb2hsv(t1);
%加上噪声
%t1=t1+y;
V2=V+y;
I3(:,:,1) = H;
I3(:,:,2) = S;
I3(:,:,3) = V2;%亮度层lp融合
t1 = hsv2rgb(I3);


%将像素范围扩大至0--255
t1=t1*255;

%转换为uint8类型
t1=uint8(t1);

imwrite(uint8(t1),strcat('D:\研究生\近红外与可见光融合\method-代码\TE-MST (detailguildfused)\jiaoyannoice\',strcat(num2str(i),'.jpg')));
clc,clear,close;
end