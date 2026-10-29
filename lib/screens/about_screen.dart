import 'package:flutter/material.dart';
import '../widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _contact(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String url,
  ) => Card(
    child: ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.open_in_new, size: 20),
      onTap: () => openLink(context, url),
    ),
  );

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      InfoCard(
        child: Column(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/perfil.png',
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stack) => const SizedBox(
                  width: 140,
                  height: 140,
                  child: Icon(Icons.person, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Emil Montilla Salvador',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Estudiante de Desarrollo de Software',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Instituto Tecnológico de Las Américas (ITLA)',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Soy estudiante de Desarrollo de Software, interesado en crear aplicaciones, aprender nuevas tecnologías y mejorar mis habilidades de programación.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Icon(Icons.work_outline),
            const SizedBox(height: 8),
            const Text(
              'Abierto a oportunidades laborales y proyectos.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Text('Contacto', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      _contact(
        context,
        Icons.email_outlined,
        'Correo',
        'emil.montillard@gmail.com',
        'mailto:emil.montillard@gmail.com',
      ),
      _contact(
        context,
        Icons.phone_outlined,
        'Teléfono',
        '8097193549',
        'tel:8097193549',
      ),
      _contact(
        context,
        Icons.code,
        'GitHub',
        'https://github.com/Emil06RD',
        'https://github.com/Emil06RD',
      ),
    ],
  );
}

