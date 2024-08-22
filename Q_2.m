dH = 1/2; % Half-wavelength spacing between antennas
beta = -10; % Path loss exponent in dB
SNR = 0; % Signal-to-Noise Ratio in dB

% Convert path loss exponent and SNR to linear scale
beta_lin = 10^(beta/10);
SNR_lin = 10^(SNR/10);

% Define a range of the number of antennas 'M'
M = 10:1:100;

% Define the bounds for randomly generating angles
lower_bound = 0;
upper_bound = 360;

% Specify the number of data points for the simulation
num_data_points = 20000;

% Initialize arrays to store results
avg_SE_LoS = zeros(1, length(M)); 
SE_NLoS = zeros(1, length(M));    

% Simulate and calculate SE for different numbers of antennas 'M'
for i = 1:length(M)
    
    phi_0 = zeros(1, num_data_points); 
    phi_1 = zeros(1, num_data_points); 
    g = zeros(1, num_data_points);    
    SE_LoS = zeros(1, num_data_points);
    
    for j = 1:num_data_points
        % Generate random angles for users
        phi_0(j) = lower_bound + (upper_bound - lower_bound) * rand(1, 1);
        phi_1(j) = lower_bound + (upper_bound - lower_bound) * rand(1, 1);
        
        % Calculate channel gain 'g' based on angles
        if phi_1(j) == phi_0(j) || phi_1(j) == 180 - phi_0(j)
            g(j) = M(i);
        else
            theta = sind(phi_1(j)) - sind(phi_0(j));
            y = sind(180 * dH * M(i) * theta) / sind(180 * dH * theta);
            g(j) = (y * y) / M(i);
        end
        
        % Calculate the SE for LoS channel
        p = M(i) / ((beta_lin * g(j)) + (1 / SNR_lin));
        SE_LoS(j) = log2(1 + p);
    end
    
    % Compute the average SE for LoS and the SE for NLoS
    avg_SE_LoS(i) = mean(SE_LoS);
    x = (M(i) - 1) / (beta_lin + (1 / SNR_lin));
    SE_NLoS(i) = log2(1 + x);
end

% Plot the average SE for LoS and SE for NLoS with respect to 'M'
plot(M, avg_SE_LoS, 'r-', M, SE_NLoS, 'g--');

% Set the legend for the plot
legend({'SE^{LoS}_0', 'SE^{NLoS}_0'}, 'Location', 'best');

% Set the plot labels and title
xlabel('Number of Antennas [M]', 'FontWeight', 'bold');
ylabel('Average Sum SE [bit/s/Hz/cell]', 'FontWeight', 'bold');
title('SE Variation with Number of Antennas', 'FontWeight', 'bold', 'FontSize', 10);

% Automatically adjust the y-axis limits
ylim tight;

% Enable the grid on the plot
grid on
