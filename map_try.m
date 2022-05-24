clear all
x = [];
y = [];

for lambda = 1.5:0.001:4
    x0 = 0.5;
    xn(1) = x0 * exp(lambda*(1 - x0));
    yn(1) = lambda;
    for i = 1:512
        xn(end+1) = xn(i) * exp(lambda*(1 - xn(i)));
        yn(end+1) = lambda;
    end
    xn = xn(256:end);
    yn = yn(256:end);

    x = vertcat(x,xn);
    y = vertcat(y,yn);
    clear xn
    clear yn
end

% Plotting λ vs xₙ:
figure(1)
plot(y, x)
xlabel('λ')
ylabel('xₙ')