% 定义LFSR的初始状态和反馈多项式
initial_state = [1, 0, 0, 0, 0, 0, 1, 1];
feedback_polynomial = [0, 0, 0, 1, 1, 1, 0, 1];

% 计算M序列的长度
sequence_length = 2^length(initial_state) - 1;

% 生成M序列
m_sequence = zeros(1, sequence_length);
for i = 1:sequence_length
    m_sequence(i) = initial_state(8);
    feedback = mod(sum(feedback_polynomial.*initial_state) , 2);
    initial_state = [feedback, initial_state(1:7)];
end

% M序列幅值归一化
for i = 1:sequence_length
    if m_sequence(i) == 0
        m_sequence(i) = 1;
    else
        m_sequence(i) = -1;
    end
end

% 绘制M序列
figure;
subplot(2, 2, 1);
plot(1:sequence_length, m_sequence);
xlabel('Time/s');
ylabel('Amplitude');
title('M Sequence');

% 生成输入信号
% 定义周期数
period = 5;
input = zeros(1, period * sequence_length);
for i = 1:5 * sequence_length
    input(i) = m_sequence(mod(i, sequence_length) + 1);
end
sequence_length = period * sequence_length;


% 定义传递函数
T1 = 8.3;
T2 = 6.2;
K = 120;
numerator = K;
denominator = [T1 * T2, T1 + T2, 1];

% 创建系统模型
sys = tf(numerator, denominator);

% 定义时间步长和时间向量
dt = 1;  % 时间步长
t = 0:dt:(sequence_length - 1) * dt;  % 时间向量

% 生成白噪声
noise = randn(1, sequence_length);  % 生成服从正态分布的白噪声
disp(size(noise));
subplot(2, 2, 2);
plot(t, noise);
xlabel('Time/s');
ylabel('Amplitude');
title('White Noise');

% 使用lsim函数模拟系统响应
output = lsim(sys, input, t);
subplot(2, 2, 3);
plot(t, output);
xlabel('Time/s');
ylabel('Output');
title('Output without Noise');

% 添加白噪声
output = output + noise.';

% 绘制输出信号
subplot(2, 2, 4);
plot(t, output);
xlabel('Time/s');
ylabel('Output');
title('Output with Noise');
hold off;

compensate = -Correlation(length(m_sequence)-1, input, output, length(m_sequence), period);

corr = zeros(1, length(m_sequence));
g_est = zeros(1, length(m_sequence));
g_the = zeros(1, length(m_sequence));
for i = 1:length(m_sequence)
    corr(i) = Correlation(i, input, output, length(m_sequence), period);
    g_est(i) = g_estimate(1, dt, length(m_sequence), compensate, corr(i));
    g_the(i) = g_theory(i-1, T1, T2, dt, K);
end

% 绘制脉冲响应函数估计值
figure;
plot(1:length(m_sequence), g_est, 1:length(m_sequence), g_the, 1:length(m_sequence), g_the-g_est);
xlabel('Time/s');
ylabel('Amplitude');
title('Impulse Response Function Estimate');

% 互相关函数
function output = Correlation(k, input1, input2, length, period) % k为延迟，input1为M序列，input2为输出信号，length为序列长度
    output = 0;
    denominator = period * length;
    for i = length+1:(period)*length
        output = output + input1(i-k) * input2(i);
    end 
    output = output * (1 / denominator);
end

% 脉冲响应函数估计值
function output = g_estimate(amplitude, delta_t, length, compensate, corr)
    output = length * (corr + compensate) / ((length + 1) * amplitude^2 * delta_t);
end 

% 脉冲响应函数理论值
function output = g_theory(k, T1, T2, delta_t, amplitude)
    output = amplitude*(1/(T1-T2)) * (exp(-k * delta_t / T1) - exp(-k * delta_t / T2));
end
