# Chapter 1 - Overview

## Ideas in computer architectures

- Moore's law

- Abstraction to simplify design

- Make common case fast

- Parallelism

- Pipelining

- Prediction

- Memory hierarchy

- Dependability via redundancy

## Evaluating Performance

- Response time
  - How long it takes to do a task.
- Throughput
  - Work done per unit time.
- Focus on response time for now.

$$
\begin{align}
\text{Performance} &= \frac{1}{\text{Execution Time}} \\
\\
\frac{\text{Performance}_x}{\text{Performance}_y}
&= \frac{\text{Execution Time}_y}{\text{Execution Time}_x}
= n\\
&\Rightarrow \text{$x$ is $n$ times faster than $y$}
\end{align}
$$

- Elapsed time
  - Total response time, including every aspects (CPU, IO, OS overhead, idle time).
  - Determines performance of the whole system
- CPU time
  - Time spent on a given job (doesn't include IO).
  - User CPU time & system CPU time.

- CPI
  - Cycles per instruction.
  - Might be different for different instructions.
  - Average CPI of a program is instruction-count-weighted.

$$
\begin{align}
\text{CPU time}
&= \text{Clock cycles} \times \text{Cycle time} \\
&= \frac{\text{CPU clock cycles}}{\text{Clock rate}} \\
\\
\text{Clock cycles}
&= \text{\# Instructions} \times \text{CPI} \\
\\
\Rightarrow \text{CPU time}
&= \text{\# Instructions} \times \text{CPI} \times \text{Cycle time} \\
\end{align}
$$


- Things that affects performance

  - Algorithm: # instructions, possibly CPI
  - Language: # instructions, CPI
  - Compiler: # instructions, CPI
  - ISA: # instructions, CPI, cycle time

## Power

$$
\text{Power}
= \text{Capacitive load} \times \text{Voltage}^2 \times \text{Frequency}
$$

- Power wall
  - Voltage can't be dropped further. (currently around 1.0V)
  - Cooling
- Use multiprocessor to solve power problem.
  - Requires explicitly parallel programming
  - Load balancing
  - Synchronization & communication


## Amdahl's Law

$$
T_{\text{improved}} = \frac{T_{\text{affected}}}{\text{improvement factor}}+T_{\text{unaffected}}
$$

Make common cases fast is important.

