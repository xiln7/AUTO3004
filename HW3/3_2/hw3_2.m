% input
u = [2.1 -2.7 0.8 1.5 -2.1];
y = [0.3 0.5 -0.2 0.6 0.83];
% matrix X and Y
X = [-y(1:end-1)', u(2:end)', u(1:end-1)'];
Y = y(2:end)';
% least square
B = inv(X'*X)*X'*Y;
a1 = B(1);
b0 = B(2);
b1 = B(3);
disp(['a1 = ', num2str(a1)])
disp(['b0 = ', num2str(b0)])
disp(['b1 = ', num2str(b1)])