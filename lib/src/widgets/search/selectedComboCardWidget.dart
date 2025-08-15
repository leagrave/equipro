import 'package:flutter/material.dart';

class SelectedComboCardWidget<T> extends StatefulWidget {
  final String title;
  final List<T> itemList;
  final T? selectedItem;
  final String Function(T) itemLabelBuilder;
  final void Function(T?) onItemChanged;
  final VoidCallback onAddPressed;
  final Color backgroundColor;
  final Color textColor;
  final String? hintText;

  const SelectedComboCardWidget({
    required this.title,
    required this.itemList,
    required this.selectedItem,
    required this.itemLabelBuilder,
    required this.onItemChanged,
    required this.onAddPressed,
    this.backgroundColor = const Color(0x33000000), 
    this.textColor = Colors.white,
    this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  SelectedComboCardWidgetState<T> createState() =>
      SelectedComboCardWidgetState<T>();
}

class SelectedComboCardWidgetState<T> extends State<SelectedComboCardWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: widget.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<T?>(
                          value: widget.selectedItem,
                          hint: Text(
                            widget.hintText ?? "Sélectionner un élément",
                            style: TextStyle(color: widget.textColor),
                          ),
                          isExpanded: true,
                          dropdownColor: widget.backgroundColor,
                          iconEnabledColor: widget.textColor,
                          style: TextStyle(color: widget.textColor, fontSize: 16),
                          items: [
                            DropdownMenuItem<T?>(
                              value: null,
                              child: Text(
                                "Aucune",
                                style: TextStyle(color: widget.textColor),
                              ),
                            ),
                            ...widget.itemList.map((item) {
                              return DropdownMenuItem<T?>(
                                value: item,
                                child: Text(
                                  widget.itemLabelBuilder(item),
                                  style: TextStyle(color: widget.textColor),
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: widget.onItemChanged,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.add, color: widget.textColor),
                    onPressed: widget.onAddPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
