#include "node.hpp"

namespace node {
	Node::Node() {};
	Node::Node(int arg_x, int arg_y) : x{arg_x}, y{arg_y} {};
	Node::Node(int arg_x, int arg_y, int arg_id) : x{arg_x}, y{arg_y}, id{arg_id} {};

	int Node::getX() const {
		return this->x;
	}

	int Node::getY() const {
		return this->y;
	}

	int Node::getId() const {
		return this->id;
	}

	float Node::abs() const {
		return std::sqrt(std::pow(this->x, 2) + std::pow(this->y, 2));
	}

	float distance(const Node& node1, const Node& node2) {
		return (node1 - node2).abs();
	}

	Node Node::operator - (const Node& node) const {
		return Node(this->x - node.getX(), this->y - node.getY());
	}

	std::ofstream& operator << (std::ofstream& out, const Node& node) {
		out << node.getX() << ", " << node.getY() << std::endl;
		return out;
	}
}
