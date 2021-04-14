x = linspace(0,2*pi, 4096);
y = sin(x);
% fs = 200e3;
% t = [0:1/fs:200e-3];
% y = 0.9*sin(2*pi*1e3*t) + 0.1*sin(2*pi*21e3*t);
% plot(t,y)
y  = 2^15* y;
y = round(y);

plot(y)
data = y;
data(find(data<0)) = data(find(data<0)) + 2^16;
data = dec2hex(data);
