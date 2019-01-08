clear all;
close all;
I = imread('toysflash.png');
I = im2double(rgb2gray(I));
T = 4;

g = imgaussfilt(I, sqrt(2*T), 'FilterSize', 6*ceil(sqrt(2*T))+1, 'padding', 'circular', 'FilterDomain', 'spatial');

% 使用有限差分方式解图像的热扩散方程
I2 = I;

dx = 1;
dy = 1;
dt = 0.05;
for t = 0 : dt : T
    % 对应高斯卷积使用的 circular 的边界条件
    % u(x+dx, y, t)
    I_x_plus = [I2(:, 2:end), I2(:, 1)];
    % u(x-dx, y, t)
    I_x_minus = [I2(:, end), I2(:, 1:end-1)];
    % u(x, y+dy, t)
    I_y_plus = [I2(2:end, :); I2(1, :)];
    % u(x, y-dy, t)
    I_y_minus = [I2(end, :); I2(1:end-1, :)];
    I2 = I2 + dt * ( (I_x_plus + I_x_minus - 2*I2)/(dx^2) +...
        (I_y_plus + I_y_minus - 2*I2)/(dy^2) ); 
end

diff = I2 - g;
norm(diff(:))
subplot(1, 3, 1), imshow(I), title('原始图像');
subplot(1, 3, 2), imshow(g), title('边界条件为对称的高斯卷积');
subplot(1, 3, 3), imshow(I2), title('有限差分解图像热扩散方程');