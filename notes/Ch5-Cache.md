# Memory Hierarchy & Cache

## Associativity

- Fully associative
  - Any block can go to any entry in cache
  - Searching requires more time
- n-way associative
  - Each set contains n entries
  - `Set index = Block number % # Sets in cache`
- Direct mapped (1-way associative)
  - Location in cache determined by memory address
  - `Cache index = Block number % # Blocks in cache`
  - "Tag" to indicate the "real address" of cached data
  - "Valid bit" to indicate is there is data
  - An address can be split into "tag", "cache index", "block offset"
- Higher associativity has lower miss rate.

## Block size

For larger blocks:

- Lower miss rate in high spatial locality workloads
- Larger miss penalty due to more data
- Consider a fixed-size cache, it has more competition & pollution

## Writing

- Strategies
  - Write-through
    - Each write updates cache & memory
    - Utilize "write buffer" so that CPU only stalls when buffer is full
  - Write-back
    - Update only data in cache, then mark that block "dirty"
    - When a dirty block is replaced, write it back to memory
- Write Allocation: what to do on writing cache miss
  - Allocate on miss: fetch block to memory
  - Write around: don't fetch
  - Write-back usually fetch the block

## Performance

- Miss rate
  - Local miss rate: `# misses in this cache / # references to this cache`
  - Global miss rate: `# misses in this cache / # total queries from CPU`
- Average memory access time (AMAT)
  - `Hit time + Miss rate * Miss Penalty`
  - `Hit time + Global miss rate of each level * Miss penalty of each level `
- About CPU
  - Miss penalty becomes more significant as CPU performance is increased
  - Lower base CPI 

## Multilevel

- L1 / primary cache
    - Attached to CPU
    - Small but fast
    - Focus on minimal hit time
    - Smaller block size
- L2 cache
    - Larger but a bit slower than L1
    - Focus on low miss rate
    - Larger block size
- L3 cache: in modern high-end processors

## Software

- Cache missed depend on access patterns
- Memory blocking
  - Maximize accesses to cached data before it's replaced
  - Example: general matrix multiplication (GEMM)

## Virtual Memory

- Main memory as cache for disk
- Programs use virtual address. OS & CPU translate it to physical address
- Block <-> Page
- Cache miss <-> Page fault
  - Page fault penalty is really high, so we should try to minimize page fault rate.
  - Fully associative + Smart replacement

## Page Table & TLB

- Page table
  - Translate virtual memory address to physical memory address
  - Placement information (physical page number / in disk)
  - Status bits like dirty, referenced
  - LRU replacement
  - Write-back
- TLB
  - A cache for page table. Allows faster translation
  - Often small to achieve low hit time
  - When TLB misses, lookup page table
    - Can be handled by hardware or software

## Types of Misses

- Compulsory misses
  - First access, therefore no cache
- Capacity misses
  - Cache size limitation
  - A replaced block is accessed again later
- Conflict misses
  - Only in non-fully associative
  - Due to competition in the same set





