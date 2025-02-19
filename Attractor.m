function attractor_main()
% attractor_main - Simulation of a one-parameter attractor system using ode45
%
% Equations of the system:
%   dx/dt = -α * x + sin(y)
%   dy/dt = -α * y + sin(z)
%   dz/dt = -α * z + sin(x)
%
% This function simulates a nonlinear attractor system and plots the time series
% for x(t) and y(t), as well as a phase plot of x versus z after removing transient dynamics.
%
% Author: Sabneet Bains
% Date: [Current Date]
% License: MIT License

    try
        %% Parameters
        alpha = 0.30;  % Constant parameter

        %% Define the Attractor System
        % p(1)=x, p(2)=y, p(3)=z
        attractor = @(t, p) [-alpha * p(1) + sin(p(2));
                             -alpha * p(2) + sin(p(3));
                             -alpha * p(3) + sin(p(1))];

        %% Generate Random Initial Conditions
        % Generate initial conditions in the interval [0, 10]
        rng('shuffle');
        x0 = 10 * rand;
        y0 = 10 * rand;
        z0 = 10 * rand;
        initialConditions = [x0; y0; z0];

        %% Numerical Integration with ode45
        tspan = [0 1000];
        [t, p] = ode45(attractor, tspan, initialConditions);

        %% Remove Transient Dynamics
        % Define the transient removal index. If the data length is shorter than expected,
        % use the full data.
        transientIndex = min(2000, length(t));
        t_trim = t(transientIndex:end);
        p_trim = p(transientIndex:end, :);

        %% Plotting Results
        figure;
        subplot(3, 1, 1);
        plot(t_trim, p_trim(:, 1), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('x(t)');
        title('Time Series of x(t)');

        subplot(3, 1, 2);
        plot(t_trim, p_trim(:, 2), 'LineWidth', 1.5);
        grid on;
        xlabel('Time t');
        ylabel('y(t)');
        title('Time Series of y(t)');

        subplot(3, 1, 3);
        plot(p_trim(:, 1), p_trim(:, 3), 'LineWidth', 1.5);
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
    attractor_main();
end
