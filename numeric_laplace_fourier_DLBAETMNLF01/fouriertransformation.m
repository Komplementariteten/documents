close all
clear all
clc

T=2;
dt=0.001;
t=0:dt:T;
m=1;
f=t*m;
N=length(f);
n=20;

cRE=zeros(n+1, 1);
cIM=zeros(n+1,1);
for k=-n:1:n
  for i=1:1:N-1
    cRE(abs(k)+1)=cRE(abs(k)+1)+f(i)*cos(2*pi*k*i/N);
    cIM(abs(k)+1)=cIM(abs(k)+1)+f(i)*sin(2*pi*k*i/N);
  end
  cRE(abs(k)+1) = cRE(abs(k)+1)/N;
  cIM(abs(k)+1) = cIM(abs(k)+1)/N;
end
A=2*sqrt(cRE.^2 + cIM.^2);
A(1) = A(1)/2;

figure(1)
grid on
hold on
plot((0:1:n), A, 'ob')
c=fft(f);
A=2*abs(c/N);
a(1)=A(1)/2;
plot((0:1:n), A(1:n+1), 'xg')
legend('DFT', 'FFT')


