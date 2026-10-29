import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multiherramientas/services/api.dart';

void main() {
  test('Decodifica UTF-8 y maneja errores HTTP', () async {
    final client = MockClient(
      (request) async => http.Response(
        '{"name":"José"}',
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    );
    final data = await getJson(Uri.https('example.com'), client: client);
    expect(data['name'], 'José');
    client.close();
    for (final status in [404, 429, 500]) {
      final failingClient = MockClient((_) async => http.Response('', status));
      await expectLater(
        getJson(Uri.https('example.com'), client: failingClient),
        throwsA(isA<ApiException>()),
      );
      failingClient.close();
    }
  });
  test('Limpia HTML y entidades de WordPress', () {
    expect(
      cleanHtml(
        '<p>Hola &amp; adiós &#8217; <b>mundo</b></p><script>bad()</script>',
      ),
      'Hola & adiós ’ mundo',
    );
  });
  test('Interpreta clima y fechas de la API', () {
    expect(weatherLabel(95), 'Tormenta eléctrica');
    expect(weatherLabel(null), 'Estado no disponible');
    expect(dateLabel('2026-10-28T21:00'), '28/10/2026');
  });
}
