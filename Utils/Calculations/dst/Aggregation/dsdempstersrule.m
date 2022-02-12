function erg=dsdempstersrule(x,accuracy)
%=========================================================================   
% dsdempstersrule
%=========================================================================   
% y=dsdempstersrule(x,accuracy) 
% 
% Dempsters rule
%
% Input:
% x: Array of Dempster-Shafer structures. 
% accuracy (optional): Minimal mass of focal elements. If empty,
% accuracy:=0.001
%
% Output:
% y: Aggregation function
%
% Warning: Dempsters rule uses time and memory
% O(|m|^|x|), |m| number of focals by structure, |x| number of structures.
% Meaning: 5 structures with 1000 focals: Maximal 10^15 bytes
%
% Accuracy= 0.001 restricts that each intermediate structure in the
% calculation process has only focals with mass 0.001. dsred is used for
% reduction.
%
% Usage: Aggregating two exponential cdfs.
% lambda1=dsstruct([2,3,1])
% dss1=dsodf('expinv',1000,lambda1);
% lambda2=dsstruct([5,6,1])
% dss2=dsodf('expinv',1000,lambda2);
% y=dsdempstersrule([dss1,dss2])
% dscdf(y)
%=========================================================================
% Reference : Ferson, S., V. Kreinovich, et al. (2003). Constructing
% Probability Boxes and Dempster-Shafer Structures. Albuquerque, Sandia
% National Laboratories.
% Link      : http://citeseer.ist.psu.edu/660030.html
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
erg=x(1);
acc=0.001;
if nargin>1
acc=accuracy;
end
for i=2:length(x)
        erg=dsred(erg,acc);
        x(i)=dsred(x(i),acc);        
    erg=mydsdempmult(erg,x(i));
end
erg=dsnorm(erg);
erg=dsred(erg,acc);
end
function erg=mydsdempmult(x,y)
a=x.ds;
b=y.ds;
dimx=size(a,1);
dimy=size(b,1);
erg=dsstruct;
c=zeros(dimx*dimy,3);
count=1;
for i=1:size(a,1)
    for j=1:size(b,1)        
        if (a(i,1)<b(j,2) && b(j,1)<a(i,2))
            c(count,1)=max(a(i,1),b(j,1));
            c(count,2)=min(a(i,2),b(j,2));
        c(count,3)=a(i,3)*b(j,3);
        count=count+1;
    end
    end
end
erg.ds=c(1:count-1,:);
end