clc ,clear, close all
rho=-0.9;
gk=[0 1 rho];%discrete time channel
Kg=sqrt(gk*gk');%normalize the energy Eg=1
gk=gk/Kg;
psigk=xcorr(gk);
lengk=length(gk);
M=16;
sig2a=2*(M-1)/3;
SNRdB=20;
SNR=10^(SNRdB/10);
N0=sig2a/SNR;
Lvect=5:5:50;
Dvect=1:50;
MSED=zeros(length(Lvect),length(Dvect));
 
for icf=1:length(Lvect)
    L=Lvect(icf);
  psigkZP=[psigk(lengk:end) zeros(1,L-lengk)];
  b=toeplitz(psigkZP);%makes it start from the main п╠ап, add zeros to expad the row and column of psigk
  b1=sig2a*b;%a*gk 
  PSIy=b1+N0*eye(L);%add noise in main п╠ап psd of y, fi y
  

  for D=Dvect%delay
      gk_ext=[zeros(1,L-1) gk zeros(1,D-lengk)];
      gD_=fliplr(gk_ext(D:L+D-1))';%for different delay we have different gD_ e.x.D=1;g0 g-1 g-2 g-3 g-4   D=2 g1 g0 g-1 g-2 g-3 etc
      coptD=sig2a*inv(PSIy)*conj(gD_);
      MSED(icf,D)=sig2a*(1-gD_.'*coptD);
  end
end
figure(1)
plot(Dvect,10*log10(MSED));hold on
xlabel('delay')
ylabel('MSE dB')

simMSE=zeros(1,length(Lvect));
Dopt=zeros(1,length(Lvect));
for icf=1:length(Lvect)
     [minMSED,posMSED]=min(MSED(icf,:));%find minimum value and the position of optimum delay
     D=posMSED;
     Dopt(icf)=D;
    L=Lvect(icf);
  psigkZP=[psigk(lengk:end) zeros(1,L-lengk)];
  b=toeplitz(psigkZP);%makes it start from the main п╠ап, add zeros to expad the row and column of psigk
  b1=sig2a*b;
  PSIy=b1+N0*eye(L); 
gk_ext=[zeros(1,L-1) gk zeros(1,D-lengk)];
      gD_=fliplr(gk_ext(D:L+D-1))';%for different delay we have different gD_ e.x.D=1;g0 g-1 g-2 g-3 g-4   D=2 g1 g0 g-1 g-2 g-3 etc
      coptD=sig2a*inv(PSIy)*conj(gD_);
      sim('MSE_SIMULINKS',1e5);
      simMSE(icf)=measureMESED(1);
end

plot(Dopt,10*log10(simMSE),'k*')
