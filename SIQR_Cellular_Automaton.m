classdef SIQR_Cellular_Automaton < matlab.apps.AppBase
    % SIQR_Cellular_Automaton - COVID-19 SIQR 2D Cellular Automaton Simulation App
    %
    % This app simulates a COVID‑19 SIQR (Susceptible, Infected, Quarantined, Removed)
    % model on a 2D grid using a cellular automaton. The simulation parameters
    % (lockdown strength, recovery rate, and quarantine rate) can be adjusted via
    % interactive knobs.
    %
    % Enhancements for speed and efficiency include:
    %   - Vectorized update of infection using convolution (Moore neighborhood).
    %   - RNG is seeded once at startup.
    %   - The simulation runs first (storing states) and is then animated.
    %   - Preallocation of arrays to avoid dynamic memory allocation in loops.
    %
    % The model and parameter values are based on published SIQR model work.
    %
    % Author: Sabneet Bains
    % License: MIT License

    % Properties that correspond to app components
    properties (Access = public)
        COVID19SIQR2DCellularAutomatonUIFigure  matlab.ui.Figure
        RUNButton              matlab.ui.control.StateButton
        QuarantineRateLabel    matlab.ui.control.Label
        RecoveryRateLabel      matlab.ui.control.Label
        LockdownStrengthLabel  matlab.ui.control.Label
        q_Label                matlab.ui.control.Label
        q_control              matlab.ui.control.Knob
        gamma_Label            matlab.ui.control.Label
        gamma_control          matlab.ui.control.Knob
        alpha_Label            matlab.ui.control.Label
        alpha_control          matlab.ui.control.Knob
        UIAxes                 matlab.ui.control.UIAxes
    end

    methods (Access = private)
        %% Callback Functions for UI Components

        % Value changing function: alpha_control
        function alpha_controlValueChanging(app, event)
            % Update the lockdown strength label as the knob value changes.
            try
                val = round(event.Value, 2);
                app.alpha_Label.Text = num2str(val);
                drawnow();
            catch ME
                warning('Error in alpha_controlValueChanging: %s', ME.message);
            end
        end

        % Value changing function: gamma_control
        function gamma_controlValueChanging(app, event)
            % Update the recovery rate label as the knob value changes.
            try
                val = round(event.Value, 2);
                app.gamma_Label.Text = num2str(val);
                drawnow();
            catch ME
                warning('Error in gamma_controlValueChanging: %s', ME.message);
            end
        end

        % Value changing function: q_control
        function q_controlValueChanging(app, event)
            % Update the quarantine rate label as the knob value changes.
            try
                val = round(event.Value, 2);
                app.q_Label.Text = num2str(val);
                drawnow();
            catch ME
                warning('Error in q_controlValueChanging: %s', ME.message);
            end
        end

        % Value changed function: RUNButton
        function RUNButtonValueChanged(app, event)
            % Toggle RUN/RESET state and start the simulation.
            try
                if (app.RUNButton.Value == 0)
                    app.RUNButton.Text = 'RESET';
                    app.RUNButton.FontColor = [0.95, 0.76, 0.76];
                    app.RUNButton.BackgroundColor = [0.74, 0.04, 0.04];
                else
                    app.RUNButton.Text = 'START';
                    app.RUNButton.FontColor = [0.39, 0.83, 0.07];
                    app.RUNButton.BackgroundColor = [0.17, 0.17, 0.38];
                end
                drawnow();
                % Run the simulation with the current parameters.
                runSimulation(app);
            catch ME
                errordlg(['Error in RUNButtonValueChanged: ', ME.message], 'Error');
            end
        end

        %% Simulation Method with Performance Enhancements

        function runSimulation(app)
            % runSimulation - Executes the SIQR cellular automaton simulation.
            %
            % The simulation is vectorized using convolution to update infected neighbor
            % counts, RNG is seeded once, and the simulation is run first (storing states)
            % then animated after the simulation loop.
            try
                % Retrieve user-controlled parameters
                alpha_val = app.alpha_control.Value;  % Lockdown strength
                gamma_val = app.gamma_control.Value;    % Recovery rate
                q_val = app.q_control.Value;            % Quarantine rate

                % Simulation parameters
                N = 160;          % Grid size (NxN)
                beta0 = 0.4;      % Base transmission rate

                % Set UIAxes limits
                app.UIAxes.XLim = [1, N];
                app.UIAxes.YLim = [1, N];

                % Initialize grid: all cells susceptible (state 0)
                gridState = zeros(N, N, 'uint8');
                center = round(N/2);
                for i = 1:N
                    for j = 1:N
                        if sqrt((i - center)^2 + (j - center)^2) < 1
                            gridState(i, j) = 1;  % 1 indicates infected
                        end
                    end
                end

                % Preallocate storage for simulation states (store every 10 iterations)
                maxIter = 5000;
                frameInterval = 10;
                numFrames = ceil(maxIter / frameInterval) + 1;
                stateStore = zeros(N, N, numFrames, 'uint8');
                frameIdx = 1;
                stateStore(:, :, frameIdx) = gridState;

                % Define convolution kernel for Moore neighborhood (8 neighbors)
                kernel = ones(3,3);
                kernel(2,2) = 0;

                % Seed the RNG once
                rng('shuffle');

                % Run simulation loop
                for t = 1:maxIter
                    % Vectorized update: compute number of infected neighbors
                    infected = (gridState == 1);
                    neighborCount = conv2(double(infected), kernel, 'same');
                    
                    % Compute infection probability for susceptible cells
                    p = (1 - alpha_val) * beta0;
                    p_infect = 1 - (1 - p) .^ neighborCount;
                    randMat = rand(N, N);
                    newInfections = (gridState == 0) & (randMat < p_infect);
                    gridState(newInfections) = 1;
                    
                    % Update infected cells to quarantined with probability q_val
                    randMat = rand(N, N);
                    newQuarantines = (gridState == 1) & (randMat < q_val);
                    gridState(newQuarantines) = 2;
                    
                    % Update quarantined cells to removed with probability gamma_val
                    randMat = rand(N, N);
                    newRecoveries = (gridState == 2) & (randMat < gamma_val);
                    gridState(newRecoveries) = 3;
                    
                    % Store state every frameInterval iterations
                    if mod(t, frameInterval) == 0
                        frameIdx = frameIdx + 1;
                        stateStore(:,:,frameIdx) = gridState;
                    end
                    
                    % Early stopping if no infected (1) and no quarantined (2) remain
                    if all(gridState(:) ~= 1) && all(gridState(:) ~= 2)
                        break;
                    end
                    
                    % If RUNButton toggled (reset), exit simulation loop
                    if app.RUNButton.Value == 1
                        cla(app.UIAxes);
                        title(app.UIAxes, '\color[rgb]{0.17,0.17,0.38}Time iteration = 0');
                        drawnow();
                        return;
                    end
                end

                %% Animate Simulation Results
                for k = 1:frameIdx
                    cla(app.UIAxes);
                    imagesc(app.UIAxes, stateStore(:,:,k), [0 3]);
                    colormap(app.UIAxes, jet(4));
                    colorbar(app.UIAxes, 'Ticks', [0.38, 1.13, 1.88, 2.63], 'TickLabels',...
                        {'Susceptible','Infected','Quarantined','Removed'}, 'Direction', 'reverse');
                    title(app.UIAxes, strcat('\color[rgb]{0.17,0.17,0.38}Time iteration = ', int2str((k-1)*frameInterval)));
                    xlabel(app.UIAxes, 'X');
                    ylabel(app.UIAxes, 'Y');
                    axis(app.UIAxes, 'equal');
                    drawnow();
                    pause(0.05);
                end
            catch ME
                errordlg(['Simulation error: ', ME.message], 'Simulation Error');
            end
        end
    end

    %% Component Initialization
    methods (Access = private)
        function createComponents(app)
            % createComponents - Create UIFigure and UI components.
            %
            % This method creates the app's user interface, including the main figure,
            % UIAxes for simulation, knobs for adjusting parameters, labels, and the RUN button.
            
            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));
            
            % Create UIFigure and hide until components are created
            app.COVID19SIQR2DCellularAutomatonUIFigure = uifigure('Visible', 'off');
            app.COVID19SIQR2DCellularAutomatonUIFigure.Color = [1 1 1];
            app.COVID19SIQR2DCellularAutomatonUIFigure.Position = [700 400 800 560];
            app.COVID19SIQR2DCellularAutomatonUIFigure.Name = 'COVID-19: SIQR 2D Cellular Automaton';
            app.COVID19SIQR2DCellularAutomatonUIFigure.Icon = fullfile(pathToMLAPP, 'SARS-CoV-2.png');
            
            % Create UIAxes for simulation display
            app.UIAxes = uiaxes(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.UIAxes.Toolbar.Visible = 'off';
            app.UIAxes.XLim = [1 160];
            app.UIAxes.YLim = [1 160];
            app.UIAxes.XColor = [0.1686 0.1686 0.3804];
            app.UIAxes.YColor = [0.1686 0.1686 0.3804];
            app.UIAxes.ZColor = [0.1686 0.1686 0.3804];
            app.UIAxes.GridColor = [0.1686 0.1686 0.3804];
            app.UIAxes.MinorGridColor = [0.1686 0.1686 0.3804];
            app.UIAxes.Position = [244 88 500 426];
            
            % Create alpha_control knob for lockdown strength
            app.alpha_control = uiknob(app.COVID19SIQR2DCellularAutomatonUIFigure, 'continuous');
            app.alpha_control.Limits = [0 1];
            app.alpha_control.ValueChangingFcn = createCallbackFcn(app, @alpha_controlValueChanging, true);
            app.alpha_control.FontColor = [0.1686 0.1686 0.3804];
            app.alpha_control.Position = [81 426 57 57];
            app.alpha_control.Value = 0.7;
            
            % Create alpha_Label
            app.alpha_Label = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.alpha_Label.HorizontalAlignment = 'center';
            app.alpha_Label.FontWeight = 'bold';
            app.alpha_Label.FontColor = [0.502 0.502 0.502];
            app.alpha_Label.Position = [97 444 25 22];
            app.alpha_Label.Text = 'α';
            
            % Create gamma_control knob for recovery rate
            app.gamma_control = uiknob(app.COVID19SIQR2DCellularAutomatonUIFigure, 'continuous');
            app.gamma_control.Limits = [0 1];
            app.gamma_control.ValueChangingFcn = createCallbackFcn(app, @gamma_controlValueChanging, true);
            app.gamma_control.FontColor = [0.1686 0.1686 0.3804];
            app.gamma_control.Position = [82 285 57 57];
            app.gamma_control.Value = 0.06;
            
            % Create gamma_Label
            app.gamma_Label = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.gamma_Label.HorizontalAlignment = 'center';
            app.gamma_Label.FontWeight = 'bold';
            app.gamma_Label.FontColor = [0.502 0.502 0.502];
            app.gamma_Label.Position = [98 303 25 22];
            app.gamma_Label.Text = 'ɣ';
            
            % Create q_control knob for quarantine rate
            app.q_control = uiknob(app.COVID19SIQR2DCellularAutomatonUIFigure, 'continuous');
            app.q_control.Limits = [0 1];
            app.q_control.ValueChangingFcn = createCallbackFcn(app, @q_controlValueChanging, true);
            app.q_control.FontColor = [0.1686 0.1686 0.3804];
            app.q_control.Position = [83 144 57 57];
            app.q_control.Value = 0.1;
            
            % Create q_Label
            app.q_Label = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.q_Label.HorizontalAlignment = 'center';
            app.q_Label.FontWeight = 'bold';
            app.q_Label.FontColor = [0.502 0.502 0.502];
            app.q_Label.Position = [99 162 25 22];
            app.q_Label.Text = 'q';
            
            % Create LockdownStrengthLabel
            app.LockdownStrengthLabel = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.LockdownStrengthLabel.HorizontalAlignment = 'center';
            app.LockdownStrengthLabel.FontColor = [0.1686 0.1686 0.3804];
            app.LockdownStrengthLabel.Position = [55 385 107 22];
            app.LockdownStrengthLabel.Text = 'Lockdown Strength';
            
            % Create RecoveryRateLabel
            app.RecoveryRateLabel = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.RecoveryRateLabel.HorizontalAlignment = 'center';
            app.RecoveryRateLabel.FontColor = [0.1686 0.1686 0.3804];
            app.RecoveryRateLabel.Position = [65 244 91 22];
            app.RecoveryRateLabel.Text = 'Recovery Rate';
            
            % Create QuarantineRateLabel
            app.QuarantineRateLabel = uilabel(app.COVID19SIQR2DCellularAutomatonUIFigure);
            app.QuarantineRateLabel.HorizontalAlignment = 'center';
            app.QuarantineRateLabel.FontColor = [0.1686 0.1686 0.3804];
            app.QuarantineRateLabel.Position = [63 103 94 22];
            app.QuarantineRateLabel.Text = 'Quarantine Rate';
            
            % Create RUNButton to control simulation
            app.RUNButton = uibutton(app.COVID19SIQR2DCellularAutomatonUIFigure, 'state');
            app.RUNButton.ValueChangedFcn = createCallbackFcn(app, @RUNButtonValueChanged, true);
            app.RUNButton.Text = 'RUN';
            app.RUNButton.BackgroundColor = [0.1686 0.1686 0.3804];
            app.RUNButton.FontWeight = 'bold';
            app.RUNButton.FontColor = [0.3882 0.8314 0.0706];
            app.RUNButton.Position = [71 31 80 40];
            app.RUNButton.Value = true;
            
            % Show the figure after all components are created
            app.COVID19SIQR2DCellularAutomatonUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)
        % Construct app
        function app = SIQR_Cellular_Automaton
            % Create UIFigure and components
            createComponents(app)
            % Register the app with App Designer
            registerApp(app, app.COVID19SIQR2DCellularAutomatonUIFigure)
            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.COVID19SIQR2DCellularAutomatonUIFigure)
        end
    end
end
