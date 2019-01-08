clear all;
close all;
I = imread('coins.png');
I = im2double(I);
% I = imresize(I, 0.5);

dx = 0.2;
dy = 0.2;
dt = 0.01;
lambda = 0.1;
1/(2/(dx^2) + 2/(dy^2))
cond = dt < ( 1/(2/(dx^2) + 2/(dy^2)) );
cond
u = I;
[m, n] = size(I);
bias_T = 2;
bias_lambda = 0.1;
k = 10;
us = zeros(k, m, n);
for i = 1 : k
    % T = bias_T * i;
    T = 0.5;
    lambda = bias_lambda * i;
    u = I;
    for t = 0 : dt : T
        u_x_plus = [u(:, 2:end), u(:, 1)];
        u_x_minus = [u(:, end), u(:, 1:end-1)];
        u_y_plus = [u(2:end, :); u(1, :)];
        u_y_minus = [u(end, :); u(1:end-1, :)];

        c_x_add = 1 ./ (1+((u_x_plus-u)./dx).^2 / lambda^2);
        c_x_sub = 1 ./ (1+((u-u_x_minus)./dx).^2 / lambda^2);
        c_y_add = 1 ./ (1+((u_y_plus-u)./dy).^2 / lambda^2);
        c_y_sub = 1 ./ (1+((u-u_y_minus)./dy).^2 / lambda^2);

        u = u + dt .* ( 1/(dx^2) .* (c_x_add.*(u_x_plus-u) - c_x_sub.*(u-u_x_minus))...
                      +1/(dy^2) .* (c_y_add.*(u_y_plus-u) - c_y_sub.*(u-u_y_minus))...
                      );
    end
    us(i, :, :) = u;
    subplot(2, 5, i), imshow(u);
end
% for i = 1 : k
%     subplot(2, 5, i), imshow(reshape(us(i, :, :), m, n));
% end