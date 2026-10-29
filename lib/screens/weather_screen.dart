import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/common.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<dynamic> _future;
  @override
  void initState() {
    super.initState();
    _future = _request();
  }

  Future<dynamic> _request() => getJson(
    Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '18.4861',
      'longitude': '-69.9312',
      'current': 'temperature_2m,weather_code',
      'daily': 'temperature_2m_max,temperature_2m_min',
      'timezone': 'America/Santo_Domingo',
      'forecast_days': '1',
    }),
  );
  void _reload() => setState(() => _future = _request());
  String _temperature(dynamic value) =>
      value is num ? '${value.toStringAsFixed(1)} °C' : 'No disponible';
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Text('Santo Domingo', style: Theme.of(context).textTheme.headlineSmall),
      const Text('República Dominicana · America/Santo_Domingo'),
      ResultView(
        future: _future,
        onRetry: _reload,
        builder: (data) {
          final current = data['current'];
          final daily = data['daily'];
          final days = daily?['time'] as List? ?? [];
          if (current == null || days.isEmpty) {
            return const InfoCard(
              child: Text('No hay datos del clima disponibles.'),
            );
          }
          final maximum = daily?['temperature_2m_max'] as List? ?? [];
          final minimum = daily?['temperature_2m_min'] as List? ?? [];
          return InfoCard(
            color: const Color(0xFFE9F2FA),
            child: Column(
              children: [
                Text('Hoy · ${dateLabel(days.first.toString())}'),
                const SizedBox(height: 20),
                const Icon(Icons.cloud_outlined, size: 64),
                Text(
                  _temperature(current['temperature_2m']),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  weatherLabel(current['weather_code'] as int?),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Máxima: ${_temperature(maximum.isEmpty ? null : maximum.first)}',
                ),
                Text(
                  'Mínima: ${_temperature(minimum.isEmpty ? null : minimum.first)}',
                ),
                const SizedBox(height: 12),
                Text(
                  'Actualización: ${current['time']?.toString().replaceFirst('T', ' ') ?? 'No disponible'}',
                ),
              ],
            ),
          );
        },
      ),
      OutlinedButton.icon(
        onPressed: _reload,
        icon: const Icon(Icons.refresh),
        label: const Text('Actualizar clima'),
      ),
      TextButton(
        onPressed: () => openLink(context, 'https://open-meteo.com/'),
        child: const Text('Datos meteorológicos: Open-Meteo'),
      ),
    ],
  );
}
