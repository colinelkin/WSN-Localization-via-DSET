function erg=dsred(y,thres)
%=========================================================================   
% dsred
%=========================================================================   
% y=dsred(x,thres)
% Reduces the size of a Dempster-Shafer structure x by merging focal
% elements.
%
% Input: 
% x: Dempster-Shafer structure to be reduced
% thres (optional): 0<thres<1, minimal mass of focals. Default: 0.001
%
% Output:
% y: Reduced Dempster-Shafer structure
%
% Usage:
% lambda=dsstruct([2,3,1])
% dss=dsodf('expinv',10000,lambda)
% y=dsred(dss,0.05)
% dscdf(dss);
% hold;
% dscdf(y,'color','blue');
% =========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
if nargin<2
    thres=0.001;
end
y.ds=sortrows(y.ds,1);
%down=inf;
down=0;
up=0;
erg=dsstruct;
siz=size(y.ds,1);
last=0;
step=siz*thres;
if step < 1
    erg=y;
    return
end
i=1;
num=0;
    imin=0;
    imax=0;    
while (i<=siz)
    imin=i;
    mass=0;
while (i<=siz && mass<thres)    
        mass=mass+y.ds(i,3);
        imax=i;
        i=i+1;
    end
        down=mean(y.ds(imin:imax,1));
        up=mean(y.ds(imin:imax,2));     
        erg.ds=[erg.ds;[down,up,mass]];
end