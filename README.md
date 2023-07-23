# multiple Traveling Salesman Problem with CPLEX

This program aims to solve the multiple Traveling Salesman Problem (mTSP), which is one of the combinatorial optimization problems, using the mathematical programming solver [IBM® CPLEX® Optimizer](https://www.ibm.com/products/ilog-cplex-optimization-studio/cplex-optimizer).

## Requirements

### Platforms and CPU Architectures
* Linux OS (I verified its operation on Debian 12.)
	* x86_64
* Mac OS X
	* x86_64
	* arm64

### Tools

* [IBM® CPLEX® Optimizer](https://www.ibm.com/products/ilog-cplex-optimization-studio/cplex-optimizer)
* C++20
* GCC (when using Linux)
* Clang (when using Max OS X)
* R
* igraph R package (To install, type `install.packages("igraph")` in the R console.)

## Usage

* Get the code from GitHub.
	* `git clone https://github.com/HietanResearch/mTSP-with-CPLEX.git`
	* `git clone git@github.com:HietanResearch/mTSP-with-CPLEX.git`
* Move directory.
	* `cd mTSP-with-CPLEX`
* Open `Makefile`, and set variable `MY_CPLEX_ROOT_DIR` where your CPLEX is installed.
  	* Example1(Default Linux) : `MY_CPLEX_ROOT_DIR := /opt/ibm/ILOG/CPLEX_Studio****`
  	* Example2(Default Mac OS X) : `MY_CPLEX_ROOT_DIR := /Applications/CPLEX_Studio****`
  	* (`****` means CPLEX version)
* Compile C++ source files.
	* `make all`
* Run the executable and make graph.
	* `make run_all`
* Confirm the results.
	* `open out/graph_**************.pdf`
	* (`**************` means time infomation)

## Makefile

* `all`: Compile all source files
* `rebuild`: Do `clean` and `all`
* `execute`: Do `all` and `run`
* `execute_all`: Do `execute` and make graph
* `reexecute`: Do `clean` and `execute`
* `run`: Run executable file
* `run_all`: Do `run` and make graph
* `clean`: delete all generated files

## Integer programming formulations

$$
	\large
	\begin{array}{lll}
		\mathrm{minimize}	& \displaystyle \sum_{(i, j) \in A} c_{ij} x_{ij}	& \\
		\mathrm{s.t.}    	& \displaystyle \sum_{j=2}^{n} x_{1j} = m, & \\
											& \displaystyle \sum_{i=2}^{n} x_{i1} = m, & \\
											& \displaystyle \sum_{i=1}^{n} x_{ij} = 1, & j = 2, ... , n, \\
					 						& \displaystyle \sum_{j=1}^{n} x_{ij} = 1, & i = 2, ... , n, \\
											& u_i + (L - 2) x_{1i} - x_{i1} \leq L - 1, & i = 2, ... , n, \\
					 						& u_i + x_{1i} + (2 - K) x_{i1} \geq 2,				 & i = 2, ... , n, \\
											& x_{1i} + x_{i1} \leq 1, 								 & i = 2, ... , n, \\
					 						& u_i - u_j + L x_{ij} + (L - 2) x_{ji} \leq L - 1, & 2 \leq i \neq j \leq n, \\
											& x_{ij} \in \lbrace 0, 1 \rbrace, \forall (i, j) \in A. & 
	\end{array}
$$
