%=========================================================================   
% dsexample
%=========================================================================   
% y=dsexample
% This is an exemplary use of the toolbox.
% Calculate the reliability of a simple three-component
% series-parallel system with dependent inputs.
% Please use "type dsexample" or open with an editor
% 
% Usage:
% myfn=inline('sqrt(x(1))*sqrt(x(2))','x')
% lambda=dsstruct([2,3,1])
% dss1=dsodf('expinv',lambda,20)
% dss2=dsodf('expinv',lambda,50)
% y=dsevalmc(myfn,[dss1,dss1,dss1],1000,'dsbound',[1,0,0.5;0,1,0;0.5,0,1])
% dscdf(y)
%=========================================================================
% Copyright (c) Philipp Limbourg, University of Duisburg-Essen
% www.uni-duisburg-essen.de/informationslogistik/
%=========================================================================
echo on;
'This is an example.';
'Calculate the reliability of a simple two-component series system with dependent inputs.';
'1. Define system function. Components 2 and 3 are in parallel:';

myfn=inline('min(x(:,1),max(x(:,2),x(:,3)))','x');

'2. Define component reliability.';
'Component 1 fails with an exponential cdf:';
'Define lambdas';

lambda1=dsstruct([1000,1200,1]);

'Sample cdf using outer discretization, 1000 samples';

component1=dsodf('expinv',1000,lambda1);

'Component 2 fails with a Weibull cdf:';

a2=dsstruct([1/10000,1/5000,1]);

'The b value has two focal elements:';

b2=dsstruct([1.2,1.5,0.1;1.1,1.8,0.9]);
component2=dsodf('weibinv',1000,a2,b2);

'Component 3 fails with a Weibull cdf. Unfortunately we have two estimates';

a3_1=dsstruct([1/10000,1/5000,1]);b3_1=dsstruct([1.2,1.5,0.8;1.1,1.8,0.2]);
a3_2=dsstruct([1/8000,1/4000,1]);b3_2=dsstruct([1.7,1.9,1]);
component3_1=dsconfsample('weibinv',1000,a3_1,b3_1);
component3_2=dsodf('weibinv',1000,a3_2,b3_2);

'Now we aggregate the two estimates using weighted mixing. Expert 1 is twice as competent as Expert 2';

w=[2,1];
component3=dswmix([component3_1,component3_2],w);

'3. Now we propagate the uncertain variables through our system function';
'Setting up the correlation matrix. Component 2 and 3 have a positive correlation';

corr=[1,0,0;0,1,0.5;0,0.5,1];

'Now start the propagation. The optimizer should be dsbound as the function is monotonously increasing. 1000 iterations, time to get a coffee (-;';

y=dsevalmc(myfn,[component1,component2,component3],10000,'dsbound',corr);

'Now plot the system function';

dscdf(y);

'Deriving some statistics';

statsy.exp=dsexpect(y);
statsy.med=dsconf(y,0.5);
statsy.conf95=dsconf(y,0.95);

'Deriving some uncertainty measures';

statsy.aggUncertainty=dsaggunc(y);
statsy.avgWidth=dsavgwidth(y);
statsy.dissonance=dsdissonance(y);
statsy.nonspecifity=dsnonspec(y);

'Sensitivity';
[a,b,c]=dssensitivity([component1,component2,component3],[1,2,3],myfn,'dsavgwidth',500,100);
    figure;
       bar(100*(1-c));
       xlabel('Component ID');
       ylabel('S in % - Avg. Width');
echo off;