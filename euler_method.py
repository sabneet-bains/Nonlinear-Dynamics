"""
Implementation of the classic Euler method for solving ordinary differential equations.

The differential equation is defined as:
    dx/dt = f(t, x)
For this example, we use:
    f(t, x) = (3/10) * (1 / cos(x/6))

Author: Sabneet Bains
License: MIT License
"""

import numpy as np
import logging
from typing import Callable

# Setup basic logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

def f(t: float, x: float) -> float:
    """
    Differential equation: dx/dt = f(t, x).

    Parameters:
        t (float): Time variable.
        x (float): State variable.

    Returns:
        float: The derivative dx/dt.
    """
    try:
        result = (3/10) * (1 / np.cos(x/6))
    except Exception as e:
        logging.error("Error computing f(t, x): %s", e)
        raise
    return result

def euler(t0: float, x0: float, t_end: float, dt: float, 
          f_func: Callable[[float, float], float]) -> float:
    """
    Solve an ODE using the Euler method.

    Parameters:
        t0 (float): Initial time.
        x0 (float): Initial condition for x.
        t_end (float): End time.
        dt (float): Time step.
        f_func (Callable[[float, float], float]): Function f(t, x) defining dx/dt.

    Returns:
        float: Approximation of x at time t_end.
    """
    # Input validation
    if dt <= 0:
        raise ValueError("Time step dt must be positive.")
    if t_end <= t0:
        raise ValueError("End time t_end must be greater than initial time t0.")

    tn = t0
    xn = x0

    while tn < t_end:
        xn = xn + dt * f_func(tn, xn)
        tn += dt

    return xn

def main() -> None:
    try:
        # Set initial conditions and parameters
        t0 = 0.0
        x0 = 0.0
        t_end = 10.0
        dt = 1 / 100000  # Time step

        logging.info("Starting Euler method simulation: t0=%f, x0=%f, t_end=%f, dt=%f", t0, x0, t_end, dt)
        x_final = euler(t0, x0, t_end, dt, f)
        logging.info("Simulation complete.")
        print("x(" + str(t_end) + ") ≈", x_final)
    except Exception as e:
        logging.error("An error occurred in main: %s", e)

if __name__ == '__main__':
    main()
