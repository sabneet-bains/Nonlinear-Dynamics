function lorenz_main()
% lorenz_main - Simulation of the Lorenz System using ode45
%
% Equations of the Lorenz system:
%   dx/dt = sigma*(y - x)
%   dy/dt = x*(rho - z) - y
%   dz/dt = x*y - beta*z
%
% Standard parameter values used:
%   sigma = 10, beta = 8/3, rho = 22
%
% This function generates random initial conditions (in the interval [0,10]),
% integrates the Lorenz system over the time span [0, 10], removes the first 50
% data points as transient behavior, and produces the following plots:
%   - Time series of x(t)
%   - Time series of y(t)
%   - Phase plot of x versus z
%
% Author: Sabneet Bains
% License: MIT License

    try
        %% Workspace Cleanup
        clear; close all; clc;
        
        %% Parameters
        sigma = 10;
        beta = 8/3;
        rho = 22;
        
        %% Define the Lorenz System
        % p(1)=x, p(2)=y, p(3)=z
        lorenz = @(t, p) [ sigma*(p(2)-p(1));
                           p(1)*(rho - p(3)) - p(2);
                           p(1)*p(2) - beta*p(3) ];
                       
        %% Generate Random Initial Conditions
        % Random initial conditions in the interval [0, 10]
        rng('shuffle');
        x0 = 10 * rand;
        y0 = 10 * rand;
        z0 = 10 * rand;
        initialConditions = [x0; y0; z0];
        
        %% Numerical Integration using ode45
        tspan = [0, 10];
        [t, p] = ode45(lorenz, tspan, initialConditions);
        
        %% Remove Transient Dynamics
        % Remove the first 50 data points if available
        if length(t) > 50
            t_trim = t(50:end);
            p_trim = p(50:end, :);
        else
            t_trim = t;
            p_trim = p;
        end
        
        %% Plotting Results
        
        % Plot x(t)
        figure;
        plot(t_trim, p_trim(:,1), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('x(t)');
        title('Time Series of x(t)');
        
        % Plot y(t)
        figure;
        plot(t_trim, p_trim(:,2), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('y(t)');
        title('Time Series of y(t)');
        
        % Plot phase plot: x vs. z
        figure;
        plot(p_trim(:,1), p_trim(:,3), 'LineWidth', 1.5);
        grid on;
        xlabel('x');
        ylabel('z');
        title('Phase Plot: x vs. z');
        axis equal;
        
    catch ME
        fprintf('An error occurred: %s\n', ME.message);
    end
end

% Run the main function if the script is executed directly
if ~isdeployed
    lorenz_main();
end
