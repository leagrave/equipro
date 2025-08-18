import 'package:flutter/material.dart';

class GenericComboCardWidget<T> extends StatelessWidget {
  final List<T> itemList;
  final T? selectedItem;
  final String label;
  final String hintText;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final VoidCallback? onAddPressed;
  final bool isEditing;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? iconColor;
  final Color? textColor;

  const GenericComboCardWidget({
    required this.itemList,
    required this.selectedItem,
    required this.label,
    required this.hintText,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.onAddPressed,
    this.isEditing = true,
    this.backgroundColor,
    this.labelColor,
    this.iconColor,
    this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _background = backgroundColor ?? Colors.white.withOpacity(0.2);
    final Color _label = labelColor ?? Colors.white;
    final Color _icon = iconColor ?? Colors.white;
    final Color _text = textColor ?? Colors.white;

    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: _label,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<T?>(
                        value: selectedItem,
                        hint: Text(
                          hintText,
                          style: TextStyle(color: _text),
                        ),
                        isExpanded: true,
                        dropdownColor: _background,
                        iconEnabledColor: _icon,
                        style: TextStyle(color: _text, fontSize: 16),
                        items: [
                          DropdownMenuItem<T?>(
                            value: null,
                            child: Text("Aucune", style: TextStyle(color: _text)),
                          ),
                          ...itemList.map((item) {
                            return DropdownMenuItem<T?>(
                              value: item,
                              child: Text(itemLabelBuilder(item), style: TextStyle(color: _text)),
                            );
                          }).toList(),
                        ],
                        onChanged: isEditing ? onChanged : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isEditing && onAddPressed != null)
                  IconButton(
                    icon: Icon(Icons.add, color: _icon),
                    onPressed: onAddPressed,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}