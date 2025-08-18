import 'dart:convert';

import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/card/client/clientsComboCardWidget.dart';
import 'package:equipro/src/widgets/card/facture/invoiceCardWidget.dart';
import 'package:equipro/src/widgets/card/intervention/horsesComboCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CreateInvoicePage extends StatefulWidget {
  final String proID;
  final String? customer_id;
  final String? userCustomerID;
  final String? horseID;
  final String? userId;

  const CreateInvoicePage({
    Key? key,
    required this.proID,
    this.customer_id,
    this.userCustomerID,
    this.horseID,
    this.userId,
  }) : super(key: key);

  @override
  _CreateInvoicePageState createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<InvoiceCardWidgetState> _invoiceCardKey = GlobalKey<InvoiceCardWidgetState>();
  final storage = const FlutterSecureStorage();

  List<Users> usersList = [];
  List<Users> filteredUsers = [];
  List<Users> selectedUsers = [];
  bool showDropdown = false;
  bool _isEditing = true;
  bool isLoading = true;
  bool isSaved = false;
  List<Horse> horseList = [];  
  Horse? selectedHorse; 
  List<Horse> horsesUsersList = [];
  String? proID;
  String? token;

  bool showHorseCard = false; 

  Horse newHorse = Horse(
    id: '',
    name: '',
  );


  Future<void> _loadProId() async {
    final storedProId = await storage.read(key: 'user_id');
    final storedToken = await storage.read(key: 'authToken');
    setState(() {
      proID = storedProId;
      token =storedToken;
    });
  }



Future<bool> postInvoice(Invoice invoice) async {
  try {
    final response = await ApiService.postWithAuth(
      '/facture',
       {
        'user_id': invoice.user_id,
        'horse_id': invoice.horse_id,
        'professional_id': widget.proID,
        'title': invoice.title,
        'total_amount': invoice.totalAmount,
        'due_date': invoice.dueDate?.toIso8601String(),
        'is_company': invoice.isCompany,
        'payment_type_id': null,//invoice.paymentType, 
        'billing_address_id': null, // invoice.billingAddress?.id,
        'status_id': null,//invoice.status, // adapte selon ton modèle
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      //Navigator.pop(context, newHorse);
      return true;
    } else {
      print("Erreur lors de la création de la facture: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Erreur globale dans saveInvoice: $e");
    return false;
  }
}

Future<File> generateInvoicePdfFile(Invoice invoice) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Facture n°${invoice.number}', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Text('Titre : ${invoice.title}'),
          pw.Text('Montant : ${invoice.totalAmount} €'),
          pw.Text('Date d\'émission : ${invoice.issueDate}'),
          pw.Text('Date d\'échéance : ${invoice.dueDate}'),
          pw.Text('Statut : ${invoice.status ?? "Non défini"}'),
          pw.Text('Payée : ${invoice.isPaid == true ? "Oui" : "Non"}'),
        ],
      ),
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/facture_${invoice.number}.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}

Future<void> generateInvoicePdf(Invoice invoice) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Facture n°${invoice.number}', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Text('Titre : ${invoice.title}'),
          pw.Text('Montant : ${invoice.totalAmount} €'),
          pw.Text('Date d\'émission : ${invoice.issueDate}'),
          pw.Text('Date d\'échéance : ${invoice.dueDate}'),
          pw.Text('Statut : ${invoice.status ?? "Non défini"}'),
          pw.Text('Payée : ${invoice.isPaid == true ? "Oui" : "Non"}'),
  
        ],
      ),
    ),
  );


  // Affiche l’aperçu ou imprime
  //await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}

Future<bool> uploadInvoicePdfWithApiService(File pdfFile, String userId) async {
  try {
    final response = await ApiService.postFileWithAuth('/upload', pdfFile, userId);
    return response.statusCode == 201;
  } catch (e) {
    return false;
  }
}

Invoice newInvoice = Invoice(
  id: 'inv0',
  number: 'INV-000',
  title: 'Facture equipro',
  totalAmount: 0.0,
  user_id: 'user0',
  pro_id: 'pro0',
  issueDate: DateTime.now(),
  dueDate: null,
  isPaid: false,
  isCompany: false,
  horse_id: null,
  paymentType: null,
  status: null,
  billingAddress: null,
  intervention: null,
  createdAt: DateTime.now(),
  updatedAt: null,
);

void _onClientSelected(Users? user) async {
  if (user == null) return;

  final alreadyExists = selectedUsers.any((u) => u.id == user.id);
  if (!alreadyExists) {
    setState(() {
      selectedUsers.add(user);
      newInvoice = newInvoice.copyWith(
        user_id: selectedUsers.isNotEmpty ? selectedUsers.first.id! : null,
      );
      showDropdown = false;
    });

    // Récupérer les chevaux pour la nouvelle liste d'utilisateurs sélectionnés
    final selectedIds = selectedUsers
        .where((u) => u.id != null)
        .map((u) => u.id!)
        .toList();

    final horses = await fetchHorses(selectedIds);

    setState(() {
      horseList = horses;
    });

  } else {
    setState(() {
      showDropdown = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${user.firstName} ${user.lastName} est déjà sélectionné."),
        duration: Duration(seconds: 2),
      ),
    );
  }
}




