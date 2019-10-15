clear,clc,close all
m=3;
n=2^m-1;%total bits of codeword
k=n-m;%number of information bits
[H,G]=hammgen(m);%produce Generate matrix G and garity check matrix H for Hamming code
b=fliplr(de2bi(0:2^k-1));%convert decimal to binary ,and overturn the code.produce 2^k codes
C=mod(b*G,2);%transmit symbols with mod 2
Cmod=2*C-1;%transmit code, which is mapping function, from data 0\1 to -1\1 level
D=sum(C,2);%sum in rows,
a_vect=[];
for a1=find(D==n);
a2=find(D==n-2);
a3=find(D==n-4)%here code can be expressed as polynomial, to find different
%number of D is finding Hamming weight of the code ,then we obtain the
%expression of a codeword in polynomial.


%maxnumerrs=500;%maximum number of error rate calculate 
%maxnumsyms=1e6;%maximum number of simulate symbols
%EbN0 =0:8; 
%SNRdB_vect=EbN0+10*log10(k/n);
%rawber=[];
%ber=[];
%wer=[];
%for SNRdB=SNRdB_vect
    %sim('channel_coding_simulink');
   % rawber=[rawber rawBER(1)];
    %ber=[ber BER(1)];
    %wer=[wer WER(1)];
%end
    
    
    
