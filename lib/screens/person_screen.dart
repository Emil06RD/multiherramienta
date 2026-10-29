import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/common.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});
  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  late Future<dynamic> _future;
  @override
  void initState() {
    super.initState();
    _future = _request();
  }

  Future<dynamic> _request() =>
      getJson(Uri.https('randomuser.me', '/api/', {'results': '1'}));
  void _reload() => setState(() => _future = _request());
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('Perfiles de prueba generados por Random User.'),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: _reload,
        icon: const Icon(Icons.refresh),
        label: const Text('Generar otra persona'),
      ),
      ResultView(
        future: _future,
        onRetry: _reload,
        builder: (data) {
          final people = data['results'] as List? ?? [];
          if (people.isEmpty) {
            return const InfoCard(
              child: Text('No se recibió ninguna persona.'),
            );
          }
          final person = people.first;
          return InfoCard(
            child: Column(
              children: [
                ClipOval(
                  child: RemoteImage(
                    url: person['picture']?['large'],
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${person['name']?['first'] ?? ''} ${person['name']?['last'] ?? ''}',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text('Nacimiento: ${dateLabel(person['dob']?['date'] ?? '')}'),
                Text('Edad: ${person['dob']?['age'] ?? 'No disponible'} años'),
              ],
            ),
          );
        },
      ),
    ],
  );
}
