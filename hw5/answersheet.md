

# CA HW5

b09902004 資工二 郭懷元

## 5.10

### 5.10.1

P1:

$$
\text{clock rate}
= \frac{1}{\text{cycle time}}
= \frac{1}{0.66 \times 10^{-9}}
\approx 1.52 \times 10^9
= 1.52 \text{ GHz}
$$

P2:

$$
\text{clock rate}
= \frac{1}{\text{cycle time}}
= \frac{1}{0.90 \times 10^{-9}}
\approx 1.11 \times 10^9
= 1.11 \text{ GHz}
$$

### 5.10.2

P1:

$$
\begin{aligned}
\text{AMAT}
&= \text{hit time} + \text{miss rate} \times \text{miss penalty} \\
&= 0.66 + 0.08 \times 70 \text{ ns}\\
&= 6.26 \text{ ns} \\
&= \frac{6.26}{0.66} = 9.49 \text{ cycles} \\
\end{aligned}
$$

P2:

$$
\begin{aligned}
\text{AMAT}
&= \text{hit time} + \text{miss rate} \times \text{miss penalty} \\
&= 0.90 + 0.06 \times 70 \text{ ns}\\
&= 5.10 \text{ ns} \\
&= \frac{5.10}{0.90} = 5.67 \text{ cycles} \\
\end{aligned}
$$

### 5.10.3

P1's CPI:

$$
\begin{aligned}
\text{CPI}
&= \text{base CPI} + \text{data mem ins ratio} \times \text{AMAT} \\
&= 1.0 + 0.36 \times 9.49 = 4.42
\end{aligned}
$$

P2's CPI:

$$
\begin{aligned}
\text{CPI}
&= \text{base CPI} + \text{data mem ins ratio} \times \text{AMAT} \\
&= 1.0 + 0.36 \times 5.67 = 3.04
\end{aligned}
$$

P1's latency:

$$
\text{latency}
= \text{cycle time} \times \text{CPI}
= 0.66 \times 4.42
= 2.92 \text{ ns}
$$

P2's latency:

$$
\text{latency}
= \text{cycle time} \times \text{CPI}
= 0.90 \times 3.04
= 2.74 \text{ ns}
$$

P2 is faster because it has lower latency.

### 5.10.4

AMAT without L2 cache: 9.49 cycles

AMAT with L2 cache:

$$
\begin{aligned}
\text{L2 global miss rate}
&= \text{L1 miss rate} \times \text{L2 local miss rate} \\
&= 0.08 \times 0.95 \\
&= 0.076 \\
\\
\text{AMAT}
&= \text{L1 hit time} \\
&\qquad + \text{L1 miss rate} \times \text{L2 hit time} \\
&\qquad + \text{L2 global miss rate} \times \text{miss penalty}\\
&= 0.66 + 0.08 \times 5.62 + 0.076 \times 70 \text{ ns} \\
&= 6.43 \text{ ns} \\
&= \frac{6.43}{0.66} = 9.74 \text{ cycles}
\end{aligned}
$$

AMAT is worse with L2 cache.

### 5.10.5

$$
\begin{aligned}
\text{CPI}
&= \text{base CPI} + \text{data mem ins ratio} \times \text{AMAT} \\
&= 1.0 + 0.36 \times 9.74 = 4.51
\end{aligned}
$$

### 5.10.6

Because base CPI and cycle time is the same, we can compare only AMAT.

Let the needed L2 miss rate be $r$.

$$
\begin{aligned}
(0.66 + 0.08 \times 5.62 + 0.08 \times r \times 70)\text{ ns}
&\lt 6.26 \text{ ns} \\
r
&\lt \frac{6.26 - 0.66 - 0.08 \times 5.62}{0.08 \times 70} \\
r &\lt 0.92
\end{aligned}
$$

L2 miss rate needs to be less than 0.92.

### 5.10.7

P2's latency without L2 cache: 2.74 ns

Let the needed L2 miss rate be $r$, needed CPI be $c$.

$$
\begin{aligned}
0.66 \times c &\lt 2.74 \\
c &\lt 4.15 \\
\\
c
&= 1.0 + 0.36 \times
\frac{0.66 + 0.08 \times 5.62 + 0.08 \times r \times 70}{0.66} \\
&= 1.0 + \frac{0.36}{0.66} \times (1.11 + 5.6r) \\
&\lt 4.15 \\
\\
r &\lt \frac{(4.15-1.0) \times \frac{0.66}{0.36} - 1.11}{5.6} \\
r &\lt 0.83 \\
\end{aligned}
$$

L2 miss rate needs to be less than 0.83.

## 5.16

### 5.16.1

