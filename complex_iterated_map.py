"""
Implementation of a complex-valued iterated map.

This script defines a function to iterate the map:
   xₙ₊₁ = π + 1/2 * (xₙ * cos(xₙ² + yₙ²) - yₙ * sin(xₙ² + yₙ²))
   yₙ₊₁ = 1/2 * (xₙ * sin(xₙ² + yₙ²) + yₙ * cos(xₙ² + yₙ²))
for a specified number of iterations, starting from given initial conditions.
The first 100 iterations are discarded to remove transient dynamics, and the final
results are plotted as a scatter plot in the complex plane.

Author: Sabneet Bains
License: MIT License
"""

import random
import numpy as np
import matplotlib.pyplot as plt
import logging
from typing import Tuple

# Setup basic logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

def complex_iterated_map(x0: float, y0: float, n: int) -> Tuple[np.ndarray, np.ndarray]:
    """
    Compute the complex-valued iterated map.
    
    Parameters:
        x0 (float): Initial x-value.
        y0 (float): Initial y-value.
        n (int): Number of iterations to perform.
        
    Returns:
        Tuple[np.ndarray, np.ndarray]: Arrays of x and y coordinates after discarding the first 100 iterations.
    """
    # Validate input types
    if not isinstance(x0, (int, float)) or not isinstance(y0, (int, float)):
        raise ValueError("Initial conditions x0 and y0 must be numeric.")
    if not isinstance(n, int) or n < 0:
        raise ValueError("Number of iterations n must be a non-negative integer.")

    # Pre-allocate arrays for performance
    xn = np.empty(n + 1)
    yn = np.empty(n + 1)
    
    # Initial iteration: compute first values from x0, y0
    xn[0] = np.pi + 0.5 * (x0 * np.cos(x0**2 + y0**2) - y0 * np.sin(x0**2 + y0**2))
    yn[0] = 0.5 * (x0 * np.sin(x0**2 + y0**2) + y0 * np.cos(x0**2 + y0**2))
    
    # Iterate the map
    for i in range(n):
        xn[i+1] = np.pi + 0.5 * (xn[i] * np.cos(xn[i]**2 + yn[i]**2) - yn[i] * np.sin(xn[i]**2 + yn[i]**2))
        yn[i+1] = 0.5 * (xn[i] * np.sin(xn[i]**2 + yn[i]**2) + yn[i] * np.cos(xn[i]**2 + yn[i]**2))
    
    # Remove transient dynamics (first 100 iterations)
    if n < 100:
        logging.warning("Number of iterations is less than 100; no transient removal performed.")
        return xn, yn
    else:
        return xn[100:], yn[100:]

def main() -> None:
    try:
        # Example initial conditions and number of iterations
        x0 = 2.46954962375565
        y0 = -1.51067616887886
        n = 2**15  # Number of iterations
        
        logging.info("Running complex_iterated_map with x0 = %f, y0 = %f, n = %d", x0, y0, n)
        xn, yn = complex_iterated_map(x0, y0, n)
        
        # Plotting the results in the complex plane
        plt.figure(figsize=(8, 8))
        plt.scatter(xn, yn, color='#cd0066', s=0.05)
        plt.xlabel('Re(z)')
        plt.ylabel('Im(z)')
        plt.title('Complex-Valued Iterated Map')
        plt.axis('equal')
        plt.show()
    except Exception as e:
        logging.error("An error occurred: %s", e)

if __name__ == '__main__':
    main()
