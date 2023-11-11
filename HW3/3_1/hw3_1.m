% Step Response With Noise
sys = tf(1,[6 12 3 1]);
[y, t] = step(sys);
sigma = 0.00001; % variance sigma
y_noise = y + sigma * randn(size(y));

% M
dt = t(2) - t(1); % step size
M = zeros(1, 3);
for i = 1:3
    for j = 1:length(t)
        M(i) = M(i) + (1 - y_noise(j)) * ((-t(j))^(i-1) / factorial(i-1)) * dt;
    end
end

% Area of different orders
A_1 = M(1);
A_2 = M(2) + A_1 * M(1);
A_3 = M(3) + A_1 * M(2) + A_2 * M(1);

% Estimate Parameters 
a_1 = 1 + A_1;
a_2 = A_2 + A_1 + 1;
a_3 = A_3 + A_2 + A_1 + 1;

sys_estimate = tf(1, [a_3 a_2 a_1 1]);
disp('Estimated Parameters');
disp(sys_estimate);
[y_est, t_est] = step(sys_estimate, t(end));
plot(t, y_noise, t_est, y_est);