1. Access `0x123d`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x1` | Miss | Hit        | In disk              | True       |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0xb` | `12`                 | `5`                    |
     | 1     | `0x7` | `4`                  | `2`                    |
     | 1     | `0x3` | `6`                  | `4`                    |
     | 1     | `0x1` | `13`                 | `1`                    |

2. Access `0x08b3`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x0` | Miss | Hit        | `5`                  | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `1`                    |
     | 1     | `0x7` | `4`                  | `3`                    |
     | 1     | `0x3` | `6`                  | `5`                    |
     | 1     | `0x1` | `13`                 | `2`                    |

3. Access `0x365c`
   
   - | Tag   | TLB | Page table | Physical Page Number | Page fault |
     |:-----:|:---:|:----------:|:--------------------:|:----------:|
     | `0x3` | Hit | -          | `6`                  | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `2`                    |
     | 1     | `0x7` | `4`                  | `4`                    |
     | 1     | `0x3` | `6`                  | `1`                    |
     | 1     | `0x1` | `13`                 | `3`                    |

4. Access `0x871b`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x8` | Miss | Hit        | In disk              | True       |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `3`                    |
     | 1     | `0x8` | `14`                 | `1`                    |
     | 1     | `0x3` | `6`                  | `2`                    |
     | 1     | `0x1` | `13`                 | `4`                    |

5. Access `0xbee6`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0xb` | Miss | Hit        | `12`                 | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `4`                    |
     | 1     | `0x8` | `14`                 | `2`                    |
     | 1     | `0x3` | `6`                  | `3`                    |
     | 1     | `0xb` | `12`                 | `1`                    |

6. Access `0x3140`
   
   - | Tag   | TLB | Page table | Physical Page Number | Page fault |
     |:-----:|:---:|:----------:|:--------------------:|:----------:|
     | `0x3` | Hit | -          | `6`                  | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `5`                    |
     | 1     | `0x8` | `14`                 | `3`                    |
     | 1     | `0x3` | `6`                  | `1`                    |
     | 1     | `0xb` | `12`                 | `2`                    |

7. Access `0xc049`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0xc` | Miss | Miss       | In disk              | True       |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0xc` | `15`                 | `1`                    |
     | 1     | `0x8` | `14`                 | `4`                    |
     | 1     | `0x3` | `6`                  | `2`                    |
     | 1     | `0xb` | `12`                 | `3`                    |

### 5.16.2

Assume that all initial values in TLB are invalid, `Valid` are all set to `0`, and data will be replaced.

1. Access `0x123d`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x0` | Miss | Hit        | `5`                  | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `1`                    |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |

2. Access `0x08b3`
   
   - | Tag   | TLB | Page table | Physical Page Number | Page fault |
     |:-----:|:---:|:----------:|:--------------------:|:----------:|
     | `0x0` | Hit | -          | `5`                  | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `1`                    |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |

3. Access `0x365c`
   
   - | Tag   | TLB | Page table | Physical Page Number | Page fault |
     |:-----:|:---:|:----------:|:--------------------:|:----------:|
     | `0x0` | Hit | -          | `5`                  | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `1`                    |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |

4. Access `0x871b`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x2` | Miss | Hit        | In disk              | True       |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `2`                    |
     | 1     | `0x2` | `13`                 | `1`                    |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |

5. Access `0xbee6`
   
   - | Tag   | TLB | Page table | Physical Page Number | Page fault |
     |:-----:|:---:|:----------:|:--------------------:|:----------:|
     | `0x2` | Hit | -          | `13`                 | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `3`                    |
     | 1     | `0x2` | `13`                 | `1`                    |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |

6. Access `0x3140`
   
   - | Tag   | TLB | Page table | Physical Page Number | Page fault |
     |:-----:|:---:|:----------:|:--------------------:|:----------:|
     | `0x0` | Hit | -          | `5`                  | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `1`                    |
     | 1     | `0x2` | `13`                 | `2`                    |
     | 0     | x     | x                    | x                      |
     | 0     | x     | x                    | x                      |

7. Access `0xc049`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x3` | Miss | Hit        | `6`                  | False      |
   
   - | Valid | Tag   | Physical Page Number | Time Since Last Access |
     |:-----:|:-----:|:--------------------:|:----------------------:|
     | 1     | `0x0` | `5`                  | `2`                    |
     | 1     | `0x2` | `13`                 | `3`                    |
     | 1     | `0x3` | `6`                  | `1`                    |
     | 0     | x     | x                    | x                      |

Advantages:

- Lower miss rate for workloads with high spatial locality.

Disadvantages:

- Larger miss penalty because more data needs to be read from main disk.
- Within the same size of total memory, less entries means higher miss rate for workloads with low spatial locality.

