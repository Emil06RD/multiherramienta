import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/common.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<dynamic> _future;
  @override
  void initState() {
    super.initState();
    _future = getJson(Uri.parse(wordpressApi));
  }

  void _reload() => setState(() => _future = getJson(Uri.parse(wordpressApi)));
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Row(
        children: [
          const RemoteImage(
            url: wordpressLogo,
            size: 56,
            icon: Icons.newspaper,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WordPress News',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text('Las 3 publicaciones más recientes'),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      const Text('Las publicaciones conservan el idioma original del sitio.'),
      ResultView(
        future: _future,
        onRetry: _reload,
        builder: (data) {
          if (data is! List || data.isEmpty) {
            return const InfoCard(
              child: Text('No hay publicaciones disponibles.'),
            );
          }
          return Column(
            children: [
              for (final post in data.take(3))
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cleanHtml(post['title']?['rendered'] ?? ''),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(dateLabel(post['date'] ?? '')),
                      const SizedBox(height: 12),
                      Text(
                        cleanHtml(post['excerpt']?['rendered'] ?? '').isEmpty
                            ? 'Sin resumen disponible.'
                            : cleanHtml(post['excerpt']['rendered']),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonalIcon(
                        onPressed: post['link'] == null
                            ? null
                            : () => openLink(context, post['link']),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Visitar'),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      OutlinedButton.icon(
        onPressed: _reload,
        icon: const Icon(Icons.refresh),
        label: const Text('Actualizar noticias'),
      ),
    ],
  );
}
