function rpslk_main()
% rpslk_main - Simulation of the Rock-Paper-Scissors-Lizard-Spock system using ode45
%
% Equations (when a = 1, the system reduces to):
%   dR/dt = R(-P + S + L - K)
%   dP/dt = P(R - S - L + K)
%   dS/dt = S(-R + P + L - K)
%   dL/dt = L(-R + P - S + K)
%   dK/dt = K(R - P + S - L)
%
% The function handle RPSLK below introduces an extra parameter a for flexibility.
%
% Initial conditions are set as:
%   R0 = 0.000, P0 = 0.150, S0 = 0.300, L0 = 0.550, K0 = 0.000
%
% The system is integrated over the time span [0, 200] using ode45.
% Values with an absolute value less than 1e-3 are rounded to zero.
%
% Plots are generated for the time evolution of each variable, and a 3D phase plot is created.
%
% Author: Sabneet Bains
% License: MIT License

    try
        %% Workspace Setup
        clear; close all; clc;
        
        %% Parameter and System Definition
        a = 1; % Extra parameter (set to 1 for standard system)
        
        % Define the RPSLK system with an extra term that vanishes when a = 1.
        RPSLK = @(t, p) [ p(1) * ((-p(2) + a*p(3) + a*p(4) - p(5)) - (a-1)*(p(1)*p(2) + p(1)*p(3) + p(1)*p(4) + p(1)*p(5) + p(2)*p(3) + p(2)*p(4) + p(2)*p(5) + p(3)*p(4) + p(3)*p(5) + p(4)*p(5)));
                         p(2) * ((a*p(1) - p(3) - p(4) + a*p(5)) - (a-1)*(p(1)*p(2) + p(1)*p(3) + p(1)*p(4) + p(1)*p(5) + p(2)*p(3) + p(2)*p(4) + p(2)*p(5) + p(3)*p(4) + p(3)*p(5) + p(4)*p(5)));
                         p(3) * ((-p(1) + a*p(2) + a*p(4) - p(5)) - (a-1)*(p(1)*p(2) + p(1)*p(3) + p(1)*p(4) + p(1)*p(5) + p(2)*p(3) + p(2)*p(4) + p(2)*p(5) + p(3)*p(4) + p(3)*p(5) + p(4)*p(5)));
                         p(4) * ((-p(1) + a*p(2) - p(3) + a*p(5)) - (a-1)*(p(1)*p(2) + p(1)*p(3) + p(1)*p(4) + p(1)*p(5) + p(2)*p(3) + p(2)*p(4) + p(2)*p(5) + p(3)*p(4) + p(3)*p(5) + p(4)*p(5)));
                         p(5) * ((a*p(1) - p(2) + a*p(3) - p(4)) - (a-1)*(p(1)*p(2) + p(1)*p(3) + p(1)*p(4) + p(1)*p(5) + p(2)*p(3) + p(2)*p(4) + p(2)*p(5) + p(3)*p(4) + p(3)*p(5) + p(4)*p(5))) ];
                     
        %% Initial Conditions
        R0 = 0.000;
        P0 = 0.150;
        S0 = 0.300;
        L0 = 0.550;
        K0 = 0.000;
        initialConditions = [R0; P0; S0; L0; K0];
        
        %% Integration using ode45
        tspan = [0, 200];
        [t, p] = ode45(RPSLK, tspan, initialConditions);
        
        %% Post-Processing: Set near-zero values to zero
        p(abs(p) < 1e-3) = 0;
        
        %% Plotting Results
        
        % Plot R(t)
        figure;
        plot(t, p(:,1), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('R(t)');
        title('Time Series of R(t)');
        
        % Plot P(t)
        figure;
        plot(t, p(:,2), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('P(t)');
        title('Time Series of P(t)');
        
        % Plot S(t)
        figure;
        plot(t, p(:,3), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('S(t)');
        title('Time Series of S(t)');
        
        % Plot L(t)
        figure;
        plot(t, p(:,4), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('L(t)');
        title('Time Series of L(t)');
        
        % Plot K(t)
        figure;
        plot(t, p(:,5), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('K(t)');
        title('Time Series of K(t)');
        
        % 3D Phase Plot: Plot R vs S vs K
        figure;
        plot3(p(:,3), p(:,4), p(:,5), 'LineWidth', 1.5);
        grid on;
        xlabel('R');
        ylabel('S');
        zlabel('K');
        title('3D Phase Plot: R vs S vs K');
        axis equal;
        
    catch ME
        fprintf('An error occurred: %s\n', ME.message);
    end
end

% Run the main function if this script is executed directly
if ~isdeployed
    rpslk_main();
end
