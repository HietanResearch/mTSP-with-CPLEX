#include <cmath>
#include <fstream>
#include <iostream>

namespace node {
	class Node {
		private:
			int x;
			int y;
			int id;
		public:
			Node();
			Node(const int arg_x, const int arg_y);
			Node(const int arg_x, const int arg_y, const int arg_id);
			int getX() const;
			int getY() const;
			int getId() const;
			float abs() const;
			friend float distance(const Node& node1, const Node& node2);
			Node operator - (const Node& node) const;
			friend std::ofstream& operator << (std::ofstream& out, const Node& node);
	};
}