### 5.16.3

Assumptions:

- `Tag%2=0` goes to set 0. `Tag%2=1` goes to set 1.
- First two entries are set 0. The other two are set 1.
- Initial values in TLB are invalid, `Valid` are set to 0, and all data will be replaced.

1. Access `0x123d`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x1` | Miss | Hit        | In disk              | True       |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   0   |   -   |          -           |           -            |
     |   0   |   -   |          -           |           -            |
     |   1   | `0x1` |         `13`         |          `1`           |
     |   0   |   -   |          -           |           -            |

2. Access `0x08b3`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x0` | Miss | Hit        | `5`                  | False      |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x0` |         `5`          |          `1`           |
     |   0   |   -   |          -           |           -            |
     |   1   | `0x1` |         `13`         |          `2`           |
     |   0   |   -   |          -           |           -            |

3. Access `0x365c`
   
   - |  Tag  | TLB  | Page table | Physical Page Number | Page fault |
     | :---: | :--: | :--------: | :------------------: | :--------: |
     | `0x3` | Miss |    Hit     |         `6`          |   False    |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x0` |         `5`          |          `2`           |
     |   0   |   -   |          -           |           -            |
     |   1   | `0x1` |         `13`         |          `3`           |
     |   1   | `0x3` |         `6`          |          `1`           |

4. Access `0x871b`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x8` | Miss | Hit        | In disk              | True       |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x0` |         `5`          |          `3`           |
     |   1   | `0x8` |         `14`         |          `1`           |
     |   1   | `0x1` |         `13`         |          `4`           |
     |   1   | `0x3` |         `6`          |          `2`           |

5. Access `0xbee6`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0xb` | Miss | Hit        | `12`                 | False      |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x0` |         `5`          |          `4`           |
     |   1   | `0x8` |         `14`         |          `2`           |
     |   1   | `0xb` |         `12`         |          `1`           |
     |   1   | `0x3` |         `6`          |          `3`           |

6. Access `0x3140`
   
   - | Tag   | TLB | Page table | Physical Page Number | Page fault |
     |:-----:|:---:|:----------:|:--------------------:|:----------:|
     | `0x3` | Hit | -          | `6`                  | False      |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x0` |         `5`          |          `5`           |
     |   1   | `0x8` |         `14`         |          `3`           |
     |   1   | `0xb` |         `12`         |          `2`           |
     |   1   | `0x3` |         `6`          |          `1`           |

7. Access `0xc049`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0xc` | Miss | Miss       | In disk              | True       |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0xc` |         `5`          |          `1`           |
     |   1   | `0x8` |         `14`         |          `4`           |
     |   1   | `0xb` |         `12`         |          `3`           |
     |   1   | `0x3` |         `6`          |          `2`           |

### 5.16.4

Assumptions:

- Use `Tag%4` to map.
- Initial values in TLB are invalid, `Valid` are set to 0, and all data will be replaced.

1. Access `0x123d`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x1` | Miss | Hit        | In disk              | True       |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   0   |   -   |          -           |           -            |
     |   1   | `0x1` |         `13`         |          `1`           |
     |   0   |   -   |          -           |           -            |
     |   0   |   -   |          -           |           -            |

2. Access `0x08b3`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x0` | Miss | Hit        | `5`                  | False      |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x0` |         `5`          |          `1`           |
     |   1   | `0x1` |         `13`         |          `2`           |
     |   0   |   -   |          -           |           -            |
     |   0   |   -   |          -           |           -            |

3. Access `0x365c`
   
   - |  Tag  | TLB  | Page table | Physical Page Number | Page fault |
     | :---: | :--: | :--------: | :------------------: | :--------: |
     | `0x3` | Miss |    Hit     |         `6`          |   False    |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x0` |         `5`          |          `2`           |
     |   1   | `0x1` |         `13`         |          `3`           |
     |   0   |   -   |          -           |           -            |
     |   1   | `0x3` |         `6`          |          `1`           |

4. Access `0x871b`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0x8` | Miss | Hit        | In disk              | True       |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x8` |         `14`         |          `1`           |
     |   1   | `0x1` |         `13`         |          `3`           |
     |   0   |   -   |          -           |           -            |
     |   1   | `0x3` |         `6`          |          `2`           |

5. Access `0xbee6`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0xb` | Miss | Hit        | `12`                 | False      |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x8` |         `14`         |          `2`           |
     |   1   | `0x1` |         `13`         |          `4`           |
     |   0   |   -   |          -           |           -            |
     |   1   | `0xb` |         `12`         |          `1`           |

6. Access `0x3140`
   
   - |  Tag  | TLB  | Page table | Physical Page Number | Page fault |
     | :---: | :--: | :--------: | :------------------: | :--------: |
     | `0x3` | Miss |    Hit     |         `6`          |   False    |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0x8` |         `14`         |          `3`           |
     |   1   | `0x1` |         `13`         |          `5`           |
     |   0   |   -   |          -           |           -            |
     |   1   | `0x3` |         `6`          |          `1`           |

