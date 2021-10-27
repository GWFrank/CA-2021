# HW1

b09902004 郭懷元

### 1.5

#### a.

P1: $\frac{3 \times 10^9}{1.5} = 2 \times 10^9$ instructions per second
P2: $\frac{2.5 \times 10^9}{1.0} = 2.5 \times 10^9$ instructions per second
P3: $\frac{4.0 \times 10^9}{2.2} = 1.8 \times 10^9$ instructions per second

P2 has the highest instructions per second.

#### b.

P1: $(3 \times 10^9) \times 10 = 3 \times 10^{10}$ cycles; $\frac{3 \times 10^{10}}{1.5} = 2 \times 10^{10}$ instructions
P2: $(2.5 \times 10^9) \times 10 = 2.5 \times 10^{10}$cycles; $\frac{2.5 \times 10^{10}}{1.0} = 2.5 \times 10^{10}$ instructions
P3: $(4.0 \times 10^9) \times 10 = 4 \times 10^{10}$ cycles; $\frac{4 \times 10^{10}}{2.2} = 1.8 \times 10^{10}$ instructions

#### c.

$$
\begin{aligned}
time &= instructions \times \frac{cycle}{instruction} \times \frac{time}{cycle}= instructions \times \frac{CPI}{clock\ rate} \\
clock\ rate &= instructions \times \frac{CPI}{time}
\end{aligned}
$$

P1: $3 \times 10^9 \times (1 \times \frac{1.2}{0.7}) = 5.1$ GHz
P2: $2.5 \times 10^9 \times (1 \times \frac{1.2}{0.7}) = 4.3$ GHz
P3: $4 \times 10^9 \times (1 \times \frac{1.2}{0.7}) = 6.9$ GHz

---

### 1.6

#### a.

P1: $1\times0.1 + 2\times0.2 + 3\times0.5 + 3\times0.2 = 2.6$ CPI
P2: $2\times0.1 + 2\times0.2 + 2\times0.5 + 2\times0.2 = 2$ CPI

#### b.

P1: $2.6 \times 10^6$ cycles
P2: $2 \times 10^6$ cycles

P1 runs for $\frac{2.6\times10^6}{2.5\times10^9} = 1.04$ ms; P2 runs for $\frac{2\times10^6}{3\times10^9} = 0.67$ ms
P2 is faster.

---

### 1.7

#### a.

Compiler A: $\frac{1.1 / 10^{-9}}{10^9} = 1.1$ CPI
Compiler B: $\frac{1.5 / 10^{-9}}{1.2 \times10^9} = 1.25$ CPI

#### b.

$ \frac{10^9}{1.2\times10^9} \times \frac{1.1/1.25}{1/1} = 0.73$ times faster

#### c.

New compiler time: $6 \times 10^8 \times 1.1 \times 10^{-9} = 0.66$ s
Reduce $40\%$ of time versus compiler A; Reduce $56\%$ of time versus compiler B.

---

### 1.11

#### 1.11.1

$\frac{750/(0.333\times10^{-9})}{2.389 \times 10^{12}} = 0.943$ CPI

#### 1.11.2

SPECratio: $\frac{9650}{750} = 12.87$

#### 1.11.3

CPU time increase $750 \times 0.1 = 75$ s.

#### 1.11.4

CPU time increase $750 \times (1.1\times1.05-1) = 116.25$ s.

#### 1.11.5

SPECratio decreased by $1 - \frac{750}{750+116.25} = 13.4\%$

#### 1.11.6

$\frac{700 \times 4 \times 10^9}{2.389 \times 10^{12} \times 0.85} = 1.379$ CPI

#### 1.11.7

Clock rate increased by $33.3\%$, and CPI increased by $46.2\%$. They are dissimilar because the new processor is using a different instruction set.

#### 1.11.8

CPU time is reduced by $1 - \frac{700}{750} = 6.67\%$

#### 1.11.9

$\frac{4\times10^9\times0.9\times960\times10^{-9}}{1.61} = 2147$ instructions

#### 1.11.10

$3\times10^9\times(\frac{1}{0.9}) = 3.33$ GHz

#### 1.11.11

$3\times10^9\times(\frac{0.85}{0.8}) = 3.19$ GHz

---

### 1.14

#### 1.14.1

Number of cycles needed is $(50\times1+110\times1+80\times4+16\times2)\times10^6=5.12\times10^{8}$
Number of cycles of FP instructions is $50 \times 10^6 \times 1 = 5 \times 10^7$
By Amdahl's Law, $0.5 \times 5.12\times10^8 = \frac{5\times10^7}{n} + 4.62 \times 10^8$ where $n$ is the improvement of the CPI. But there are no positive solution of $n$, so it's impossible to run two times faster by only improving CPI of FP instruction.

#### 1.14.2

Number of cycles of L/S instructions is $80 \times 10^6 \times 4 = 3.2 \times 10^8$
By Amdahl's Law, $0.5 \times 5.12\times10^8 = \frac{3.2 \times 10^8}{n} + 1.92 \times 10^8$ where $n$ is the improvement of the CPI. $n=5$ is the solution to that equation, so the CPI of L/S instructions should be improved by 5 times, which is to be reduced to $20\%$.

#### 1.14.3

Number of cycles after improvement is $(50\times0.6+110\times0.6+80\times4\times0.7+16\times2)\times10^6=3.52\times10^{8}$
Time improvement is $\frac{5.12\times10^8}{2\times10^9} - \frac{3.52\times10^8}{2\times10^9}=0.08$ s, which is about a $31\%$ reduction.

