import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/common.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});
  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final _country = TextEditingController(text: 'Dominican Republic');
  final _form = GlobalKey<FormState>();
  Future<dynamic>? _future;
  void _search() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // Uri.https codifica automáticamente los espacios del país.
    setState(
      () => _future = getJson(
        Uri.https('adamix.net', '/proxy.php', {
          'country': _country.text.trim(),
        }),
      ),
    );
  }

  @override
  void dispose() {
    _country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('Escribe el país en inglés para buscar sus universidades.'),
      const SizedBox(height: 20),
      Form(
        key: _form,
        child: TextFormField(
          controller: _country,
          validator: requiredText,
          decoration: const InputDecoration(
            labelText: 'País en inglés',
            hintText: 'Dominican Republic',
          ),
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (_) => _search(),
        ),
      ),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: _search,
        icon: const Icon(Icons.search),
        label: const Text('Buscar universidades'),
      ),
      ResultView(
        future: _future,
        onRetry: _search,
        builder: (data) {
          if (data is! List) {
            return const InfoCard(
              child: Text(
                'El servicio devolvió una respuesta inesperada. Intenta más tarde.',
              ),
            );
          }
          if (data.isEmpty) {
            return const InfoCard(
              child: Text(
                'No se encontraron universidades. Revisa el país en inglés.',
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${data.length} universidades encontradas'),
              for (final university in data)
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        university['name'] ?? 'Nombre no disponible',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dominio: ${(university['domains'] as List? ?? []).join(', ')}',
                      ),
                      for (final url in university['web_pages'] as List? ?? [])
                        TextButton.icon(
                          onPressed: () => openLink(context, url.toString()),
                          icon: const Icon(Icons.open_in_new),
                          label: Text(
                            url.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if ((university['web_pages'] as List? ?? []).isEmpty)
                        const Text('Sin enlace web disponible.'),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    ],
  );
}
