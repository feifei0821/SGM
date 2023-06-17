function Y = selb(M1, M2, mp,GW1)
%Y = selb(M1, M2, mp) coefficient selection for base image
%
%    M1  - coefficients A
%    M2  - coefficients B
%    mp  - switch for selection type
%          mp == 1: select A
%          mp == 2: select B
%          mp == 3: average A and B
% 
%    Y   - combined coefficients

%    (Oliver Rockinger 16.08.99)

%figure;imshow(uint8(M1));
%figure;imshow(uint8(M2));

switch (mp)
  case 1, Y = M1;
  case 2, Y = M2;
  case 3, Y = (M1 + M2) / 2;
  case 4
%figure;imshow(uint8(M1));
%figure;imshow(uint8(M2));
    lambda=10;
    mm = abs(M1);
    %m1=abs(M1);abs()求绝对值
    %m2=abs(M2);
    %R=max(m1-m2,0);
    R=mm;
    Emax = max(R(:));
    P = R/Emax;
    C = atan(lambda*P)/atan(lambda);
  	Y  = (C.*M1) + ((1-C).*M2);
    
  case 5, 
r = size(M2,1); %长
c = size(M2,2); %宽
pyr = gaussian_pyramid(zeros(r,c,1));
nlev = length(pyr);
pyrW = gaussian_pyramid(GW1);
pyrI = laplacian_pyramid(M2);
    for l = 1:nlev
        w = repmat(pyrW{l},[1 1 1]);
        pyr{l} = pyr{l} + w.*pyrI{l};
    end
Recon = reconstruct_laplacian_pyramid(pyr);
%figure;imshow(uint8(M1/2));
%figure;imshow(uint8(Recon));
      Y = M1*5/12 + Recon/2;
      
 % figure;imshow(uint8(Y));
  otherwise, error('unknown option');

end;
