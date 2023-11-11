% 定义生成白噪声的参数
num_samples = 1000; % 要生成的样本数
time_seq = 1000; % 要生成的白噪声变量数量
time_vector = 1:time_seq; % 生成时间序列
mu = 0; % 白噪声的均值
sigma = 1; % 白噪声的标准差

% 初始化一个数组来存储白噪声变量
white_noise_sequence = zeros(1, time_seq);

% 使用循环生成多个白噪声样本并存储在数组中
for i = 1:time_seq
    uniform_samples = rand(1, num_samples); % 生成均匀分布的随机数
    white_noise_sequence(i) = mu + sigma * ((sum(uniform_samples) - num_samples/2) / sqrt(num_samples/12));
end

% 绘制白噪声的时间序列
plot(time_vector, white_noise_sequence);

% 保存图片
saveas(gcf, 'white_noise_sequence.png');