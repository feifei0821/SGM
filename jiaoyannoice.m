clear all;
close all;
%t=imread('a1.jpg');
n=36;
for i=1:n;
t=imread(['D:\�о���\��������ɼ����ں�\sourceimages\VIS\',num2str(i),'.tiff']);
[m,n,z]=size(t);

y=0+0.05*randn(m,n);%��ά��˹�ֲ����� 0�Ǿ�ֵ 0.1�Ǳ�׼��

%�Ƚ���double�����ٳ���255 ���ں������
t1=double(t)/255;
[H, S, V] = rgb2hsv(t1);
%��������
%t1=t1+y;
V2=V+y;
I3(:,:,1) = H;
I3(:,:,2) = S;
I3(:,:,3) = V2;%���Ȳ�lp�ں�
t1 = hsv2rgb(I3);


%�����ط�Χ������0--255
t1=t1*255;

%ת��Ϊuint8����
t1=uint8(t1);

imwrite(uint8(t1),strcat('D:\�о���\��������ɼ����ں�\method-����\TE-MST (detailguildfused)\jiaoyannoice\',strcat(num2str(i),'.jpg')));
clc,clear,close;
end