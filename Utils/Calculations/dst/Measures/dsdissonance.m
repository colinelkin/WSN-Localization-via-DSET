function y=dsdissonance(x)
%=========================================================================   
% dsdissonance
%=========================================================================   
% y=dsdissonance(x)
% Returns the dissonance uncertainty measure for of a Dempster-Shafer
% structure x. For further information on this uncertainty measure, see
% references.
%
% Input: 
% x: Dempster-Shafer structure to be reduced
%
% Output:
% y: Dissonance
%
% Usage:
% lambda=dsstruct([2,3,1])
% dss=dsodf('expinv',10000,lambda)
% y=dsdissonance(dss)
% =========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
% Reference : Klir GJ: Uncertainty and Information : Foundations of
% Generalized Information Theory. Wiley-IEEE Press (2005).
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
temp=x.ds;
a=[-inf,0;dsbel(x)];
b=[dspl(x);inf,1];
c1=0;
c2=0;
y=0;
tlb=sortrows([temp(:,1),[1:size(temp,1)]'],1);
tub=sortrows([temp(:,2),[1:size(temp,1)]'],1);
clb=1;
cub=1;
c1=zeros(size(temp,1),1);
c2=zeros(size(temp,1),1);
for i=1:size(temp,1)
    while (a(clb,1)<tlb(i,1))
        clb=clb+1;
    end
    c1(tlb(i,2))=clb-1;
    while (b(cub,1)<=tub(i,1))
        cub=cub+1;
    end
    c2(tub(i,2))=cub-1;
end
c1=a(c1,2);
c2=b(c2,2); 
y=-sum(temp(:,3).*log2(c2-c1));
