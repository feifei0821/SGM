function Y = selc(M1, M2, ap)
%Y = selc(M1, M2, ap) coefficinet selection for highpass components
%��ͨ����ϵ��ѡ��
%    M1  - coefficients A  ϵ��A
%    M2  - coefficients B
%    ap  - switch for selection type �л�ѡ������
%          ap == 1: choose max(abs) ѡ�����ֵ���
%          ap == 2: salience / match measure with threshold == .75 (as
%          proposed by Burt et al)������/ƥ�������ֵ
%          ap == 3: choose max with consistency check (as proposed by Li et
%          al)��һ���Լ��ѡ�����
%          ap == 4: simple choose max ���ֵ
%
%    Y   - combined coefficients
%    (Oliver Rockinger 16.08.99)
% check inputs 
[z1 s1] = size(M1);
[z2 s2] = size(M2);
if (z1 ~= z2) | (s1 ~= s2)
  error('Input images are not of same size');
end;
%figure;imshow(uint8(M1));
%figure;imshow(uint8(M2));

% switch to method
switch(ap(1))
 	case 1, 
 		% choose max(abs)
%figure;imshow(uint8(M1));
%figure;imshow(uint8(M2));
 		mm = (abs(M1)) > (abs(M2));
  	Y  = (mm.*M1) + ((~mm).*M2);
 
 	case 2,
  	% Burts method ��ը����
  	um = 3; th = .75;
  	% compute salience ����������
  	S1 = conv2(es2(M1.*M1, floor(um/2)), ones(um), 'valid'); 
  	S2 = conv2(es2(M2.*M2, floor(um/2)), ones(um), 'valid'); 
  	% compute match ����ƥ��
  	MA = conv2(es2(M4*M2, floor(um/2)), ones(um), 'valid');
  	MA = 2 * MA ./ (S1 + S2 + eps);
  	% selection 
    m1 = MA > th; m2 = S1 > S2; 
    w1 = (0.5 - 0.5*(1-MA) / (1-th));
    Y  = (~m1) .* ((m2.*M1) + ((~m2).*M2));
    Y  = Y + (m1 .* ((m2.*M1.*(1-w1))+((m2).*M2.*w1) + ((~m2).*M2.*(1-w1))+((~m2).*M1.*w1)));
  	
  case 3,	       
  	% Lis method 
  	um = 3;
    % first step
  	A1 = ordfilt2(abs(es2(M1, floor(um/2))), um*um, ones(um));%��ά˳��ͳ�����˲���n��������ֵ��С����������ڵ�k��λ�õ�Ԫ����Ϊ�˲��������
  	A2 = ordfilt2(abs(es2(M2, floor(um/2))), um*um, ones(um));
    % second step
  	mm = (conv2(double((A1 > A2)), ones(um), 'valid')) > floor(um*um/2);
  	Y  = (mm.*M1) + ((~mm).*M2);
    %figure;imshow(uint8(mm.*M1));
   % figure;imshow(uint8((~mm).*M2));
 
  case 4, 
  	% simple choose max 
  	mm = M1 > M2;
  	Y  = (mm.*M1) + ((~mm).*M2);
    
  case 5,
    %my method
    m1 = abs(M1);
    m2 = abs(M2);
    if(m1>m2)
    R=m1;
    else
        R=m2;
    end
    Emax = max(R(:));
    P = R/Emax;
    C = atan(lambda*P)/atan(lambda);
  	Y  = (C.*M1) + ((1-C).*M2);
    
  case 6,
    %Y = (M1 + M2) / 2;
    Y=M2*2/3;
    
    
  otherwise,
  	error('unkown option');
end;  
 


