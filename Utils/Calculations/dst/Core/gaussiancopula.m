function erg = gaussiancopula(corr,number)
siz = length(corr);
if nargin<2
    number=1;
end
erg=mvnrnd(zeros(1,siz),corr,number);
erg=normcdf(erg);
end