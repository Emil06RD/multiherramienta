import 'package:flutter/material.dart';

import '../widgets/common.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      InfoCard(
        child: Column(
          children: [
            Image.asset(
              'assets/images/herramientas.png',
              height: 150,
              errorBuilder: (_, error, stack) =>
                  const Icon(Icons.home_repair_service, size: 120),
            ),
            const SizedBox(height: 16),
            Text(
              'MultiHerramientas',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Un poco de todo, en un solo lugar.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          '¿Qué quieres explorar hoy?',
          style: TextStyle(fontSize: 18),
        ),
      ),
      for (var i = 1; i < pageTitles.length; i++)
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Icon(pageIcons[i]),
            title: Text(pageTitles[i]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openPage(context, i),
          ),
        ),
    ],
  );
}
