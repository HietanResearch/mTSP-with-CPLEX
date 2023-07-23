# Please set the variable according to your environment like examples below.
# MY_CPLEX_ROOT_DIR := /opt/ibm/ILOG/CPLEX_Studio****
# MY_CPLEX_ROOT_DIR := /Applications/CPLEX_Studio****

# Set Input File
PARAMETER := parameter.cfg

# Set Output File
TIME := $(shell date "+%Y%m%d%H%M%S")

OUTDIR := out

NODES_CSV := $(OUTDIR)/nodes_$(TIME).csv
ROUTES_CSV := $(OUTDIR)/routes_$(TIME).csv
PDF := $(OUTDIR)/graph_$(TIME).pdf

# Detect Kernel Name
KERNEL := $(shell uname -s)

# Detect Architecture Name
ARCHITECTURE := $(shell uname -m)

# Set variables to depend on OS and architecture
ifeq ($(KERNEL), Linux)
	ifeq ($(ARCHITECTURE), x86_64)
		SYSTEM_DIR := x86-64_linux
	endif

	CPLEX_ROOT_DIR := /opt/ibm/ILOG/CPLEX_Studio2211
	CCC := g++
	CCOPT := -m64 -fPIC -fno-strict-aliasing -fexceptions -DNDEBUG
	CCLNFLAGS := -lconcert -lilocplex -lcplex -lm -lpthread -ldl

else ifeq ($(KERNEL), Darwin)
	ifeq ($(ARCHITECTURE), arm64)
		SYSTEM_DIR := arm64_osx
	else ifeq ($(ARCHITECTURE), x86_64)
		SYSTEM_DIR := x86-64_osx
	endif

	CPLEX_ROOT_DIR := /Applications/CPLEX_Studio2211
	CCC := clang++
	CCPOT := -m64 -O -fPIC -fexceptions -DNDEBUG -stdlib=libc++
	CCLNFLAGS := -lconcert -lilocplex -lcplex -m64 -lm -lpthread -framework CoreFoundation -framework IOKit -stdlib=libc++

else
	$(error ERROR: OS or CPU architecture does not supported.)
endif

# Set Directories
LIBFORMAT := static_pic

ifdef MY_CPLEX_ROOT_DIR
	CPLEX_ROOT_DIR := $(MY_CPLEX_ROOT_DIR)
endif

CPLEXDIR		:= $(CPLEX_ROOT_DIR)/cplex
CONCERTDIR	:= $(CPLEX_ROOT_DIR)/concert

CPLEXLIBDIR		:= $(CPLEXDIR)/lib/$(SYSTEM_DIR)/$(LIBFORMAT)
CONCERTLIBDIR	:= $(CONCERTDIR)/lib/$(SYSTEM_DIR)/$(LIBFORMAT)

CPLEXINCDIR		:= $(CPLEXDIR)/include
CONCERTINCDIR	:= $(CONCERTDIR)/include

# Set Flags
CCLNDIRS := -L$(CPLEXLIBDIR) -L$(CONCERTLIBDIR)

MYFLAGS := -std=c++20 -Wall -Wextra -Wshadow -ftrapv
CCFLAGS := $(MYFLAGS) $(CCOPT) -I$(CPLEXINCDIR) -I$(CONCERTINCDIR)

# Set Files
BINDIR := bin
TARGET := $(BINDIR)/main.out

SRCDIR := src
SRCS := $(wildcard $(SRCDIR)/*.cpp)
R_SRC := $(SRCDIR)/makeGraph.R

OBJDIR := obj
OBJS := $(addprefix $(OBJDIR)/, $(notdir $(SRCS:.cpp=.o)))

MAKE_DIRS := $(BINDIR) $(OBJDIR) $(OUTDIR)

# Set Commands
.SILENT:

all: $(MAKE_DIRS) $(TARGET)
	echo "Make: Done all"

rebuild: clean all
	echo "Make: Done rebuild"

execute: all run
	echo "Make: Done execute"

execute_all: execute graph
	echo "Make: Done execute_all"

reexecute: clean execute
	echo "Make: Done reexecute"

run:
	./$(TARGET) $(PARAMETER) $(NODES_CSV) $(ROUTES_CSV)
	echo "Make: Done run"

run_all: run graph
	echo "Make: Done run_all"

clean:
	rm -rf $(MAKE_DIRS)
	echo "Make: Done clean"

graph:
	Rscript $(R_SRC) $(NODES_CSV) $(ROUTES_CSV) $(PDF)
	echo "Make: Done graph"

$(TARGET): $(OBJS)
	$(CCC) $(CCFLAGS) $(CCLNDIRS) -o $@ $^ $(CCLNFLAGS)
	echo "Make: Compiled $^"

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(CCC) -c $(CCFLAGS) $^ -o $@
	echo "Make: Linked $^"

$(MAKE_DIRS):
	$(shell mkdir $@)
	echo "Make: Make directories $@"
