import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/api.dart';

const pageTitles = [
  'Inicio',
  'Género',
  'Persona aleatoria',
  'Universidades',
  'Clima RD',
  'Pokémon',
  'Noticias',
  'Acerca de',
];
const pageRoutes = [
  '/',
  '/genero',
  '/persona',
  '/universidades',
  '/clima',
  '/pokemon',
  '/noticias',
  '/acerca',
];
const pageIcons = [
  Icons.home_outlined,
  Icons.people_outline,
  Icons.person_outline,
  Icons.school_outlined,
  Icons.cloud_outlined,
  Icons.catching_pokemon,
  Icons.newspaper,
  Icons.badge_outlined,
];

void openPage(BuildContext context, int index) {
  if (index == 0) {
    Navigator.popUntil(context, (route) => route.isFirst);
  } else {
    Navigator.pushNamedAndRemoveUntil(
      context,
      pageRoutes[index],
      (route) => route.isFirst,
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.index, required this.child});
  final int index;
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(index == 0 ? 'MultiHerramientas' : pageTitles[index]),
    ),
    drawer: Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.home_repair_service, size: 40),
                  SizedBox(height: 12),
                  Text(
                    'MultiHerramientas',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text('Proyecto de desarrollo móvil'),
                ],
              ),
            ),
            for (var i = 0; i < pageTitles.length; i++)
              ListTile(
                selected: i == index,
                leading: Icon(pageIcons[i]),
                title: Text(pageTitles[i]),
                onTap: () {
                  Navigator.pop(context);
                  if (i != index) openPage(context, i);
                },
              ),
          ],
        ),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: child,
        ),
      ),
    ),
  );
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.child, this.color});
  final Widget child;
  final Color? color;
  @override
  Widget build(BuildContext context) => Card(
    color: color,
    child: Padding(padding: const EdgeInsets.all(20), child: child),
  );
}

class ResultView extends StatelessWidget {
  const ResultView({
    super.key,
    required this.future,
    required this.onRetry,
    required this.builder,
  });
  final Future<dynamic>? future;
  final VoidCallback onRetry;
  final Widget Function(dynamic data) builder;
  @override
  Widget build(BuildContext context) {
    if (future == null) return const SizedBox.shrink();
    return FutureBuilder<dynamic>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          return InfoCard(
            child: Column(
              children: [
                const Icon(Icons.wifi_off_outlined, size: 32),
                const SizedBox(height: 12),
                Text(
                  error is ApiException
                      ? error.message
                      : 'No se pudo leer la respuesta del servicio.',
                  textAlign: TextAlign.center,
                ),
                TextButton(onPressed: onRetry, child: const Text('Reintentar')),
              ],
            ),
          );
        }
        if (!snapshot.hasData) {
          return const InfoCard(child: Text('No hay resultados disponibles.'));
        }
        return builder(snapshot.data);
      },
    );
  }
}

class RemoteImage extends StatelessWidget {
  const RemoteImage({
    super.key,
    required this.url,
    this.size = 140,
    this.icon = Icons.image_outlined,
  });
  final String? url;
  final double size;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final placeholder = SizedBox(
      width: size,
      height: size,
      child: Icon(icon, size: size / 2),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return Image.network(
      url!,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, error, stack) => placeholder,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : SizedBox(
              width: size,
              height: size,
              child: const Center(child: CircularProgressIndicator()),
            ),
    );
  }
}

String? requiredText(String? value) =>
    value == null || value.trim().isEmpty ? 'Completa este campo.' : null;

Future<void> openLink(BuildContext context, String value) async {
  final uri = Uri.tryParse(value.trim());
  try {
    if (uri == null ||
        !['http', 'https', 'mailto', 'tel'].contains(uri.scheme)) {
      throw const FormatException();
    }
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw const FormatException();
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo abrir el enlace. Comprueba la dirección y las aplicaciones instaladas.',
          ),
        ),
      );
    }
  }
}
