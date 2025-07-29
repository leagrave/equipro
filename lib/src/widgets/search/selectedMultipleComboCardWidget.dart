import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SelectedComboCardWidget<T> extends StatelessWidget {
  final String title;
  final List<T> itemList;
  final List<T> selectedItems;
  final String Function(T) itemLabelBuilder;
  final void Function(T?) onItemSelected;
  final bool showDropdown;
  final VoidCallback onDropdownCancel;
  final void Function(T) onRemoveItem;
  final String searchHintText;
  final VoidCallback onAddPressed;
  final bool? readOnly;

  const SelectedComboCardWidget({
    required this.title,
    required this.itemList,
    required this.selectedItems,
    required this.itemLabelBuilder,
    required this.onItemSelected,
    required this.onAddPressed,
    required this.showDropdown,
    required this.onDropdownCancel,
    required this.onRemoveItem,
    required this.searchHintText,
    required this.readOnly,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne titre + bouton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
              ),
              if (readOnly != true)
              IconButton(
                icon: Icon(
                  showDropdown ? Icons.close : Icons.add,
                  color: Colors.white,
                ),
                onPressed: onAddPressed,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Liste des éléments sélectionnés
          ...selectedItems.map((item) => Padding(
                key: ValueKey(itemLabelBuilder(item)),
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        initialValue: itemLabelBuilder(item),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    if (readOnly != true)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () => onRemoveItem(item),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 8),

          // Dropdown si visible
          if (showDropdown)
            DropdownSearch<T>(
              items: itemList,
              itemAsString: itemLabelBuilder,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: searchHintText,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Recherche...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(itemLabelBuilder(item)),
                ),
              ),
              onChanged: onItemSelected,
            ),
        ],
      ),
    );
  }
}
