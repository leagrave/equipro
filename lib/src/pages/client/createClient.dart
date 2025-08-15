import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/password.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';  
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';


class CreateClientPage extends StatefulWidget {
  final String proID;
  final bool?  openWithCreateHorsePage;
  

  const CreateClientPage({Key? key, required this.proID, this.openWithCreateHorsePage =false}) : super(key: key);

  @override
  _CreateClientPageState createState() => _CreateClientPageState();
}

class _CreateClientPageState extends State<CreateClientPage> {
  final _formKey = GlobalKey<FormState>();

  // Clé pour accéder au state de ClientCardWidget
final GlobalKey<ClientCardWidgetState> _clientCardKey = GlobalKey<ClientCardWidgetState>();


  Users newUser = Users(
    id: "",
    lastName: '',
    firstName: '',
    phone: '',
    phone2: '',
    email: '',
    professional: false,
    isSociete: false,
    notes: '',
    password: generateRandomPassword(),
    addresses: [],
  );

  String clientNotes = '';
  List<String> clientAddresses = [];
  final String randomPassword = generateRandomPassword();

  Future<bool> saveClient() async {
    try {
      // 2. Vérification email
      final emailCheckResponse = await ApiService.getWithAuth("/user/email/checkEmail?email=${newUser.email}");

      if (emailCheckResponse.statusCode != 200) {
        throw Exception("Erreur lors de la vérification de l'email");
      }

      final emailCheckBody = jsonDecode(emailCheckResponse.body);
      final emailExists = emailCheckBody["exists"] == true;

      String userId = "";

      if (!emailExists) {
        final createUserResponse = await ApiService.postWithAuth(
          '/userCreate',
          {
            "email": newUser.email,
            "password": newUser.password,
            "first_name": newUser.firstName,
            "last_name": newUser.lastName,
            "professional": false,
          },
        );

        if (createUserResponse.statusCode != 201) {
          throw Exception("Erreur lors de la création de l'utilisateur");
        }

        final createdUser = jsonDecode(createUserResponse.body);
        userId = createdUser["id"];
        newUser = newUser.copyWith(id: userId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("L'utilisateur avec cet email existe déjà.")),
        );
        return false;
      }

      // Créer le client (Customer)
      final response = await ApiService.postWithAuth(
        '/customer',
        {
          "owner_id": widget.proID,
          "user_id": userId,
          "phone": newUser.phone,
          "phone2": newUser.phone2,
          "is_societe": newUser.isSociete,
          "societe_name": newUser.societeName,
          "notes": newUser.notes,
          "mainAddress": (newUser.addresses != null && newUser.addresses!.isNotEmpty)
              ? {
                  "address": newUser.addresses!.first.address,
                  "city": newUser.addresses!.first.city,
                  "postal_code": newUser.addresses!.first.postalCode,
                  "country": newUser.addresses!.first.country,
                  "latitude": newUser.addresses!.first.latitude,
                  "longitude": newUser.addresses!.first.longitude,
                  "user_id": userId,
                  "horse_id": null,
                  "type": "main",
                }
              : null,
          "billingAddress": (newUser.addresses != null && newUser.addresses!.length > 1)
              ? {
                  "address": newUser.addresses![1].address,
                  "city": newUser.addresses![1].city,
                  "postal_code": newUser.addresses![1].postalCode,
                  "country": newUser.addresses![1].country,
                  "latitude": newUser.addresses![1].latitude,
                  "longitude": newUser.addresses![1].longitude,
                  "user_id": userId,
                  "horse_id": null,
                  "type": "billing",
                }
              : null,
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print("Erreur lors de la création du client: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erreur globale dans saveClient: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Créer un client',
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
                  ClientCardWidget(
                    key: _clientCardKey,
                    user: newUser,
                    onUserUpdated: (updatedUser) {
                      setState(() {
                        newUser = newUser.copyWith(
                          lastName: updatedUser.lastName,
                          firstName: updatedUser.firstName,
                          phone: updatedUser.phone,
                          phone2: updatedUser.phone2,
                          email: updatedUser.email,
                          isSociete: updatedUser.isSociete,
                        );
                      });
                    },
                    openWithCreateClientPage: true,
                    openWithCreateHorsePage: false,
                  ),
                  const SizedBox(height: 16),
                  AddressCardWidget(
                    addresses: newUser.addresses ?? [],
                    userSelectedId: null,
                    onAdresseChanged: (updatedAddresses) {
                      setState(() {
                        newUser = newUser.copyWith(
                          addresses: updatedAddresses.isEmpty ? null : updatedAddresses,
                        );
                      });
                    },
                    openWithCreateClientPage: true,
                    openWithCreateHorsePage: false,
                    openWithManagementHorsePage: false,
                  ),
                  const SizedBox(height: 16),
                  NotesCardWidget(
                    initialNotes: newUser.notes ?? '',
                    onNotesChanged: (value) => setState(() {
                      clientNotes = value;
                      newUser = newUser.copyWith(notes: value);
                    }),
                    openWithCreateHorsePage: false,
                    openWithCreateClientPage: true,
                    openWithManagementHorsePage: false,
                    visitId: null,
                    proID: widget.proID,
                    customId: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isValid = await _clientCardKey.currentState!.validateForm();
          if (!isValid) return;

          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            bool success = await saveClient();
            if (success) {
              if (widget.openWithCreateHorsePage == true) {
                Navigator.pop(context, newUser.id);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Client enregistré'),
                      content: Text('Souhaitez-vous ajouter un cheval à cette personne ?'),
                      actions: [
                        TextButton(
                          child: Text('Non'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context, newUser);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Oui'),
                          onPressed: () {
                            Navigator.pop(context);
                            context.push('/createHorse', extra: {
                              'proID': widget.proID,
                              'customer': newUser,
                              'userCustomId': newUser.id
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur lors de la sauvegarde.')),
              );
            }
          }
        },
        child: const Icon(Icons.save, color: Constants.white),
        backgroundColor: Constants.turquoiseDark,
      ),
    );
  }
}
