function [euncraw,euncnorm, euncquot]=dssensitivity(x, parnums, fhandle, uncfn, mcIT, pinch_samples, pinch_type)
%=========================================================================   
% dssensitivity
%=========================================================================   
% [euncraw,euncnorm, euncquot]=dssensitivity(x, parnums, fhandle, uncfn, mcIT, pinch_samples, pinch_type) 
% 
% Sensitivity measure routine based on Monte-Carlo sampling. Performs a
% sensitivity analysis on the function f(x) using an uncertainty measure "uncfun". Sensitivity is
% measured by reducing the input variable uncertainty and detecting the
% change in the overall uncertainty.
% Input uncertainty is reduced by iterative, random "pinching", replacing an input x_i by a
% random point/interval/distribution enclosed by x_i.
%
% Input:
% x: Input vector of Demster-Shafer structures
% parnums: Indices of elements in x that are the objective of the
% sensitivity analysis
% fhandle: Function handle of f(x)
% uncfun: Uncertainty measure (i. e. dsaggunc, dsavgwidth, ...)
% mcIT: Number of MC samples per pinch_sample input
% pinch_samples: Number of pinch_samples
% pinch_type (optional): Type of pinching, pinch_type='point' for sampling points in
% x_i (default), pinch_type='interval' for sampling intervals annd
% pinch_type='distribution' for distributions.
%
% Output:
% euncraw: Difference of uncertainty in f(x) between pinched and unpinched
% input x_i
% euncnorm: Difference of uncertainty in f(x) between pinched and unpinched
% euncquot: Quotient of uncertainty in f(x) between pinched and unpinched
% input x_i
%
% Usage - Determining the sensitivity of the average width and of the
% dissonance measure:
% myfn=inline('sqrt(x(:,1).^2.+abs(x(:,2)))','x')
% mu=dsstruct([2,3,1])
% dss1=dsodf('norminv',200,mu)
% dss2=dsodf('norminv',500,mu)
% [a,b,c]=dssensitivity([dss1,dss2],[1,2],myfn,'dsavgwidth',200,100);
% bar(100*(1-c));
% xlabel('Input');
% ylabel('S in % - dsavgwidth');
% [a2,b2,c2]=dssensitivity([dss1,dss2],[1,2],myfn,'dsdissonance',200,100,'interval');
% figure
% bar(100*(1-c2));
% xlabel('Input');
% ylabel('S in % - dsdissonance');
%=========================================================================
% Reference : Ferson S, Tucker WT: Sensitivity in Risk Analyses with
% Uncertain Numbers. Sandia National Laboratories, Albuquerque (2006).
% Link      : http://citeseer.ist.psu.edu/660030.html
% Reference : Limbourg P, Savic R, Petersen J, Kochs H-D: Fault Tree
% Analysis in an Early Design Stage using the Dempster-Shafer Theory of
% Evidence. In: Terje Aven JEV (ed) European Conference on Safety and
% Reliability – ESREL 2007, pp. 713-722. Taylor and Francis, Stavanger, Norway (2007).
% Link      :
% http://iit.uni-duisburg.de/forschung/veroeffentlichungsdateien/2007/LSKP07.pdf
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
%gds=dsevalmc(fhandle,x,max(mcIT,100000),'dsbound',[]);
%uncgds=feval(uncfn,gds,uncparams);
if nargin<7
    pinch_type='point'
end
for parnum=parnums
dss=x;
dsst=x(parnum);
mcsel=dsst.ds(1,3);
unc=zeros(1,pinch_samples);
for i=2:size(dsst.ds,1)
    mcsel(i)=mcsel(i-1)+dsst.ds(i,3);
end
for i=1:pinch_samples
    if strcmp(pinch_type,'point')|strcmp(pinch_type,'interval')
    numsamp=1;
    for j=1:numsamp
    ind1(j)=sum(mcsel>=rand);
    end
    foc.ds=dsst.ds(ind1,:);
    if strcmp(pinch_type,'point')
    foc.ds(:,1)=foc.ds(:,1)+rand(numsamp,1).*(foc.ds(:,2)-foc.ds(:,1));
    foc.ds(:,2)=foc.ds(:,1);
    end
    foc.ds(:,3)=foc.ds(:,3)./sum(foc.ds(:,3));
    end
    if strcmp(pinch_type,'distribution')    
    foc.ds=dsst.ds;        
    foc.ds(:,1)=dsst.ds(:,1)+rand(size(dsst.ds,1),1).*(dsst.ds(:,2)-dsst.ds(:,1));
    foc.ds(:,2)=foc.ds(:,1);        
    end
    dss(parnum)=foc;
    ytemp=dsevalmc(fhandle,{x,dss},mcIT,'dsbound',[]);
    gds=ytemp{1};
    y=ytemp{2};
    unc(i)=feval(uncfn,y);
    uncgds(i)=feval(uncfn,gds);    
    uncraw(i)=abs(unc(i)-uncgds(i));
    uncquot(i)=abs(unc(i)/uncgds(i));
end
uncnorm=uncraw./feval(uncfn,dsst);
euncraw(parnum)=median(uncraw);
euncnorm(parnum)=median(uncnorm);
euncquot(parnum)=median(uncquot);
%uncquot=100*(1-median(uncquot));
end