import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

const wordpressApi =
    'https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3&orderby=date&order=desc';
const wordpressLogo = 'https://s.w.org/images/wmark.png';

// Petición común con un tiempo de espera y mensajes comprensibles.
Future<dynamic> getJson(Uri uri, {http.Client? client}) async {
  try {
    final response = await (client == null ? http.get(uri) : client.get(uri))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 404) {
      throw const ApiException('No se encontró el resultado solicitado.');
    }
    if (response.statusCode == 429) {
      throw const ApiException(
        'Se alcanzó el límite de consultas. Intenta más tarde.',
      );
    }
    if (response.statusCode != 200) {
      throw ApiException(
        'El servicio no está disponible (${response.statusCode}). Intenta más tarde.',
      );
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  } on TimeoutException {
    throw const ApiException(
      'El servicio tardó demasiado. Vuelve a intentarlo.',
    );
  } on SocketException {
    throw const ApiException('No hay conexión a Internet. Revisa tu conexión.');
  } on http.ClientException {
    throw const ApiException(
      'No se pudo conectar. Revisa Internet e intenta de nuevo.',
    );
  } on HandshakeException {
    throw const ApiException('No se pudo establecer una conexión segura.');
  } on FormatException {
    throw const ApiException('El servicio devolvió una respuesta no válida.');
  }
}

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

String cleanHtml(String value) {
  final document = html.parse(value);
  for (final element in document.querySelectorAll('script, style')) {
    element.remove();
  }
  return (document.body?.text ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
}

String dateLabel(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return 'Fecha no disponible';
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String weatherLabel(int? code) => switch (code) {
  0 => 'Despejado',
  1 => 'Mayormente despejado',
  2 => 'Parcialmente nublado',
  3 => 'Nublado',
  45 || 48 => 'Niebla',
  51 || 53 || 55 => 'Llovizna',
  56 || 57 => 'Llovizna helada',
  61 || 63 || 65 => 'Lluvia',
  66 || 67 => 'Lluvia helada',
  71 || 73 || 75 || 77 => 'Nieve',
  80 || 81 || 82 => 'Chubascos',
  85 || 86 => 'Chubascos de nieve',
  95 => 'Tormenta eléctrica',
  96 || 99 => 'Tormenta con granizo',
  _ => 'Estado no disponible',
};
