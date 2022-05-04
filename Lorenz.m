% Defining equations of the Rössler system:
%   dx/dt = σ(y - x)
%   dy/dt = x(ρ - z) - y
%   dz/dt = xy - βz

% Setting constant parameters:
sigma = 10;
beta = 8/3;
rho = 22;

% Intializing the Lorenz system:
% where, p(1) = x; p(2) = y; p(3) = z
lorenz = @(t,p) [-sigma*p(1) + sigma*p(2); rho*p(1) - p(2) - p(1)*p(3); -beta*p(3) + p(1)*p(2)];

% Creating random initial conditions:
rng('shuffle')
x0 = randsample((10).*rand(1000,1),1);
y0 = randsample((10).*rand(1000,1),1);
z0 = randsample((10).*rand(1000,1),1);

% Integration using ode45:
[t,p] = ode45(lorenz, [0 10], [x0; y0; z0]);

% Removing transients:
p = p(50:end,:);
t = t(50:end,:);

% Plotting t vs x(t):
figure(1)
plot(t, p(:,1))
grid
xlabel('t')
ylabel('x(t)')

% Plotting t vs y(t):
figure(2)
plot(t, p(:,2))
grid
xlabel('t')
ylabel('y(t)')

% Plotting x vs z:
figure(3)
plot(p(:,1), p(:,3))
grid
xlabel('x')
ylabel('z')
axis equal
