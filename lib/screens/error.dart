import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.errorMessage});
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Sunchaser'),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  color: Color.fromRGBO(255, 179, 0, 1),
                  size: 100,
                ),
                const SizedBox(height: 25),
                Text(
                  errorMessage, 
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                  )
              ],
            ),
          ),
    );
  }
}