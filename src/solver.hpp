#pragma once

#include "model.hpp"
#include <ilcplex/ilocplex.h>
#include <fstream>
#include <iostream>
#include <string>

ILOSTLBEGIN

namespace solver {
	class Solver {
		private:
			model::Model my_model;
			std::vector<std::vector<int>> result;
		public:
			Solver(model::Model arg_Model);
			bool solve();
			void findRoute(const int y, const int ind);
			void setNumber();
			void printResult(std::ofstream& file);
	};
}
