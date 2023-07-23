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
* [R](https://www.r-project.org/)
* [igraph](https://igraph.org/) (To install, type `install.packages("igraph")` in the R console.)

## Usage

* Get the code from GitHub.
	* `git clone https://github.com/HietanResearch/mTSP-with-CPLEX.git`
	* `git clone git@github.com:HietanResearch/mTSP-with-CPLEX.git`
* Move directory.
	* `cd mTSP-with-CPLEX`
* Open `Makefile`, and set the variable `MY_CPLEX_ROOT_DIR` which shows where your CPLEX is installed.
	* Example1 (Linux Default) : `MY_CPLEX_ROOT_DIR := /opt/ibm/ILOG/CPLEX_Studio****`
  * Example2 (Mac OS X Default) : `MY_CPLEX_ROOT_DIR := /Applications/CPLEX_Studio****`
  * (`****` means CPLEX version.)
* Compile C++ source files.
	* `make all`
* Run the executable and make graph.
	* `make run_graph`
* Confirm the results.
	* `open out/graph_**************.pdf`
	* (`**************` means time infomation.)
* (If you can use R and igraph, type below.)
  * `make run`

## Makefile Targets

* `all`: Compile all source files
* `rebuild`: Do `clean` and `all`
* `execute`: Do `all` and `run`
* `execute_graph`: Do `execute` and make graph
* `reexecute`: Do `clean` and `execute`
* `reexecute_graph`: Do `reexecute` and make graph
* `run`: Run executable file
* `run_graph`: Do `run` and make graph
* `clean`: delete all generated files

## parameter.cfg

In this file, you can change parameters to give program.

* size : Map size to place nodes.
* n : The number of nodes.
* m : The number of salesmans.
* K : minimum number of nodes a salesman must visit.
* L : maximum number of nodes a salesman may visit.
* seed : Random numbuer seed for node placement.
  * seed $` = 0 `$ : Nodes are placed completely randomly.
  * seed $` \neq 0 `$ : Nodes are placed according to the seed value.
  
## Integer programming formulations

### Formulations

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

### Variables

* $` x_{ij} `$
  
$$
	\large
	x_{ij} = 
	\left\lbrace
		\begin{array}{ll}
			1 & \text{if arc } (i,j) \text{ is in the optimal solution} \\
			0 & \text{otherwise}
		\end{array}
	\right.
$$

* $` u_i `$
  * The number of nodes visited on that traveler's path from the origin up to node $` i `$
  * $` u_0 = 0 `$
  * $` 1 \leq u_i \leq L, i \leq 2 `$



### Constants

* $` c_{ij} `$
  * The cost of arc $` (i, j) `$
  * $` c_{ij} = c_{ji} `$
* $` n `$ : The number of nodes.
* $` m `$ : The number of salesmans.
* $` K `$ : minimum number of nodes a salesman must visit.
* $` L `$ : maximum number of nodes a salesman may visit.

### Others

* $` A `$ : The set of arcs.
