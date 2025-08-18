import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/widgets/search/selectedMultipleComboCardWidget.dart';

void main() {
  testWidgets('SelectedMultipleComboCardWidget affiche les éléments et réagit aux actions', (WidgetTester tester) async {
    // Données de test
    final items = ['A', 'B', 'C'];
    final selected = ['A'];
    String? selectedFromDropdown;
    String? removedItem;
    bool addPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectedMultipleComboCardWidget<String>(
            title: 'Test Title',
            itemList: items,
            selectedItems: selected,
            itemLabelBuilder: (item) => item,
            onItemSelected: (item) => selectedFromDropdown = item,
            onAddPressed: () => addPressed = true,
            showDropdown: false,
            onDropdownCancel: () {},
            onRemoveItem: (item) => removedItem = item,
            searchHintText: 'Rechercher...',
            readOnly: false,
          ),
        ),
      ),
    );

    // Vérifie la présence du titre
    expect(find.text('Test Title'), findsOneWidget);

    // Vérifie la présence de l'élément sélectionné
    expect(find.text('A'), findsOneWidget);

    // Vérifie la présence du bouton d'ajout
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Clique sur le bouton d'ajout
    await tester.tap(find.byIcon(Icons.add));
    expect(addPressed, isTrue);

    // Clique sur le bouton de suppression de l'élément sélectionné
    await tester.tap(find.byIcon(Icons.close).last);
    expect(removedItem, 'A');
  });
}