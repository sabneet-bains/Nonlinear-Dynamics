"""
Implementation of a one-dimensional iterated map.

This script computes a one-dimensional iterated map defined by:
    xₙ₊₁ = xₙ * exp(λ * (1 - xₙ))
for λ values ranging from 1.5 to 4.0 (with a step of 0.001). For each λ, the map is
iterated for n steps and the first 255 iterations are discarded to remove transient dynamics.
The resulting values are plotted as a scatter plot with λ on the x-axis and xₙ on the y-axis.

Author: Sabneet Bains
License: MIT License
"""

import numpy as np
import matplotlib.pyplot as plt
import logging
from typing import Tuple, List

# Configure basic logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

def one_dimensional_map(n: int) -> Tuple[List[np.ndarray], List[np.ndarray]]:
    """
    Compute the one-dimensional iterated map for a range of λ values.
    
    The iterated map is given by:
        xₙ₊₁ = xₙ * exp(λ * (1 - xₙ))
    For each λ in [1.5, 4.0) (step 0.001), the system is iterated for n iterations,
    and the first 255 iterations are discarded to remove transients.
    
    Parameters:
        n (int): Number of iterations to perform for each λ. Must be greater than 255.
        
    Returns:
        Tuple[List[np.ndarray], List[np.ndarray]]:
            - x: List of numpy arrays containing the iterated values (after transient removal).
            - y: List of numpy arrays containing the corresponding λ values.
    """
    if n <= 255:
        raise ValueError("n must be greater than 255 to allow for transient removal.")
    
    x_results: List[np.ndarray] = []
    y_results: List[np.ndarray] = []
    
    # Iterate over each lambda value in the specified range
    for lam in np.arange(1.5, 4, 0.001):
        x0 = 0.5  # initial condition
        # Initialize iterates: first value computed from x0 and lambda
        xn = [x0 * np.exp(lam * (1 - x0))]
        yn = [lam]
        
        # Perform n iterations of the map
        for i in range(n):
            next_val = xn[i] * np.exp(lam * (1 - xn[i]))
            xn.append(next_val)
            yn.append(lam)
        
        # Discard the first 255 iterations (transients)
        xn_trimmed = np.array(xn[255:])
        yn_trimmed = np.array(yn[255:])
        
        x_results.append(xn_trimmed)
        y_results.append(yn_trimmed)
    
    return x_results, y_results

def main() -> None:
    """
    Main driver function to run the one-dimensional iterated map simulation and plot the results.
    """
    try:
        # Number of iterations for each lambda (should be > 255)
        n = 2 ** 9  # 512 iterations
        
        logging.info("Running one-dimensional iterated map with n = %d iterations per lambda", n)
        x_results, y_results = one_dimensional_map(n)
        
        # Concatenate results from all lambda values for plotting
        x_concat = np.concatenate(x_results)
        y_concat = np.concatenate(y_results)
        
        # Plot the bifurcation diagram: lambda vs. xₙ
        plt.figure(figsize=(8, 6))
        plt.scatter(y_concat, x_concat, color='#cd0066', s=0.01)
        plt.xlim(1.5, 4)
        plt.xlabel('λ')
        plt.ylabel('xₙ')
        plt.title('One-Dimensional Iterated Map')
        plt.grid(True)
        plt.show()
        
    except Exception as e:
        logging.error("An error occurred: %s", e)

if __name__ == '__main__':
    main()
