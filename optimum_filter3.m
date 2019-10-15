clear, clc ,close all
gammag=0.3*pi/180;
T=1;
NFFT=2^9;
P=1;
f=(0:NFFT-1)/NFFT/T;
z_theta=1-1e-6;
z=exp(1i*2*pi*f*T);
Psi_theta=gammag^2./((1-z_theta*z.^(-1)).*(1-z_theta*z));
SNRdBvect=10:5:50;
Nmax=150;
mse_theta=zeros(Nmax+1, length(SNRdBvect));%define a matrix which is Nmax+1 by SNRdBvect,contain MSE_theta for different N and different SNRsB
mse_n=zeros(Nmax+1, length(SNRdBvect));
optimal_mse=zeros(1,length(SNRdBvect));
optimal_length=optimal_mse;
icf=0;

for SNRdB=SNRdBvect
    icf=icf+1;
    icf_N=0;
    for N=0:Nmax
        icf_N=icf_N+1;
        tri_filter=[N+1:-1:1 zeros(1,NFFT-2*N-1) 1:N];%define the shape of the triangle filter after fftshift
        tri_filter=tri_filter/sum(tri_filter);%normalize the sum to be 1
        TRI_FILTER=fft(tri_filter) ;
        mse_theta(icf_N,icf)=real(1/(NFFT*T)*sum(Psi_theta.*abs(1-TRI_FILTER).^2));
        mse_n(icf_N,icf)=real(1/(NFFT*T)*sum(abs(TRI_FILTER).^2/(2*10^(SNRdB/10))));
    end
    [optimal_mse(icf),optimal_length(icf)]=min(mse_theta(:,icf)+mse_n(:,icf));
end

optimal_length=optimal_length-1;%because matlab start from 1,but N sttart from 0.
optimal_length=2*optimal_length+1;%L=2N+1
        
 figure(1)
 plot(2*(0:Nmax)+1,10*log10(mse_theta+mse_n),'LineWidth', 2);
 grid on
 h=xlabel('L');
 h=ylabel('MSE_(dB)');
 h=title('Triangular filter, \gamma=0.3бу, SNR=\{10,15,\1dots,50\}');
 hold on,
 h=plot(optimal_length,10*log10(optimal_mse),'k*','LineWidth',2);

 mse_u_theory=zeros(size(SNRdBvect));
 icf=0;
 for SNRdB=SNRdBvect
    icf=icf+1;
    zetag=1+gammag^2*10^(SNRdB/10);
    z_p=zetag-sqrt(zetag^2-1);
    h_ucf=(1-z_p)/2/(1+z_p)*impz([1 z_p],[1 -z_p ])';
   h_u=[fliplr(h_ucf(2:end)) 2*h_ucf(1) h_ucf(2:end)];
   K=length(h_ucf)-1;
   mse_u_theory(icf)=(1-z_p)/(1+z_p)/2/10^(SNRdB/10);
end
figure(2)
plot(SNRdBvect,10*log10(optimal_mse)-10*log10(mse_u_theory),'k-','LineWidth',2);
hold on, grid on
h=xlabel('SNR_(dB)');
h=ylabel('\Delta_MSE_(dB)');
h=title('MSE gap between the best triangular filter and the optimal one, \gamma=0.3бу');


icf=0; 
mse_tri_sim=zeros(size(SNRdBvect));
 for SNRdB=SNRdBvect
            icf=icf+1;
            N=(optimal_length(icf)-1)/2;
            tri_filter=[1:N+1 N:-1:1];
             tri_filter= tri_filter/sum( tri_filter);
             ref_tri=N;
             if ref_tri~=0
                 sim('optimum_filter_simulink_Q2', 1e5);
             else
                 sim('optimum_filter_simulink_Q2',1e6);
             end
             mse_tri_sim(icf)=MSE_tri;
 end 
figure(2)
plot(SNRdBvect,10*log10(optimal_mse)-10*log10(mse_u_theory),'k-','LineWidth',2);
hold on ;grid on
h=xlabel('SNR_(dB)');
h=ylabel('\Delta_MSE_(dB)');
h=title('MSE gap between the best triangular filter and the optimal one, \gamma=0.3бу');
h=plot(SNRdBvect, 10*log10(mse_tri_sim)-10*log10(mse_u_theory),'r*','LineWidth',2);
h=legend('-Theoretical','*simulation','location','northwest' );      

