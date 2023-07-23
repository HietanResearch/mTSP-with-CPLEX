#pragma once

#include "node.hpp"
#include <cmath>
#include <fstream>
#include <iostream>
#include <random>
#include <vector>

namespace model {
	class Model {
		private:
			const int size;
			const int n;
			const int m;
			const int K;
			const int L;
			int seed;
			std::vector<node::Node> nodes;
			std::vector<std::vector<float>> c;
		public:
			Model(int arg_size, int arg_n, int arg_m, int arg_K, int arg_L);
			int getN() const;
			int getM() const;
			int getK() const;
			int getL() const;
			void setSeed(int num);
			std::vector<std::vector<float>> getC() const;
			void generateRandom();
			friend std::ofstream& operator<<(std::ofstream& out, const Model& g);
	};
}