7. Access `0xc049`
   
   - | Tag   | TLB  | Page table | Physical Page Number | Page fault |
     |:-----:|:----:|:----------:|:--------------------:|:----------:|
     | `0xc` | Miss | Miss       | In disk              | True       |
   
   - | Valid |  Tag  | Physical Page Number | Time Since Last Access |
     | :---: | :---: | :------------------: | :--------------------: |
     |   1   | `0xc` |         `15`         |          `1`           |
     |   1   | `0x1` |         `13`         |          `6`           |
     |   0   |   -   |          -           |           -            |
     |   1   | `0x3` |         `6`          |          `2`           |

### 5.16.5

Without TLB, a virtual memory access would search through the page table to find physical page number. When there is a TLB, because of temporal locality, a large portion of accesses don't have to search through the entire page table, which can be large for high performance systems with many memory.

## 6.7

### 6.7.1

| `(w, x, y, z)` | Execution Order                                              |
| -------------- | ------------------------------------------------------------ |
| `(5, 2, 2, 4)` | `1 -> 2 -> 3 -> 4`<br />`1 -> 2 -> 4 -> 3`<br />`2 -> 1 -> 3 -> 4`<br />`2 -> 1 -> 4 -> 3` |
| `(3, 2, 2, 4)` | `1 -> 3 -> 2 -> 4`<br />`2 -> 3 -> 1 -> 4`                   |
| `(3, 2, 2, 2)` | `1 -> 3 -> 4 -> 2`<br />`1 -> 4 -> 3 -> 2`<br />`2 -> 3 -> 4 -> 1`<br />`2 -> 4 -> 3 -> 1` |
| `(5, 2, 2, 2)` | `1 -> 4 -> 2 -> 3`<br />`2 -> 4 -> 1 -> 3`                   |
| `(1, 2, 2, 4)` | `3 -> 1 -> 2 -> 4`<br />`3 -> 2 -> 1 -> 4`                   |
| `(1, 2, 2, 2)` | `3 -> 1 -> 4 -> 2`<br />`3 -> 2 -> 4 -> 1`                   |
| `(0, 2, 2, 0)` | `3 -> 4 -> 1 -> 2`<br />`3 -> 4 -> 2 -> 1`<br />`4 -> 3 -> 1 -> 2`<br />`4 -> 3 -> 2 -> 1` |
| `(5, 2, 2, 0)` | `4 -> 1 -> 2 -> 3`<br />`4 -> 2 -> 1 -> 3`                   |
| `(3, 2, 2, 0)` | `4 -> 1 -> 3 -> 2`<br />`4 -> 2 -> 3 -> 1`                   |

### 6.7.2

Use signals and mutexes to synchronize between threads and processes.

## 6.9

### 6.9.1

| FU \ Cycle | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    |
| ---------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 1          | A1   | A1   | A1   | A3   | A4   | B1   | B1   | B2   | B3   |
| 2          | A2   | x    | x    | x    | x    | B4   | B4   | x    | x    |

Takes 9 cycles. 6 slots are wasted.

### 6.9.2

| CPU-FU \ Cycle | 1    | 2    | 3    | 4    | 5    |
| -------------- | ---- | ---- | ---- | ---- | ---- |
| 1-1            | A1   | A1   | A1   | A3   | A4   |
| 1-2            | A2   | x    | x    | x    | x    |
| 2-1            | B1   | B1   | B2   | B3   | x    |
| 2-2            | B4   | B4   | x    | x    | x    |

Takes 5 cycles. 8 slots are wasted.

### 6.9.3

| FU \ Cycle | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    |
| ---------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 1          | A1   | A1   | A1   | A3   | A4   | B2   | B3   | B4   | B4   |
| 2          | x    | A2   | B1   | B1   | x    | x    | x    | x    | x    |

Takes 9 cycles. 6 slots are wasted.

### 6.9.4

| FU \ Cycle | 1    | 2    | 3    | 4    | 5    | 6    |
| ---------- | ---- | ---- | ---- | ---- | ---- | ---- |
| 1          | A1   | A1   | A1   | A3   | B3   | A4   |
| 2          | A2   | B1   | B1   | B2   | B4   | B4   |

Takes 6 cycles. 0 slots wasted.
