% Constants
a1 = 1.5;
a2 = -0.7;
b1 = 1;
b2 = 0.5;

% White Noise
sigma_v = 0.01;

% Input
N = 100;
ms = mseq();
u = ms(1:N);

% Output
x = zeros(1, N);
z = zeros(1, N);
v = sigma_v * randn(1, N); % Gaussian noise

for k = 3:N
    x(k) = a1 * x(k-1) + a2 * x(k-2) + b1 * u(k-1) + b2 * u(k-2);
    z(k) = x(k) + v(k);
end

% Recursive Least Squares
P = eye(4); % Covariance matrix
theta = zeros(4, 1); % Parameter vector

lambda = 0.98; % Forgetting factor

for k = 3:N
    Phi = [x(k-1), x(k-2), u(k-1), u(k-2)]'; % Regressor vector
    K = (P * Phi) / (lambda + Phi' * P * Phi);
    theta = theta + K * (z(k) - Phi' * theta);
    P = (P - K * Phi' * P) / lambda;
end

% Results
a1_identified = theta(1);
a2_identified = theta(2);
b1_identified = theta(3);
b2_identified = theta(4);

disp(['Identified a1: ', num2str(a1_identified)]);
disp(['Identified a2: ', num2str(a2_identified)]);
disp(['Identified b1: ', num2str(b1_identified)]);
disp(['Identified b2: ', num2str(b2_identified)]);

% Z Identification
z_identified = zeros(1, N);
for k = 3:N
    z_identified(k) = a1_identified * z_identified(k-1) + a2_identified * z_identified(k-2) + b1_identified * u(k-1) + b2_identified * u(k-2);
end

% Plot
subplot(2, 2, 1);
plot(u);
title('M Sequence Input');
subplot(2, 2, 2);
plot(x);
title('Output without Noise');
subplot(2, 2, 3);
plot(z);
title('Output with Noise');
subplot(2, 2, 4);
plot(z_identified);
title('Identified Output');

