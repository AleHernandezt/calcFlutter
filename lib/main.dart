import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _expression = '0';

  void _onButtonPressed(String label) {
    setState(() {
      if (label == 'C') {
        _expression = '0';
      } else if (label == '=') {
        try {
          _expression = _calculateResult(_expression).toString();
        } catch (e) {
          _expression = 'Error';
        }
      } else {
        if (_expression == '0') {
          _expression = label;
        } else {
          _expression += label;
        }
      }
    });
  }

  double _calculateResult(String expression) {
    // Reemplazar la coma por un punto
    expression = expression.replaceAll(',', '.');

    // Evaluar la expresión
    try {
      return _simpleEval(expression);
    } catch (e) {
      throw Exception('Error al evaluar la expresión');
    }
  }

  double _simpleEval(String expression) {
    // Asegurarse de que la expresión no esté vacía
    if (expression.isEmpty) {
      throw Exception('Expresión vacía');
    }

    // Dividir la expresión en partes (números y operadores)
    final parts = expression
        .split(RegExp(r'(\+|\-|\*|\/)'))
        .map((part) => part.trim())
        .toList();

    // Comprobar que la expresión tenga al menos un número
    if (parts.isEmpty || parts.length < 3) {
      throw Exception('Expresión inválida');
    }

    double result = double.parse(parts[0]);

    for (int i = 1; i < parts.length; i += 2) {
      final operator = parts[i];
      final nextValue = double.parse(parts[i + 1]);

      switch (operator) {
        case '+':
          result += nextValue;
          break;
        case '-':
          result -= nextValue;
          break;
        case '*':
          result *= nextValue;
          break;
        case '/':
          if (nextValue == 0) {
            throw Exception('División por cero');
          }
          result /= nextValue;
          break;
        default:
          throw Exception('Operador desconocido');
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.grey[800], // Color de fondo del AppBar
      ),
      body: Column(
        children: [
          // Campo para mostrar los números
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white, // Color de fondo del campo
            child: Text(
              _expression, // Aquí se puede mostrar el resultado
              style: const TextStyle(
                fontSize: 48,
                color: Colors.black, // Color del texto
              ),
            ),
          ),
          const SizedBox(height: 10), // Espacio entre el campo y los botones
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Fila de botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('/'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('*'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton('C'), // Botón para limpiar
                    _buildButton('0'),
                    _buildButton('='),
                    _buildButton('+'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(label),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Colors.grey[300],
          minimumSize: const Size(64, 64), // Color del texto del botón
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
