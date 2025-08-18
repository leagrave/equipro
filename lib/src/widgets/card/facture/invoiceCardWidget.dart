import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/widgets/search/selectedComboCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/widgets/search/selectedDateField.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class InvoiceCardWidget extends StatefulWidget {
  final Invoice invoice;
  final Function(Invoice) onInvoiceUpdated;
  final bool isEditing;

  const InvoiceCardWidget({
    Key? key,
    required this.invoice,
    required this.onInvoiceUpdated,
    this.isEditing = true,
  }) : super(key: key);

  @override
  InvoiceCardWidgetState createState() => InvoiceCardWidgetState();
}

class InvoiceCardWidgetState extends State<InvoiceCardWidget> {
  late Invoice _invoice;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _numberController;
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  DateTime? _issueDate;
  DateTime? _dueDate;

  final List<String> paymentTypes = ['Carte', 'Chèque', 'Espèces', 'Virement'];
  final List<String> statusOptions = ['En attente', 'Payée', 'Annulée'];


  bool get _isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _invoice = widget.invoice;

    // Génère un numéro de facture aléatoire si vide
    final randomNumber = Random().nextInt(90000) + 10000;
    final generatedNumber = 'INV-${DateTime.now().year}-$randomNumber';

    _numberController = TextEditingController(
      text: _invoice.number.isEmpty ? generatedNumber : _invoice.number,
    );
    _titleController = TextEditingController(text: _invoice.title);
    _amountController = TextEditingController(text: _invoice.totalAmount.toString());

    _issueDate = _invoice.issueDate ?? DateTime.now();
    _dueDate = _invoice.dueDate ?? _issueDate!.add(const Duration(days: 60));
  }

  @override
  void dispose() {
    _numberController.dispose();
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Style text field façon exemple
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool readOnly = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly || !enabled,
        enabled: enabled,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }

  Future<bool> validateForm() async {
    if (_dueDate != null && _issueDate != null && _dueDate!.isBefore(_issueDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La date d\'échéance doit être après la date de création.')),
      );
      return false;
    }
    return _formKey.currentState?.validate() ?? false;
  }

  void _onFieldChanged() {
    final updated = _invoice.copyWith(
      number: _numberController.text,
      title: _titleController.text,
      totalAmount: double.tryParse(_amountController.text) ?? 0.0,
      issueDate: _issueDate,
      dueDate: _dueDate,
    );
    widget.onInvoiceUpdated(updated);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              "Numéro de facture",
              _numberController,
              Icons.confirmation_number,
              readOnly: true,
              enabled: false,
            ),
            _buildTextField(
              "Titre",
              _titleController,
              Icons.title,
              enabled: _isEditing,
              validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
              onChanged: (_) => _onFieldChanged(),
            ),
            _buildTextField(
              "Montant total",
              _amountController,
              Icons.euro,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Champ requis';
                final amount = double.tryParse(value);
                if (amount == null) return 'Montant invalide';
                return null;
              },
              onChanged: (_) => _onFieldChanged(),
            ),
            const SizedBox(height: 12),
            // Date de création
            SelectedDateField(
              label: "Date de création",
              selectedDate: _issueDate,
              enabled: _isEditing,
              onDateSelected: (date) {
                setState(() {
                  _issueDate = date;
                  if (_dueDate == null || _dueDate!.isBefore(_issueDate!)) {
                    _dueDate = _issueDate!.add(const Duration(days: 60));
                  }
                  _onFieldChanged();
                });
              },
            ),
            const SizedBox(height: 12),
            // Date d'échéance
            SelectedDateField(
              label: "Date d'échéance",
              selectedDate: _dueDate,
              enabled: _isEditing,
              onDateSelected: (date) {
                setState(() {
                  _dueDate = date;
                  _onFieldChanged();
                });
              },
            ),
            const SizedBox(height: 12),

            GenericComboCardWidget<String>(
              itemList: paymentTypes,
              selectedItem: _invoice.paymentType,
              label: "Type de paiement",
              hintText: "Sélectionner un type de paiement",
              itemLabelBuilder: (item) => item,
              isEditing: _isEditing,
              backgroundColor: Constants.white,
              textColor: Constants.appBarBackgroundColor,
              onChanged: (value) {
                setState(() {
                  _invoice = _invoice.copyWith(paymentType: value);
                  widget.onInvoiceUpdated(_invoice);
                });
              },
              onAddPressed: null, 
            ),
            const SizedBox(height: 12),

            GenericComboCardWidget<String>(
              itemList: statusOptions,
              selectedItem: _invoice.status,
              label: "Statut",
              hintText: "Sélectionner un statut",
              itemLabelBuilder: (item) => item,
              isEditing: _isEditing,
              backgroundColor: Constants.white,
              textColor: Constants.appBarBackgroundColor,
              onChanged: (value) {
                setState(() {
                  _invoice = _invoice.copyWith(status: value);
                  widget.onInvoiceUpdated(_invoice);
                });
              },
              onAddPressed: null, 
              
            ),
            const SizedBox(height: 12),

            // Switch pour "Facture payée"
            SwitchListTile(
              title: const Text('Facture payée', style: TextStyle(color: Colors.white)),
              value: _invoice.isPaid ?? false,
              onChanged: _isEditing
                  ? (val) {
                      setState(() {
                        _invoice = _invoice.copyWith(isPaid: val);
                        widget.onInvoiceUpdated(_invoice);
                      });
                    }
                  : null,
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
            ),

            // Switch pour "Société"
            SwitchListTile(
              title: const Text('Société', style: TextStyle(color: Colors.white)),
              value: _invoice.isCompany ?? false,
              onChanged: _isEditing
                  ? (val) {
                      setState(() {
                        _invoice = _invoice.copyWith(isCompany: val);
                        widget.onInvoiceUpdated(_invoice);
                      });
                    }
                  : null,
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
            ),

            const SizedBox(height: 12),

            AddressCardWidget(
              addresses: _invoice.billingAddress != null ? [_invoice.billingAddress!] : [],
              openWithCreateClientPage: false,
              openWithCreateHorsePage: false,
              openWithManagementHorsePage: false,
              onAdresseChanged: (addresses) {
                setState(() {
                  _invoice = _invoice.copyWith(billingAddress: addresses.isNotEmpty ? addresses.first : null);
                  widget.onInvoiceUpdated(_invoice);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}