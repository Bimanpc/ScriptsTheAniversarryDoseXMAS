#include <iostream>
#include <string>
#include <cmath>
#include <cctype>

class SciCalc {
public:
    double eval(const std::string& s) {
        expr = s;
        pos = 0;
        return parseExpression();
    }

private:
    std::string expr;
    size_t pos;

    void skip() {
        while (pos < expr.size() && isspace(expr[pos])) pos++;
    }

    bool match(char c) {
        skip();
        if (pos < expr.size() && expr[pos] == c) {
            pos++;
            return true;
        }
        return false;
    }

    double parseNumber() {
        skip();
        double result = 0;
        bool hasDecimal = false;
        double decimalFactor = 0.1;

        while (pos < expr.size() &&
               (isdigit(expr[pos]) || expr[pos] == '.')) {

            if (expr[pos] == '.') {
                hasDecimal = true;
                pos++;
                continue;
            }

            if (!hasDecimal) {
                result = result * 10 + (expr[pos] - '0');
            } else {
                result += (expr[pos] - '0') * decimalFactor;
                decimalFactor *= 0.1;
            }
            pos++;
        }
        return result;
    }

    double parseFunction() {
        skip();
        std::string name;

        while (pos < expr.size() && isalpha(expr[pos])) {
            name.push_back(expr[pos]);
            pos++;
        }

        double value = parseFactor();

        if (name == "sin") return sin(value);
        if (name == "cos") return cos(value);
        if (name == "tan") return tan(value);
        if (name == "log") return log10(value);
        if (name == "ln")  return log(value);
        if (name == "sqrt") return sqrt(value);

        std::cerr << "Unknown function: " << name << "\n";
        return value;
    }

    double parseFactor() {
        skip();

        if (match('(')) {
            double value = parseExpression();
            match(')');
            return value;
        }

        if (isalpha(expr[pos])) {
            return parseFunction();
        }

        return parseNumber();
    }

    double parsePower() {
        double base = parseFactor();
        while (match('^')) {
            double exponent = parseFactor();
            base = pow(base, exponent);
        }
        return base;
    }

    double parseTerm() {
        double value = parsePower();
        while (true) {
            if (match('*')) value *= parsePower();
            else if (match('/')) value /= parsePower();
            else break;
        }
        return value;
    }

    double parseExpression() {
        double value = parseTerm();
        while (true) {
            if (match('+')) value += parseTerm();
            else if (match('-')) value -= parseTerm();
            else break;
        }
        return value;
    }
};

int main() {
    SciCalc calc;
    std::string input;

    std::cout << "Scientific Calculator (C++)\n";
    std::cout << "Type 'exit' to quit\n\n";

    while (true) {
        std::cout << "> ";
        std::getline(std::cin, input);

        if (input == "exit") break;

        try {
            double result = calc.eval(input);
            std::cout << " = " << result << "\n";
        } catch (...) {
            std::cout << "Error evaluating expression\n";
        }
    }
    return 0;
}
