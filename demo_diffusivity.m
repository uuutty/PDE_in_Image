clear all;
close all;

lamda = 1;
L = 10;
dx = 0.01;
s = 0 : dx : L;
c = 1 ./ (1 + s.^2./lamda^2);
phi = s .* c;
dphi_ds = (phi(2:end) - phi(1:end-1)) / dx;
dc_ds = (c(2:end) - c(1:end-1)) / dx;
figure
subplot(1, 3, 1), plot(s, c);
subplot(1, 3, 2), plot(s, phi);
subplot(1, 3, 3), plot(s(1:end-1), dphi_ds);
figure
plot(s(1:end-1), dc_ds);