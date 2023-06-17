function Y = lp_fuse(M1, M2, zt, ap, mp,GI2,G,S22,W1)
%Y = fuse_lap(M1, M2, zt, ap, mp) image fusion with laplacian pyramid
%
%    M1 - input image A
%    M2 - input image B
%    zt - maximum decomposition level(���ֽ⼶��/�ںϲ���)
%    ap - coefficient selection highpass (see selc.m) ����ͨϵ��ѡ��
%    mp - coefficient selection base image (see selb.m) ����ͼϵ��ѡ��
%
%    Y  - fused image   

%    (Oliver Rockinger 16.08.99)
% check inputs 
%GM1=M2/255;
[z1, s1] = size(M1);  %��ȡ�к���
[z2, s2] = size(M2);
M1=double(M1);
M2=double(M2);
W1=double(W1);
if (z1 ~= z2) | (s1 ~= s2)
  error('Input images are not of same size');
end;   %�ж�����ͼ�ߴ��Ƿ�һ��

% define filter �������˲�������˹��������
w  = [1 4 6 4 1] / 16;      %����16
% cells for selected images
% tic
% loop over decomposition depth -> analysis  ��ѭ���ֽ����->������
    tic     %tic���浱ǰʱ�䣬toc��¼�������ʱ��
  % calculate and store actual image size �����㲢�洢ʵ��ͼ���С��
  [z, s]  = size(M1); 
  zl= z; sl = s; %����
  
  % check if image expansion necessary �����ͼ���Ƿ���Ҫ��չ/�ж���ż��
  if (floor(z/2) ~= z/2), ew(1) = 1; else ew(1) = 0; end;
  if (floor(s/2) ~= s/2), ew(2) = 1; else ew(2) = 0; end;

  % perform expansion if necessary ����Ҫʱִ����չ/������չΪż����
  if (any(ew))%any()��������Ϊ1��ȫ0��Ϊ0
  	M1 = adb(M1,ew);%adb��չ�к���
  	M2 = adb(M2,ew);
    W1 = adb(W1,ew);
  end;	
  % perform filtering ��ִ�й���/��ͨ�˲���
  G1 = conv2(conv2(es2(M1,2), w, 'valid'),w', 'valid'); %conv2��ά�����es2�Գ���չ2��2��
  G2 = conv2(conv2(es2(M2,2), w, 'valid'),w', 'valid');
  GW1 = conv2(conv2(es2(W1,2), w, 'valid'),w', 'valid');
  % decimate, undecimate and interpolate ��������δ����������ֵ/G1��G2�²������ϲ�����ͨ�˲�����������У�
  M1T = conv2(conv2(es2(undec2(dec2(G1)), 2), 2*w, 'valid'),2*w', 'valid');  %dec2 2���²�����undec2 2���ϲ����������ϲ���
  M2T = conv2(conv2(es2(undec2(dec2(G2)), 2), 2*w, 'valid'),2*w', 'valid');
% tic
  % select coefficients and store them ��ѡ��ϵ�����洢/��Ƶ�Ӵ�ͼ��ϵ��ѡ��
  %E= selc(M1-M1T, M2-M2T, ap);
  E= selc(M1-M1T, M2-M2T, ap);
I=E(1:zl,1:sl);
%figure;imshow(uint8(I));
I=I+GI2;
%figure;imshow(uint8(I));
ReconE=I;
% toc



  % decimate 
%  tic  ���²�����
  M1 = dec2(G1);
  M2 = dec2(G2);
  W1 = dec2(GW1);
%   toc
% select base coefficients of last decompostion stage ����Ƶ�Ӵ�ͼ��ϵ��ѡ��
% tic200
r1 = 200; eps1 = 0.004;
W_B = GuidOptimize(G,S22,r1,eps1);
%figure;imshow(uint8(W_B));
%imwrite(uint8(W_B),strcat('C:\Users\35682\Desktop\����ͼ\',strcat(num2str(r1),'.jpg')));
M1 = selb(M1,M2,mp,W1);   %mp��ͼϵ��ѡ��
% loop over decomposition depth -> synthesis  ��ͼ���ع���
% tic
  % undecimate and interpolate ���ƺͲ���
%   tic
M1T = conv2(conv2(es2(undec2(M1), 2), 2*w, 'valid'), 2*w', 'valid');
  M1T = M1T(1:zl,1:sl);
  ReconM1T = M1T;
  %figure;imshow(uint8(ReconM1T+W_B/2));
  %M1  = M1T + E{i1};
  M1  =  ReconE+  ReconM1T+W_B/3;
%   toc
  % select valid image region ��ѡ��ͼ����Ч����
  %M1 = M1(1:zl,1:sl);
Y = M1;
% toc
