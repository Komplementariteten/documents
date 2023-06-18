close all
clear all
clc

T=2;
w1=2*pi/T;
m=1;

p=6;
t_max=T*p;
dt=0.001;
t=0:dt:t_max;
f=m*t-floor(t/T)*T*m;
a0=0;
for i=1:(T/dt)
  f_v=f(i)+f(i+1);
  a0=a0+(dt*(f_v)/2);
end
a0=2*a0/T;
n=6;
a=zeros(n,1);
b=zeros(n,1);
for k=1:n
    for i=1:(T/dt)
        a(k)=a(k)+dt*(f(i)*cos(k*w1*t(i))+f(i+1)*cos(k*w1*t(i+1)))/2;
        b(k)=b(k)+dt*(f(i)*sin(k*w1*t(i))+f(i+1)*sin(k*w1*t(i+1)))/2;
    end
end
a=2*a/T;
b=2*b/T;

g=f*0+(a0/2);
for k=1:n
    g=g+a(k)*cos(k*w1*t)+b(k)*sin(k*w1*t);
end
figure(1)
grid on
hold on
plot(t, f, '-r', 'LineWidth', 3.0)
plot(t, g, '-b', 'LineWidth', 1.5)
xlabel('t in s', 'FontSize', 11)
ylabel('f(t) und g(t)', 'FontSize', 11)
