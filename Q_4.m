k = 1:50;% Define an array 'k' representing the number of users
ratio = [1 2 4 8];% Define an array 'ratio' representing the M/K ratio (where M is a multiple of K)
beta = -10;
SNR = 0;
% Convert beta and SNR to linear scale
beta_lin = 10^(beta/10);
SNR_lin = 10^(SNR/10);

% Loop through different M/K ratios
for i = 1:length(ratio)
    SE_NLoS = zeros(1, length(k)); % Initialize an array to store SE values

    % Loop through different numbers of users 'k'
    for j = 1:length(k)
        % Calculate the total number of antennas 'M' based on the ratio
        M = k(j) * ratio(i);

        % Calculate the SE for NLoS communication
        x = (M - 1) / ((k(j) - 1) + (beta_lin * k(j)) + (1 / SNR_lin));
        SE_NLoS(j) = k(j) * log2(1 + x);
    end

    % Plot the SE values for the current M/K ratio
    plot(k, SE_NLoS, 'LineWidth', 1.5);
    hold on
end

% Set plot labels and title
xlabel('Number of User Equipments (K)', 'FontWeight', 'bold', 'FontSize', 10);
ylabel('Average Sum SE [bit/s/Hz/cell]', 'FontWeight', 'bold', 'FontSize', 10);
title('Plot for Average Uplink SE for NLoS Massive MIMO with K Users', 'FontWeight', 'bold', 'FontSize', 10);

legend('M/K=1', 'M/K=2', 'M/K=4', 'M/K=8', 'Location', 'best');
grid on
