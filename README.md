# 🌌 Nonlinear Dynamics Repository  

[![Python](https://img.shields.io/badge/Python-3.9%2B-blue?logo=python)](https://www.python.org/)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2022a-orange?logo=mathworks&logoColor=white)](https://www.mathworks.com/)
[![Scientific Computing](https://img.shields.io/badge/Domain-Scientific_Computation-lightgrey?logo=atom&logoColor=white)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

<br>

**A curated collection of MATLAB and Python tools for simulating, visualizing, and analyzing complex systems and nonlinear dynamics.**  

These projects include interactive cellular automata, iterated maps, and chaos simulations that support both educational and research applications.

<img src="https://github.com/sabneet95/Nonlinear-Dynamics/blob/main/2D_Cellular_Automaton.gif" alt="2D Cellular Automaton Animation" width="800">

> *Note: These tools are primarily educational and research-focused and may require further modification for production use.*


## 🧭 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Directory Structure](#directory-structure)
- [Requirements](#requirements)
- [Usage](#usage)
- [Testing](#testing)
- [Contributing](#contributing)
- [Future Work](#future-work)
- [Author](#author)
- [License](#license)


## 🧩 Overview

This repository provides a suite of simulation tools to study nonlinear dynamics, chaos, and complex systems. It is divided into two major components:

### **MATLAB Applications**
Interactive 2D cellular automata simulations (such as the COVID-19 SIQR model) allow users to adjust parameters — lockdown strength (α), recovery rate (ɣ), and quarantine rate (q) — via intuitive knob controls.  
Optimized with vectorized operations, RNG management, and array preallocation for real-time responsiveness.

### **Python Modules**
Implements classic iterated maps (logistic, tent, complex-valued, exponential) and numerical solvers (e.g., Runge-Kutta 4).  
Each module adheres to modern Python practices with type hints, docstrings, and logging for transparency and reproducibility.


## 🧱 Architecture

### **MATLAB Apps**
- Developed using MATLAB App Designer.  
- UI components are decoupled from simulation logic.  
- Real-time updates achieved through vectorization and efficient RNG.  
- Interactive knobs allow dynamic parameter tuning during simulation.

### **Python Tools**
- Each script implements a self-contained model or solver.  
- Clean function boundaries, detailed docstrings, and robust error handling.  
- Generates bifurcation diagrams, phase plots, and chaos visualizations.


## 📂 Directory Structure

```
Nonlinear-Dynamics/
├── MATLAB/
│   ├── SIQR_Cellular_Automaton.mlapp
│   └── (Additional MATLAB simulations)
├── Python/
│   ├── logistic_map.py
│   ├── tent_map.py
│   ├── complex_iterated_map.py
│   ├── rk4_method.py
│   └── exponential_map.py
├── 2D_Cellular_Automaton.gif
├── LICENSE
└── README.md
```


## ⚙️ Requirements

- **MATLAB R2022a or later**  
  [Download MATLAB](https://www.mathworks.com/products/matlab.html)  
- **Python 3.9.1 or later (64-bit)**  
  [Download Python](https://www.python.org/downloads/)


## 🚀 Usage

### **MATLAB Applications**

1. Open *SIQR_Cellular_Automaton.mlapp* in MATLAB App Designer.  
2. Adjust parameters (α, ɣ, q) using the interactive knobs — changes apply in real time.  
3. Click **RUN** to start or reset the simulation and observe real-time cellular evolution.

### **Python Modules**

1. Clone the repository:  
   ```bash
   git clone https://github.com/sabneet95/Nonlinear-Dynamics.git
   cd Nonlinear-Dynamics/Python
   ```
2. Run a module, e.g.:  
   ```bash
   python logistic_map.py
   ```
   Similarly run *tent_map.py*, *rk4_method.py*, or *exponential_map.py*.


## 🧪 Testing

<details>
<summary>Testing Status</summary>

Automated testing is not yet implemented.  
Planned frameworks include **pytest** for Python and **MATLAB Unit Testing Framework** for MATLAB.  
Contributions to integrate testing pipelines are encouraged.
</details>


## 🤝 Contributing

1. Open an issue to discuss major changes.  
2. Ensure all code is well-documented and follows existing style conventions.  
3. Submit pull requests with clear descriptions and, if possible, tests or validation results.

> 💡 Contributors focused on **chaotic systems**, **cellular automata**, or **scientific visualization** are especially welcome.


## 🔮 Future Work

- Extend the library with additional nonlinear models and solvers.  
- Integrate automated testing frameworks for MATLAB and Python.  
- Expand documentation with examples, design notes, and roadmaps.  
- Enhance scalability for larger simulation grids.  
- Improve UI/UX in MATLAB apps for richer interactivity.


## 🧠 Author

**Sabneet Bains** — *Quantum × AI × Scientific Computing*  
[LinkedIn](https://www.linkedin.com/in/sabneet-bains/) • [GitHub](https://github.com/sabneet-bains)


## 📄 License

This repository is licensed under the [MIT License](https://choosealicense.com/licenses/mit/).

