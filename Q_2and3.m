% Define the range of the number of antennas 'M'
M = 10:1:100;

% Set the value of the path loss exponent (beta) in dB
beta = -10;

% Convert beta to linear scale
beta_bar = 10^(beta/10);

% Specify the number of channel realizations
num_data_points = 50000;

% Initialize arrays to store the results
[beta_1, beta_0] = numden(sym(beta_bar));
norm_h_0 = zeros(length(M), num_data_points);
abs_value = zeros(length(M), num_data_points);
SE_NLoS = zeros(length(M), num_data_points);

% Simulate NLoS channel for different numbers of antennas 'M'
for i = 1:length(M)
    % Generate random complex-valued channel coefficients h_0 and h_1
    h_0 = ((sqrt(double(beta_0)) .* (randn(M(i), num_data_points) + 1i * randn(M(i), num_data_points))) / sqrt(2));
    h_1 = ((sqrt(double(beta_1)) .* (randn(M(i), num_data_points) + 1i * randn(M(i), num_data_points))) / sqrt(2));

    % Compute and store the SE for NLoS
    for j = 1:num_data_points
        norm_h_0(i, j) = h_0(:, j)' * h_0(:, j);
        abs_value(i, j) = abs(h_0(:, j)' * h_1(:, j)) * abs(h_0(:, j)' * h_1(:, j));
        SE_NLoS(i, j) = log2(1 + (norm_h_0(i, j) / (10 + (abs_value(i, j) / norm_h_0(i, j)))));
    end
end

% Compute the average SE over all realizations
avg_SE_NLoS = mean(SE_NLoS, 2);

% Define additional parameters for LoS simulations
dH = 1/2;
SNR = 0;
beta_lin = 10^(beta/10);
SNR_lin = 10^(SNR/10);

% Initialize variables for LoS simulations
lower_bound = 0;
upper_bound = 360;
num_data_points = 20000;

% Initialize arrays to store LoS SE results
avg_SE_LoS = zeros(1, length(M));
SE_NLoS = zeros(1, length(M));

% Simulate LoS and compute SE for different numbers of antennas 'M'
for i = 1:length(M)
    phi_0 = zeros(1, num_data_points);
    phi_1 = zeros(1, num_data_points);
    g = zeros(1, num_data_points);
    SE_LoS = zeros(1, num_data_points);
    
    for j = 1:num_data_points
        % Generate random angles for the LoS channel
        phi_0(j) = lower_bound + (upper_bound - lower_bound) * rand(1, 1);
        phi_1(j) = lower_bound + (upper_bound - lower_bound) * rand(1, 1);
        
        % Compute g based on angles
        if phi_1(j) == phi_0(j) || phi_1(j) == 180 - phi_0(j)
            g(j) = M(i);
        else
            theta = sind(phi_1(j)) - sind(phi_0(j));
            y = sind(180 * dH * M(i) * theta) / sind(180 * dH * theta);
            g(j) = (y * y) / M(i);
        end
        
        % Compute SE for LoS
        p = M(i) / ((beta_lin * g(j)) + (1 / SNR_lin));
        SE_LoS(j) = log2(1 + p);
    end
    
    % Calculate the average SE for LoS and NLoS
    avg_SE_LoS(i) = mean(SE_LoS);
    x = (M(i) - 1) / (beta_lin + (1 / SNR_lin));
    SE_NLoS(i) = log2(1 + x);
end

% Plot the average SE for LoS, average SE for NLoS, and NLoS SE
plot(M, avg_SE_LoS, 'r-', M, avg_SE_NLoS, 'b--', M, SE_NLoS, 'g--');

% Set plot labels and legend
xlabel('Number of Antennas [M]', 'fontweight', 'bold');
ylabel('Average Sum SE [bit/s/Hz/cell]', 'FontWeight', 'bold');
legend('LoS','NLoS','NLos(lower bound)',Location='best');
title('SE variation with number of antennas', 'fontweight','bold', 'fontsize', 10);
grid on
