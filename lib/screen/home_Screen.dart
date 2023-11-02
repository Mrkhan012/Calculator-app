import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Calculator extends StatelessWidget {
  final calculatorController = Get.put(CalculatorController());

  Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: const Text('Calculator'),
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Obx(() => Text(
                        calculatorController.displayText.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('AC', Colors.grey, Colors.black, () {
                    calculatorController.calculation('AC');
                  }),
                  calcButton('+/-', Colors.grey, Colors.black, () {
                    calculatorController.calculation('+/-');
                  }),
                  calcButton('%', Colors.grey, Colors.black, () {
                    calculatorController.calculation('%');
                  }),
                  calcButton('/', Colors.amber[900]!, Colors.white, () {
                    calculatorController.calculation('/');
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  calcButton('7', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('7');
                  }),
                  calcButton('8', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('8');
                  }),
                  calcButton('9', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('9');
                  }),
                  calcButton('x', Colors.amber[900]!, Colors.white, () {
                    calculatorController.calculation('x');
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  calcButton('4', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('4');
                  }),
                  calcButton('5', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('5');
                  }),
                  calcButton('6', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('6');
                  }),
                  calcButton('-', Colors.amber[900]!, Colors.white, () {
                    calculatorController.calculation('-');
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  calcButton('1', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('1');
                  }),
                  calcButton('2', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('2');
                  }),
                  calcButton('3', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('3');
                  }),
                  calcButton('+', Colors.amber[900]!, Colors.white, () {
                    calculatorController.calculation('+');
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  calcButton('0', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('0');
                  }),
                  calcButton('.', Colors.grey[850]!, Colors.white, () {
                    calculatorController.calculation('.');
                  }),
                  calcButton('=', Colors.amber[900]!, Colors.white, () {
                    calculatorController.calculation('=');
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget calcButton(String buttonText, Color buttonColor, Color textColor,
      VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(buttonColor),
          padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 30,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class CalculatorController extends GetxController {
  var displayText = '0'.obs;
  double numOne = 0;
  double numTwo = 0;
  String result = '';
  String finalResult = '';
  String operator = '';
  String previousOperator = '';

  void calculation(String buttonText) {
    if (buttonText == 'AC') {
      displayText.value = '0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      operator = '';
      previousOperator = '';
    } else if (operator == '=' && buttonText == '=') {
      if (previousOperator == '+') {
        finalResult = add();
      } else if (previousOperator == '-') {
        finalResult = subtract();
      } else if (previousOperator == 'x') {
        finalResult = multiply();
      } else if (previousOperator == '/') {
        finalResult = divide();
      }
    } else if (buttonText == '+' ||
        buttonText == '-' ||
        buttonText == 'x' ||
        buttonText == '/' ||
        buttonText == '=') {
      if (numOne == 0) {
        numOne = parseDouble(result);
      } else {
        numTwo = parseDouble(result);
      }

      if (operator == '+') {
        finalResult = add();
      } else if (operator == '-') {
        finalResult = subtract();
      } else if (operator == 'x') {
        finalResult = multiply();
      } else if (operator == '/') {
        finalResult = divide();
      }
      previousOperator = operator;
      operator = buttonText;
      result = '';
    } else if (buttonText == '%') {
      result = (numOne / 100).toString();
      finalResult = removeDecimalIfZero(result);
    } else if (buttonText == '.') {
      if (!result.toString().contains('.')) {
        result = '$result.';
      }
      finalResult = result;
    } else if (buttonText == '+/-') {
      result.startsWith('-')
          ? result = result.substring(1)
          : result = '-$result';
      finalResult = result;
    } else {
      result = result + buttonText;
      finalResult = result;
    }

    displayText.value = finalResult;
  }

  double parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0;
    }
  }

  String add() {
    result = (numOne + numTwo).toString();
    numOne = parseDouble(result);
    return removeDecimalIfZero(result);
  }

  String subtract() {
    result = (numOne - numTwo).toString();
    numOne = parseDouble(result);
    return removeDecimalIfZero(result);
  }

  String multiply() {
    result = (numOne * numTwo).toString();
    numOne = parseDouble(result);
    return removeDecimalIfZero(result);
  }

  String divide() {
    result = (numOne / numTwo).toString();
    numOne = parseDouble(result);
    return removeDecimalIfZero(result);
  }

  String removeDecimalIfZero(String result) {
    if (result.contains('.')) {
      List<String> splitDecimal = result.split('.');
      if (int.parse(splitDecimal[1]) == 0) {
        return splitDecimal[0];
      }
    }
    return result;
  }
}
