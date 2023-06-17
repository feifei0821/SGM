function Y = lp_fuse(M1, M2, zt, ap, mp,GI2,G,S22,W1)
%Y = fuse_lap(M1, M2, zt, ap, mp) image fusion with laplacian pyramid
%
%    M1 - input image A
%    M2 - input image B
%    zt - maximum decomposition level(最大分解级别/融合层数)
%    ap - coefficient selection highpass (see selc.m) （高通系数选择）
%    mp - coefficient selection base image (see selb.m) （基图系数选择）
%
%    Y  - fused image   

%    (Oliver Rockinger 16.08.99)
% check inputs 
%GM1=M2/255;
[z1, s1] = size(M1);  %获取行和列
[z2, s2] = size(M2);
M1=double(M1);
M2=double(M2);
W1=double(W1);
if (z1 ~= z2) | (s1 ~= s2)
  error('Input images are not of same size');
end;   %判断两幅图尺寸是否一致

% define filter （定义滤波器）高斯函数窗口
w  = [1 4 6 4 1] / 16;      %除以16
% cells for selected images
% tic
% loop over decomposition depth -> analysis  （循环分解深度->分析）
    tic     %tic保存当前时间，toc记录程序完成时间
  % calculate and store actual image size （计算并存储实际图像大小）
  [z, s]  = size(M1); 
  zl= z; sl = s; %数组
  
  % check if image expansion necessary （检查图像是否需要扩展/判断奇偶）
  if (floor(z/2) ~= z/2), ew(1) = 1; else ew(1) = 0; end;
  if (floor(s/2) ~= s/2), ew(2) = 1; else ew(2) = 0; end;

  % perform expansion if necessary （必要时执行扩展/奇数扩展为偶数）
  if (any(ew))%any()有正数则为1，全0则为0
  	M1 = adb(M1,ew);%adb扩展行和列
  	M2 = adb(M2,ew);
    W1 = adb(W1,ew);
  end;	
  % perform filtering （执行过滤/低通滤波）
  G1 = conv2(conv2(es2(M1,2), w, 'valid'),w', 'valid'); %conv2二维卷积，es2对称扩展2行2列
  G2 = conv2(conv2(es2(M2,2), w, 'valid'),w', 'valid');
  GW1 = conv2(conv2(es2(W1,2), w, 'valid'),w', 'valid');
  % decimate, undecimate and interpolate （抽样，未经抽样，插值/G1与G2下采样、上采样低通滤波后的膨胀序列）
  M1T = conv2(conv2(es2(undec2(dec2(G1)), 2), 2*w, 'valid'),2*w', 'valid');  %dec2 2倍下采样，undec2 2倍上采样，矩阵上采样
  M2T = conv2(conv2(es2(undec2(dec2(G2)), 2), 2*w, 'valid'),2*w', 'valid');
% tic
  % select coefficients and store them （选择系数并存储/高频子带图像系数选择）
  %E= selc(M1-M1T, M2-M2T, ap);
  E= selc(M1-M1T, M2-M2T, ap);
I=E(1:zl,1:sl);
%figure;imshow(uint8(I));
I=I+GI2;
%figure;imshow(uint8(I));
ReconE=I;
% toc



  % decimate 
%  tic  （下采样）
  M1 = dec2(G1);
  M2 = dec2(G2);
  W1 = dec2(GW1);
%   toc
% select base coefficients of last decompostion stage （低频子带图像系数选择）
% tic200
r1 = 200; eps1 = 0.004;
W_B = GuidOptimize(G,S22,r1,eps1);
%figure;imshow(uint8(W_B));
%imwrite(uint8(W_B),strcat('C:\Users\35682\Desktop\显著图\',strcat(num2str(r1),'.jpg')));
M1 = selb(M1,M2,mp,W1);   %mp基图系数选择
% loop over decomposition depth -> synthesis  （图像重构）
% tic
  % undecimate and interpolate 估计和插入
%   tic
M1T = conv2(conv2(es2(undec2(M1), 2), 2*w, 'valid'), 2*w', 'valid');
  M1T = M1T(1:zl,1:sl);
  ReconM1T = M1T;
  %figure;imshow(uint8(ReconM1T+W_B/2));
  %M1  = M1T + E{i1};
  M1  =  ReconE+  ReconM1T+W_B/3;
%   toc
  % select valid image region （选择图像有效区域）
  %M1 = M1(1:zl,1:sl);
Y = M1;
% toc
