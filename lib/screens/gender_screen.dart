import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/common.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});
  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final _name = TextEditingController();
  final _form = GlobalKey<FormState>();
  Future<dynamic>? _future;
  void _search() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(
      () => _future = getJson(
        Uri.https('api.genderize.io', '/', {'name': _name.text.trim()}),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text(
        'Consulta una predicción estadística a partir de un nombre. No determina la identidad de una persona.',
      ),
      const SizedBox(height: 20),
      Form(
        key: _form,
        child: TextFormField(
          controller: _name,
          validator: requiredText,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ej.: Irma',
          ),
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (_) => _search(),
        ),
      ),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: _search,
        icon: const Icon(Icons.search),
        label: const Text('Consultar'),
      ),
      ResultView(
        future: _future,
        onRetry: _search,
        builder: (data) {
          final gender = data['gender'];
          if (gender != 'male' && gender != 'female') {
            return const InfoCard(
              child: Text(
                'No hay una predicción para ese nombre. Prueba con otro.',
              ),
            );
          }
          final probability = data['probability'] as num?;
          return InfoCard(
            color: gender == 'male' ? Colors.blue.shade50 : Colors.pink.shade50,
            child: Column(
              children: [
                Text(
                  data['name'] ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  gender == 'male' ? 'Masculino (male)' : 'Femenino (female)',
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  'Probabilidad: ${probability == null ? 'No disponible' : '${(probability * 100).toStringAsFixed(1)} %'}',
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}
