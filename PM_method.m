clear all;
close all;
I = imread('coins.png');
I = im2double(I);
% I = imresize(I, 0.5);

dx = 0.2;
dy = 0.2;
dt = 0.011;
T = 40;
lambda = 0.1;
1/(2/(dx^2) + 2/(dy^2))
cond = dt <= ( 1/(2/(dx^2) + 2/(dy^2)) );
cond
u = I;
for t = 0 : dt : T
    % 还是采取周期的边界假设
    u_x_plus = [u(:, 2:end), u(:, 1)];
    u_x_minus = [u(:, end), u(:, 1:end-1)];
    u_y_plus = [u(2:end, :); u(1, :)];
    u_y_minus = [u(end, :); u(1:end-1, :)];
    
    % c(x+dx/2,...)
    c_x_add = 1 ./ (1+((u_x_plus-u)./dx).^2 / lambda^2);
    % c(x-dx/2,...)
    c_x_sub = 1 ./ (1+((u-u_x_minus)./dx).^2 / lambda^2);
    % c( ,y+dy/2)
    c_y_add = 1 ./ (1+((u_y_plus-u)./dy).^2 / lambda^2);
    % c(, y-dy/2)
    c_y_sub = 1 ./ (1+((u-u_y_minus)./dy).^2 / lambda^2);
    
    u = u + dt .* ( 1/(dx^2) .* (c_x_add.*(u_x_plus-u) - c_x_sub.*(u-u_x_minus))...
                  +1/(dy^2) .* (c_y_add.*(u_y_plus-u) - c_y_sub.*(u-u_y_minus))...
                  );
end
% 对比的热扩散方程
g = imgaussfilt(I, sqrt(2*T), 'FilterSize', 6*ceil(sqrt(2*T))+1, 'padding', 'circular', 'FilterDomain', 'spatial');
subplot(1, 3, 1), imshow(I);
subplot(1, 3, 2), imshow(g);
subplot(1, 3, 3), imshow(u);