void _onRemoveUser(Users user) async {
  setState(() {
    selectedUsers.removeWhere((u) => u.id == user.id);
  });

  // Relancer le fetch des chevaux après la suppression
  final selectedIds = selectedUsers
      .where((u) => u.id != null)
      .map((u) => u.id!)
      .toList();

  final horses = await fetchHorses(selectedIds);

  setState(() {
    horseList = horses;
  });
}



  void _onAddClientPressed(String? newClientId) async {
    if (newClientId != null) {
      List<Users> newUsers = await fetchClients();
      final newUser = newUsers.firstWhere((u) => u.id == newClientId, );

      setState(() {
        usersList = newUsers;
        if (newUser.id != null) selectedUsers.add(newUser);
        showDropdown = false;
      });
    } else {
      setState(() {
        showDropdown = true;
      });
    }
  }

  void _onDropdownCancel() {
    setState(() {
      showDropdown = false;
    });
  }



  Future<List<Users>> fetchClients() async {
    print(proID);
    try {
      final response = await ApiService.getWithAuth("/agendaAll/$proID");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final fetchedClients = jsonData.map((data) => Users.fromJson(data)).toList();
        return List<Users>.from(fetchedClients);
      } else {
        throw Exception("Échec du chargement des clients");
      }
    } catch (e) {
      print("Erreur lors du fetch des clients : $e");
      return [];
    }
  }


Future<List<Horse>> fetchHorses(List<String> userIds) async {
  //print(userIds);
  try {
    final response = await ApiService.postWithAuth(
      '/horses/users',
      {
        "userIds": userIds,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => Horse.fromJson(data)).toList();
    } else {
      throw Exception("Échec du chargement des chevaux");
    }
  } catch (e) {
    print("Erreur lors du fetch des chevaux : $e");
    return [];
  }
}



Future<void> loadClientsAndHorses() async {
  try {
    setState(() {
      isLoading = true;
    });

    // Charger tous les clients liés au pro
    final clients = await fetchClients();

    setState(() {
      usersList = clients;
    });

    //Pré-sélectionner un utilisateur si `widget.userId` est fourni
    if (widget.userId != null) {
      final preselectedUser = clients.firstWhere(
        (user) => user.id == widget.userId,
        orElse: () => clients.first,
      );

      if (preselectedUser.id != null) {
        setState(() {
          selectedUsers = [preselectedUser]; 
        });
      }
    }

    // Charger les chevaux associés aux utilisateurs sélectionnés
    if (selectedUsers.isNotEmpty) {
      final selectedIds = selectedUsers
          .where((u) => u.id != null)
          .map((u) => u.id!)
          .toList();

      final horses = await fetchHorses(selectedIds);
      //print("Chevaux chargés pour les utilisateurs sélectionnés : $horses");

      setState(() {
        horseList = horses;
      });
    }

  } catch (e) {
    print("Erreur lors du chargement des clients et chevaux : $e");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}



@override
void initState() {
  super.initState();
  _init();
}

Future<void> _init() async {
  await _loadProId();
  await loadClientsAndHorses();
}



  void _onHorseChanged(Horse? newHorse) async {
    setState(() {
      selectedHorse = newHorse;
      newHorse = newHorse?.copyWith(
        id: newHorse?.id,
        name: newHorse?.name,
      );
    });
  }

  void _toggleHorseCard() {
    setState(() {
      showHorseCard = !showHorseCard;  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Créer une facture',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                // Appel du widget combo Client
                  ClientsComboCardWidget(
                    proID: widget.proID,
                    userList: usersList,
                    selectedUsers: selectedUsers,
                    showDropdown: showDropdown,
                    onClientSelected: _onClientSelected,
                    onAddClientPressed: _onAddClientPressed,
                    onDropdownCancel: _onDropdownCancel,
                    onRemoveUser: _onRemoveUser,
                    isEditing : _isEditing,
                  ),

                  // Appel du widget combo Ecurie
                  HorsesComboCardWidget(
                    horseList: horseList,
                    selectedHorse: selectedHorse,
                    onHorseChanged: _onHorseChanged,
                    onAddHorsePressed: _toggleHorseCard,
                    isEditing : _isEditing,
                  ),


                  InvoiceCardWidget(
                    key: _invoiceCardKey,
                    invoice: newInvoice,
                    onInvoiceUpdated: (updatedInvoice) {
                      setState(() {
                        newInvoice = updatedInvoice;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
             
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isValid = await _invoiceCardKey.currentState?.validateForm() ?? false;
          if (!isValid) return;

          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            // Envoi à l'API
            final success = await postInvoice(newInvoice);

            if (success) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Facture créée avec succès !')),
                );
                final pdfFile = await generateInvoicePdfFile(newInvoice);
                final uploadSuccess = await uploadInvoicePdfWithApiService(pdfFile, newInvoice.user_id);
                if (uploadSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF de la facture uploadé avec succès !')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur lors de l\'upload du PDF')),
                  );
                }
                Navigator.pop(context, newInvoice);
              }
            }
          }
        },
        child: const Icon(Icons.save, color: Colors.white),
        backgroundColor: Constants.turquoiseDark,
      ),
    );
  }
}