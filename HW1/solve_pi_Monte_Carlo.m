% 解法二：蒙特卡洛方法
% 设置参数
num_points = 1000000; % 生成的点的数量
x_range = [-1, 1];
y_range = [-1, 1];
radius = 1;

% 生成一组随机的坐标
x_coords = (x_range(2) - x_range(1)) * rand(1, num_points) + x_range(1);
y_coords = (y_range(2) - y_range(1)) * rand(1, num_points) + y_range(1);

% 计算随机点中在圆内的点的数量
distances = sqrt((x_coords).^2 + (y_coords).^2);
points_inside_circle = sum(distances <= radius);

% 计算pi的值
pi_estimate = 4 * points_inside_circle / num_points;
fprintf('pi的估计值为：%f\n', pi_estimate);

% 可视化
figure;
for i = 1:100:num_points
    if distances(i) <= radius
        plot(x_coords(i), y_coords(i), 'b.');
    else
        plot(x_coords(i), y_coords(i), 'r.');
    end
    hold on;
end
hold on;
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'r');
viscircles([0, 0], 1, 'Color', 'r');
axis equal;
title(['pi的估计值为：', num2str(pi_estimate)]);
xlabel('x');
ylabel('y');
saveas(gcf, 'result_monte_carlo.png');
hold off;
