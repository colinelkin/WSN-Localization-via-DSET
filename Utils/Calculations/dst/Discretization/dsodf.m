function erg=dsodf(fhandle,intervalnumber,varargin)
%=========================================================================
% dsodf
%=========================================================================
% y=dsodf(fhandle,intervalnumber,varargin) 
% Discretizes a given inverse probability cdf using the outer discretization method. 
%
% Input: 
% fhandle: Function handle or function name
% intervalnumber: Number of discretized probability samples
% varargin: Parameters of fhandle
%
% The cdf must have the form cdf(p,param1,param2,...)
%
% Output:
% y: Sampled inverse probability cdf with focal elements. 
% Size: intnr x length(params(1).ds)... length(params(n).ds)
%
% Usage:
% mu=dsstruct([1,1.4,1])
% sigma=dsstruct([1.4,2.7,0.9;1.5,1.8,0.1])
% y=dsodf('norminv',1000,mu,sigma)
% dscdf(y)
%
%=========================================================================
% Reference : Tonon, F. (2004). "Using random set theory to propagate
% epistemic uncertainty through a mechanical system." Reliability
% Engineering and System Safety 85(1-3): 169-181.
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
mythres=0.999999/fix(intervalnumber);
erg=dsstruct;
erg.ds=zeros(intervalnumber,3);
count=1;
params=[varargin{:}];
l=length(params);
doestr=[];
ind=[];
for i=1:l
    siz=size(params(i).ds,1);
    if (siz>1)
        doestr=[doestr,siz];
        ind=[ind,i];
    end
end
tempdoe=[];
if (~isempty(doestr))
    tempdoe=fullfact(doestr);
else
    tempdoe=1;
end
doe=ones(size(tempdoe,1),l);
doe(:,ind)=tempdoe(:,1:length(ind));
for i=1:size(doe,1)
    prob=1;
    for j=1:l
        prob=prob*params(j).ds(doe(i,j),3);
    end
    %  for j=mythres+1-0.9999999:mythres:0.9999999
    temp(1:l)=2;
    doe2=fullfact(temp);
    for k=1:size(doe2,1)
        for k2=1:l
            peval{k2}=params(k2).ds(doe(i,k2),doe2(k,k2));
        end
        t1=mythres+1-0.9999999:mythres:0.9999999;
        t2=t1-mythres;
        borders(:,2*k-1)=feval(fhandle,t1',peval{:});
        borders(:,2*k)=feval(fhandle,t2',peval{:});
    end
    erg.ds(count:count+size(borders,1)-1,1)=min(borders,[],2);
    erg.ds(count:count+size(borders,1)-1,2)=max(borders,[],2);
    erg.ds(count:count+size(borders,1)-1,3)=mythres*prob;
    count=count+size(borders,1);
end
erg=dsnorm(erg);
end