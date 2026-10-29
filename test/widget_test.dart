import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiherramientas/main.dart';

void main() {
  testWidgets('Inicio navega a Género, valida y abre Acerca de desde Drawer', (
    tester,
  ) async {
    await tester.pumpWidget(const MultiHerramientasApp());
    await tester.pumpAndSettle();
    expect(find.text('MultiHerramientas'), findsNWidgets(2));
    await tester.tap(find.text('Género'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Consultar'));
    await tester.pumpAndSettle();
    expect(find.text('Completa este campo.'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Acerca de'),
      200,
      scrollable: find.descendant(
        of: find.byType(Drawer),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Acerca de'));
    await tester.pumpAndSettle();
    expect(find.text('Emil Montilla Salvador'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
