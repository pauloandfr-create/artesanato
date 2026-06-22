import 'package:flutter_test/flutter_test.dart';

import 'package:artesanato_app/main.dart';

void main() {
  testWidgets('Mostra a tela de login ao iniciar o aplicativo',
      (WidgetTester tester) async {
    await tester.pumpWidget(const Aplicativo());

    expect(find.text('Tela de Login'), findsOneWidget);
    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
