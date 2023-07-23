#include "main.hpp"

int main(int argc, char *argv[]) {
	if(argc < 4) {
		std::cerr << "ERROR: Input arguments" << std::endl;
		std::abort();
	}
	std::string parameter_filename = argv[1];
	std::string nodes_filename = argv[2];
	std::string routes_filename = argv[3];

	parameter::Parameter param(parameter_filename);

	int size = param.get<int>("size", 100);
	int n = param.get<int>("n", 30);
	int m = param.get<int>("m", 4);
	int K = param.get<int>("K", 5);
	int L = param.get<int>("L", 15);

	model::Model model(size, n, m, K, L);

	if(param.contains("seed")) {
		model.setSeed(param.get<int>("seed"));
	}

	model.generateRandom();

	solver::Solver solver(model);

	bool solved = solver.solve();

	if(solved) {
		std::ofstream nodes_file(nodes_filename);
		nodes_file << model;

		std::ofstream routes_file(routes_filename);
		solver.printResult(routes_file);
	}

	return 0;
}
