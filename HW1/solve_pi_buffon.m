% 解法一，布丰投针法
% 设置参数
numThrows = 10000000; % 投针次数
L = 1; % 棍子长度
D = 1; % 平行线距离

% 投针
x = rand(1, numThrows) * D / 2; % 棍子中点到平行线的最短距离
theta = rand(1, numThrows) * pi / 2; % 棍子与平行线的夹角（锐角）

% 计算相交次数
numIntersect = sum(x <= (L / 2) * sin(theta));

% 计算pi的估计值
piEstimate = 2 * L * numThrows / (numIntersect * D);

% 输出结果
fprintf('圆周率pi的估计值为 %f\n', piEstimate);

% 可视化
figure;
hold on;
% 绘制平行线
for i = 0:D:10
    line([0 10], [i i], 'Color', 'b', 'LineWidth', 1);
end
% 绘制棍子
x_center = rand(1, numThrows) * 10;
k = randi([0, 1], [1, numThrows]) .* 2 - 1;
y_center = randi([0, 9], [1, numThrows]) + k .* x;
x1 = x_center - (L / 2) * cos(theta);
x2 = x_center + (L / 2) * cos(theta);
y1 = y_center + (L / 2) * sin(theta);
y2 = y_center - (L / 2) * sin(theta);
for i = 1:10000:numThrows
    line([x1(i) x2(i)], [y1(i) y2(i)], 'Color', 'r', 'LineWidth', 1);
end
title(['pi的估计值为: ' num2str(piEstimate)]);
% 保存图片
saveas(gcf, 'result_buffon.png');
hold off;
