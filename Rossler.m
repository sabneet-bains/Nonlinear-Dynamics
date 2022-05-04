% Defining equations of the Rössler system:
%   dx/dt = -y - z
%   dy/dt = x + ay
%   dz/dt = b + z(x - c)

% Setting constant parameters:
a = 0.2;
b = a;
c = 6.3;

% Intializing the Rössler system:
% where, p(1) = x; p(2) = y; p(3) = z
rossler = @(t,p) [-(p(2) + p(3)); p(1) + a*p(2); b + p(1)*p(3) - c*p(3)];

% Creating random initial conditions:
rng('shuffle')
x0 = randsample((10).*rand(1000,1),1);
y0 = randsample((10).*rand(1000,1),1);
z0 = randsample((10).*rand(1000,1),1);

% Integration using ode45:
[t,p] = ode45(rossler, [0 500], [x0; y0; z0]);

% Removing transients:
p = p(5000:end,:);
t = t(5000:end,:);

% Plotting t vs x(t):
figure(1)
plot(t, p(:,1))
grid
xlabel('t')
ylabel('x(t)')

% Plotting x vs y:
figure(2)
plot(p(:,1), p(:,2))
grid
xlabel('x')
ylabel('y')
axis equal