import 'package:flutter_test/flutter_test.dart';
import 'package:retech/main.dart';
import 'package:retech/providers/farm_provider.dart';
import 'package:retech/providers/cattle_provider.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    final farmProvider = FarmProvider();
    final cattleProvider = CattleProvider();
    
    await tester.pumpWidget(MyApp(
      farmProvider: farmProvider,
      cattleProvider: cattleProvider,
    ));

    // Verify that the app starts with the HomeScreen
    expect(find.text('Gerenciamento de Gado'), findsOneWidget);
    expect(find.text('Nenhuma fazenda cadastrada.'), findsOneWidget);
  });
}
