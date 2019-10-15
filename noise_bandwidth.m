clear, clc ,close all
framelength=2^10;
N0=2;
n_vect=1:8;
BnEstim=zeros(1,length(n_vect));
BnTheory=zeros(1,length(n_vect));
for icn=1:length(n_vect)
    n=n_vect(icn);
    zp=1-2^(-n);
    lam=1-zp;
    simlength=1e3*framelength;
    sim('noise_bandwidth_simulink',simlength);
    BnEstim(icn)=BnT(1);
    BnTheory(icn)=10*log10((1-zp)/2/(1+zp));
end
