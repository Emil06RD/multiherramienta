import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/common.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});
  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _name = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _audio = AudioPlayer();
  Future<dynamic>? _future;
  bool _playing = false;
  void _search() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(
      () => _future = getJson(
        Uri.https(
          'pokeapi.co',
          '/api/v2/pokemon/${_name.text.trim().toLowerCase()}',
        ),
      ),
    );
  }

  Future<void> _play(String url) async {
    setState(() => _playing = true);
    try {
      await _audio.play(UrlSource(url)).timeout(const Duration(seconds: 15));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo reproducir el sonido. Revisa tu conexión e intenta de nuevo.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('Busca un Pokémon y escucha su sonido.'),
      const SizedBox(height: 20),
      Form(
        key: _form,
        child: TextFormField(
          controller: _name,
          validator: (value) {
            if (requiredText(value) != null) {
              return 'Escribe el nombre de un Pokémon.';
            }
            if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value!.trim())) {
              return 'Usa el nombre en inglés, sin espacios ni acentos.';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Pokémon',
            hintText: 'Ej.: Pikachu',
          ),
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (_) => _search(),
        ),
      ),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: _search,
        icon: const Icon(Icons.search),
        label: const Text('Buscar Pokémon'),
      ),
      ResultView(
        future: _future,
        onRetry: _search,
        builder: (data) {
          if (data is! Map || data['name'] == null) {
            return const InfoCard(child: Text('No hay datos de ese Pokémon.'));
          }
          final image =
              data['sprites']?['other']?['official-artwork']?['front_default'] ??
              data['sprites']?['front_default'];
          final cry = data['cries']?['latest'] as String?;
          final abilities = data['abilities'] as List? ?? [];
          return InfoCard(
            color: const Color(0xFFFFF4D9),
            child: Column(
              children: [
                Text(
                  data['name'].toString().toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                RemoteImage(
                  url: image,
                  size: 190,
                  icon: Icons.catching_pokemon,
                ),
                Text(
                  'Experiencia base: ${data['base_experience'] ?? 'No disponible'}',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Habilidades',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (abilities.isEmpty) const Text('No disponibles'),
                for (final ability in abilities)
                  Text(
                    ability['ability']?['name']?.toString().replaceAll(
                          '-',
                          ' ',
                        ) ??
                        'No disponible',
                  ),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: cry == null || cry.isEmpty || _playing
                      ? null
                      : () => _play(cry),
                  icon: const Icon(Icons.volume_up),
                  label: Text(
                    _playing ? 'Cargando sonido…' : 'Reproducir sonido',
                  ),
                ),
                if (cry == null || cry.isEmpty)
                  const Text('Este Pokémon no tiene sonido disponible.'),
              ],
            ),
          );
        },
      ),
    ],
  );
}
