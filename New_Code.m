clc; clear; close all;


t = 0: 0.01:100;% time span
dt = 0.01;
N = length(t);

%constant parameters
V_ref = 1.0; % pu
omega_ref = 1.0; %pu
C_eq = 5; % equivalent capacitance
lambda = 3; % voltage regulation damping coefficient
Kf_solar = 5; % frequency gain of solar
Kf_wind = 4; % frequency gain of wind
Kf_hydro = 3;% frequency gain of hydro

% Source control parameters
alpha_solar = 0.2; % ramp up rate solar
beta_solar = 0.3;% ramp down rates for solar
alpha_wind = 0.15; %ramp up rate wind
beta_wind = 0.2;% ramp down rates for wind
alpha_hydro = 0.4;% ramp up rate hydro
beta_hydro = 0.4;% ramp down rates for hydro

% Initial conditions
V = ones(1, N); 
omega = omega_ref * ones(1, N); 
theta = zeros(1, N);
G_solar = zeros(1, N); 
G_wind = zeros(1, N); 
G_hydro = zeros(1, N);
G_solar(1) = 0.4; % conductance of solar
G_wind(1) = 0.2; % conductance of wind
G_hydro(1) = 0.3;% conductance of hydro


P_load= 0.7 * ones(1, N);  % sudden changes in the load
P_total_gen = zeros(1, N);

% Load Scenarios
P_load(t >= 3 & t < 6) = 0.35;% load drop between t=3 and t=6
P_load(t >= 6 & t < 8) = 1.05; % load spiking up at t=6 till balance at t=8

% Function for frequency deviation response
freq_feedback = @(domega, Kf) 1 + Kf * abs(domega);

% Euler method
for i = 1:N-1
    % power generated from each source
    P_solar = G_solar(i) * V(i);
    P_wind = G_wind(i) * V(i);
    P_hydro = G_hydro(i) * V(i);
    P_total_gen(i) = P_solar + P_wind + P_hydro;

    % Frequency deviation
    delta_omega = omega(i) - omega_ref;

    % Source activations
    dG_solar_dt = alpha_solar * (1 - G_solar(i)) * freq_feedback(delta_omega, Kf_solar) - beta_solar * G_solar(i);
    dG_wind_dt  = alpha_wind  * (1 - G_wind(i))  * freq_feedback(delta_omega, Kf_wind)  - beta_wind * G_wind(i);
    dG_hydro_dt = alpha_hydro * (1 - G_hydro(i)) * freq_feedback(delta_omega, Kf_hydro) - beta_hydro * G_hydro(i);

    % Euler integration
    G_solar(i+1) = max(0, min(1, G_solar(i) + dt * dG_solar_dt));
    G_wind(i+1)  = max(0, min(1, G_wind(i)  + dt * dG_wind_dt));
    G_hydro(i+1) = max(0, min(1, G_hydro(i) + dt * dG_hydro_dt));

    % Voltage regulation
    dV_dt = (1 / C_eq) * ((P_total_gen(i)/V(i)) - (P_load(i)/V(i))) - lambda * (V(i) - V_ref);
    V(i+1) = max(0.8, min(1.2, V(i) + dt * dV_dt));

    % Update theta and omega
    omega(i+1) = omega_ref + 0.1 * (P_total_gen(i) - P_load(i));
    theta(i+1) = theta(i) + dt * omega(i);
end

% Final power generation value
P_total_gen(end) = G_solar(end)*V(end) + G_wind(end)*V(end) + G_hydro(end)*V(end);

% Plotting the graphs
% graph of grid voltage
figure;
plot(t, V, 'b', 'LineWidth', 2); 
hold on;
plot(t, V_ref * ones(size(t)), 'r--');
title('Grid Voltage');
xlabel('t');
ylabel('Voltage (p.u.)');
ylim([0.8 1.25]);
legend('V','V_ref');
grid on;

% graph of power contributions from the three sources
figure;
plot(t, G_solar, 'y', t, G_wind, 'c', t, G_hydro, 'g', 'LineWidth', 2);
title('Source Contributions to Power'); 
legend('Solar', 'Wind', 'Hydro'); grid on;

% graph to show power balance between the supply and demand
figure;
plot(t, P_total_gen, 'b', t, P_load, 'r', 'LineWidth', 2);
title('Power Generated vs Demand');
xlabel('Time (s)'); 
ylabel('Power (p.u.)');
legend('Generated', 'Load'); 
grid on;
