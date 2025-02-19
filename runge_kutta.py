"""
Implementation of the classic fourth-order Runge-Kutta method for solving ODEs.

The differential equation is given by:
    dx/dt = f(t, x)
For this example:
    f(t, x) = (3/10) * (1 / cos(x/6))

The RK4 method approximates the solution at t_end starting from initial conditions (t0, x0)
with a fixed time step dt.

Author: Sabneet Bains
License: MIT License
"""

import numpy as np
import logging
from typing import Callable

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

def f(t: float, x: float) -> float:
    """
    Differential equation: dx/dt = f(t, x)

    Parameters:
        t (float): Time variable.
        x (float): State variable.

    Returns:
        float: The derivative dx/dt.
    """
    try:
        # Compute the derivative using the provided formula.
        result = (3 / 10) * (1 / np.cos(x / 6))
    except Exception as e:
        logging.error("Error in function f(t, x): %s", e)
        raise
    return result

def RK4(t0: float, x0: float, t_end: float, dt: float, f_func: Callable[[float, float], float]) -> float:
    """
    Solve an ODE using the classical fourth-order Runge-Kutta method.

    Parameters:
        t0 (float): Initial time.
        x0 (float): Initial condition for x.
        t_end (float): End time for the integration.
        dt (float): Time step (must be positive).
        f_func (Callable[[float, float], float]): Function f(t, x) representing the derivative.

    Returns:
        float: Approximation of x at time t_end.
    """
    # Input validation
    if dt <= 0:
        raise ValueError("Time step dt must be positive.")
    if t_end <= t0:
        raise ValueError("t_end must be greater than t0.")
    
    tn = t0
    xn = x0
    n_steps = int((t_end - t0) / dt)
    
    for i in range(n_steps):
        k1 = f_func(tn, xn)
        k2 = f_func(tn + 0.5 * dt, xn + 0.5 * dt * k1)
        k3 = f_func(tn + 0.5 * dt, xn + 0.5 * dt * k2)
        k4 = f_func(tn + dt, xn + dt * k3)
        
        # Update state and time using the RK4 formula
        xn += (dt / 6) * (k1 + 2 * k2 + 2 * k3 + k4)
        tn += dt
    
    return xn

def main() -> None:
    """
    Main driver function to run the RK4 simulation.
    """
    try:
        t0 = 0.0      # Initial time
        x0 = 0.0      # Initial condition
        t_end = 10.0  # End time for integration
        dt = 1 / 100000  # Time step
        
        logging.info("Starting RK4 integration with t0=%.3f, x0=%.3f, t_end=%.3f, dt=%.8f", t0, x0, t_end, dt)
        result = RK4(t0, x0, t_end, dt, f)
        logging.info("Integration complete.")
        print("x(" + str(t_end) + ") ≈", result)
    except Exception as e:
        logging.error("An error occurred in main: %s", e)

if __name__ == '__main__':
    main()
