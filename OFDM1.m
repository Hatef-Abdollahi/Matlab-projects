clear, clc ,close all

Rb=24e6;%bit rate
M=64;%number of M-QAM consellation points
N=1024;%number of subcorrier
Nu=980;%used of sub carrier
Nc=N-Nu;
FreameLen=Nu*log2(M);%each symbol contains how many bits
SNRdB=20;
k=0:49;
sig=10;
hk=exp(-k*sig);
mucp=64;
hk=hk/sqrt(hk*hk');