#pragma once

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <map>
#include <string>

namespace parameter {
	class Parameter {
		private:
			std::map<std::string, std::string> parameters;
			void loadFromFile(const std::string filename);
			void loadFromIfstream(std::ifstream &ifs);

		public:
			Parameter(const std::string filename);
			bool contains(const std::string key);

			template <class T>
				T returnValue(std::string key);

			template <class T>
				T get(std::string key);

			template <class T>
				T get(std::string key, T value);
	};

	Parameter::Parameter(const std::string filename) {
		loadFromFile(filename);
	}

	bool Parameter::contains(const std::string key) {
		return parameters.contains(key);
	}

	void Parameter::loadFromFile(const std::string filename) {
		std::ifstream file(filename);

		if(file.fail()) {
			std::cerr << "ERROR: Can not open file \"" << filename << '"' << std::endl;
			std::abort();
		}

		loadFromIfstream(file);

		return;
	}

	void Parameter::loadFromIfstream(std::ifstream &ifs) {
		std::string line;

		while(getline(ifs, line)) {
			line.erase(std::remove_if(line.begin(), line.end(), ::isspace), line.end());

			if(!line.length() or line.at(0) == '#') continue;

			size_t eq_ind = line.find('=');

			if(eq_ind != std::string::npos) {
				std::string key = line.substr(0, eq_ind);
				std::string value = line.substr(eq_ind + 1, line.length());
				parameters.insert(std::make_pair(key, value));
			}
		}
	}

	template <class T>
		T Parameter::get(std::string key) {
			if(!parameters.contains(key)) {
				std::cerr << "ERROR: No such key \"" << key << '"' << std::endl;
				std::abort();
			}
			return returnValue<T>(key);
		}

	template <class T>
		T Parameter::get(std::string key, T value) {
			if(!parameters.contains(key)) {
				return value;
			}
			return returnValue<T>(key);
		}

	template <class T>
		T Parameter::returnValue(std::string key) {
			return parameters[key];
		}

	template<>
		bool Parameter::returnValue(std::string key) {
			std::string str = parameters[key];
			std::transform(str.begin(), str.end(), str.begin(), toupper);

			if(str == "true") {
				return true;
			}
			else {
				return false;
			}
		}

	template<>
		long Parameter::returnValue(std::string key) {
			return std::stol(parameters[key]);
		}

	template<>
		int Parameter::returnValue(std::string key) {
			return std::stoi(parameters[key]);
		}

	template<>
		double Parameter::returnValue(std::string key) {
			return std::stod(parameters[key]);
		}

	template<>
		float Parameter::returnValue(std::string key) {
			return std::stof(parameters[key]);
		}
}
