clc,clear, close all
step=0.1:0.1:1;
%error2=zeros(length(step));
n=1;
for num=1:1:10
    st=step(n);
    n=n+1;
    sim('variant_step_simulink')
    error2(num)=mean(simout);
end
error1=step.^2/12;
plot(step,error1,'r*');
hold on,grid on
plot(step,error2,'b+');
