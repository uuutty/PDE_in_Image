close all;
clear all;

dh = 0.2;
dt = 0.05;
beta = 1; %那里面是1
% 空间上的终点
L =10;
% 时间上的终点
T = 10;
% 生成采样的x
x = 0: dh : L;
% 采样点的数目
N = size(x, 2);
% 初始时刻
u = sin(pi/L*x) + 2*sin(3*pi/L*x) + sin(5*pi/L*x);
u2 = [-fliplr(u(2:end)) u -fliplr(u(1:end-1))];
% 设置一个用来迭代的u

sigma = sqrt(2 * T);
y = 0 : dh : 3*sigma;
y = [-fliplr(y(2:end)), y];
g = 1 / sqrt(4*pi*T) * exp(-y.^2 ./ (4*T));
% g = g / (sum(g)*dh);
figure
plot(y, g);

u2 = [u, -fliplr(u(2:end-1))];
s_idx = floor(size(g, 2) / 2);
u_gau = zeros([1, N]);
M = size(g, 2);
ext_N = size(u2, 2);
c = zeros(2, M);
d = zeros(2, M);
for i = 1 : N
    for j = 1 : M
        idx = mod(s_idx+i-j+1 - 1, ext_N) + 1;
        u_gau(i) = u_gau(i) + g(j)*u2(idx);
        if i == 25
            c(1, j) = idx;
            c(2, j) = j;
        end
        if i == 26
            d(1, j) = idx;
            d(2, j) = j;
        end
    end
end
u_gau = u_gau * dh;
sum(g)*dh

% 根据pdf中的解析解是
k = [beta*1*pi/L beta*3*pi/L beta*5*pi/L];
u_ana = exp(-k(1)^2*T)*sin(k(1)/beta*x) + 2*exp(-k(2)^2*T)*sin(k(2)/beta*x) + 1*exp(-k(3)^2*T)*sin(k(3)/beta*x);
% 显示一下迭代后的图像
figure
subplot(1, 3, 1), plot(x, u), title('T = 0');
subplot(1, 3, 2), plot(x, u_gau), title('T = 10 同高斯函数卷积');
subplot(1, 3, 3), plot(x, u_ana), title('T = 10 数学解析解');

gg = conv(u, g, 'same');
figure
subplot(1, 3, 1), plot(x, u, 'or')
subplot(1, 3, 2), plot(x, g((M+1)/2: (M+1)/2+N-1), '*g');
subplot(1, 3, 3), plot(0, gg(1), 'sb');
figure
hold on
plot([-fliplr(x(2:end)), x(1:end-1)], -u2);
plot(0, 0, 'or');
sum(u(:))
sum(u_gau(:))
sum(u_ana(:))