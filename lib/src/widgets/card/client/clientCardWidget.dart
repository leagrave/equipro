import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/user.dart';


class ClientCardWidget extends StatefulWidget {
  final Users user;
  final Function(Users)? onUserUpdated;
  final bool openWithCreateClientPage;
  final bool openWithCreateHorsePage;
  final Function()? onSave;

  const ClientCardWidget({
    Key? key,
    required this.user,
    required this.openWithCreateClientPage,
    required this.openWithCreateHorsePage,
    this.onUserUpdated,
    this.onSave,
  }) : super(key: key);

  @override
  ClientCardWidgetState createState() => ClientCardWidgetState();
}

class ClientCardWidgetState extends State<ClientCardWidget> {
  
  late Users _user;
  late Users _originalUser; 
  bool _isEditing = false;

  // TextEditingControllers pour les champs non booléens
  late TextEditingController _idController;
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _telController;
  late TextEditingController _tel2Controller;
  late TextEditingController _emailController;
  late TextEditingController _societeNameController;

  // Variable temporaire 
  bool? _tempIsSociete;
  bool? _tempIsProfessional;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _originalUser = widget.user;

    // Initialisation des contrôleurs avec les valeurs du client
    _idController = TextEditingController(text: _user.id);
    _nomController = TextEditingController(text: _user.lastName);
    _prenomController = TextEditingController(text: _user.firstName);
    _telController = TextEditingController(text: _user.phone);
    _tel2Controller = TextEditingController(text: _user.phone2 ?? "");
    _emailController = TextEditingController(text: _user.email);
    _societeNameController = TextEditingController(text: _user.societeName);


    // Initialiser la variable temporaire avec la valeur de isSociete
    _tempIsSociete = _user.isSociete;
    _tempIsProfessional = _user.professional;

    if (widget.openWithCreateClientPage || widget.openWithCreateHorsePage) {
      _isEditing = true;
    }

  }

  Future<bool> validateForm() async {
    return await _validateForm();
  }

  Future<bool> _validateForm() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();
    final tel = _telController.text.trim();
    final tel2 = _tel2Controller.text.trim();

    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    final phoneRegex = RegExp(r'^(\+33|0)[1-9](\d{2}){4}$');


    if (nom.isEmpty && prenom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous le nom ou prénom doit être remplis")),
      );
      return false;
    }

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("L'adresse email n'est pas valide.")),
      );
      return false;
    }

    if (tel.isNotEmpty && !phoneRegex.hasMatch(tel)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le numéro de téléphone principal n'est pas valide.")),
      );
      return false;
    }

    if (tel2.isNotEmpty && !phoneRegex.hasMatch(tel2)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le numéro de téléphone secondaire n'est pas valide.")),
      );
      return false;
    }

      // Si l'utilisateur a coché "société", alors le nom de la société est obligatoire
    if (_tempIsSociete == true && _societeNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le nom de la société est requis.")),
      );
      return false;
    }


    return true;
  }

  Future<void> _validerEtMettreAJourUtilisateur() async {

    final response = await ApiService.putWithAuth(
      "/customer/${_idController.text.trim()}",
      {
        'last_Name': _nomController.text.trim(),
        'first_Name': _prenomController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _telController.text.trim(),
        'phone2': _tel2Controller.text.trim(),
        'isSociete': _tempIsSociete,
        'IsProfessional': _tempIsProfessional,
        'societeName': _societeNameController.text.trim(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _user = Users(
          id: _idController.text.trim(),
          lastName: _nomController.text.trim(),
          firstName: _prenomController.text.trim(),
          email: _emailController.text.trim(),
          phone: _telController.text.trim(),
          phone2: _tel2Controller.text.trim(),
          professional: _tempIsProfessional ?? false,
          isSociete: _tempIsSociete ?? false,
          societeName: _societeNameController.text.trim(),
        );
        _isEditing = false;
      });


      widget.onUserUpdated?.call(_user);
      widget.onSave?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil mis à jour avec succès.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour : ${response.body}")),
      );
    }
  }


  @override
  void dispose() {
    _idController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _telController.dispose();
    _tel2Controller.dispose();
    _emailController.dispose();
    _societeNameController.dispose();
    super.dispose();
  }

Future<void> _handleSaveOrCancel({required bool isSave}) async {
  if (isSave) {
    final isValid = await _validateForm();
    if (!isValid) return;

    // Appelle onSave et onClientUpdated si nécessaire
    await _validerEtMettreAJourUtilisateur();
    // widget.onSave?.call();
    // if (widget.onUserUpdated != null) {
    //   widget.onUserUpdated!(_user);
    // }
  } else {
    setState(() {
      // Restaure l'état initial du client
      _user = _originalUser;
      _nomController.text = _user.lastName;
      _prenomController.text = _user.firstName;
      _telController.text = _user.phone ?? "";
      _tel2Controller.text = _user.phone2 ?? "";
      _emailController.text = _user.email;
      _societeNameController.text = _user.societeName ?? "";
      _tempIsSociete = _user.isSociete;
      _tempIsProfessional = _user.professional;
      _isEditing = false;
    });
  }
}

  void _updateClient({
    //String? id,
    String? lastName,
    String? firstName,
    String? phone,
    String? phone2,
    String? email,
    bool? professional,
    bool? isSociete,
    String? societeName,
  }) {
    setState(() {
      _user = _user.copyWith(
        id: _user.id,
        lastName: lastName ?? _user.lastName,
        firstName: firstName ?? _user.firstName,
        phone: phone ?? _user.phone,
        phone2: phone2 ?? _user.phone2,
        email: email ?? _user.email,
        professional: professional ?? _user.professional,
        isSociete: isSociete ?? _user.isSociete,
        societeName: societeName ?? _user.societeName,
      );
    });
   
    widget.onUserUpdated?.call(_user);
    widget.onSave?.call();
  }
  

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool obscureText = false,
    ValueChanged<String>? onChanged,
  }) {
    bool obscure = obscureText;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        readOnly: !_isEditing,
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

@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField("Nom", _nomController, Icons.person, onChanged: (value) => _updateClient(lastName: value)),
        _buildTextField("Prénom", _prenomController, Icons.person, onChanged: (value) => _updateClient(firstName: value)),
        _buildTextField("Téléphone", _telController, Icons.phone, onChanged: (value) => _updateClient(phone: value),),
        _buildTextField("Téléphone 2", _tel2Controller, Icons.phone, onChanged: (value) => _updateClient(phone2: value),),
        _buildTextField("Email", _emailController, Icons.email, onChanged: (value) => _updateClient(email: value),),

        SwitchListTile(
          title: const Text("Est une société ?", style: TextStyle(color: Colors.white)),
          value: _tempIsSociete ?? false,
          onChanged: _isEditing
              ? (value) {
                  setState(() {
                    _tempIsSociete = value;
                  });
                  _updateClient(isSociete: value);
                }
              : null,
        ),

        if (_tempIsSociete == true)
          _buildTextField("Nom de la société", _societeNameController, Icons.business, onChanged: (value) => _updateClient(societeName: value),),

              const SizedBox(height: 8),

              if(!widget.openWithCreateClientPage)
              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () => _handleSaveOrCancel(isSave: false),
                      child: const Text('Annuler', style: TextStyle(color: Constants.appBarBackgroundColor),),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_isEditing) {
                        _handleSaveOrCancel(isSave: true);
                      } else {
                        setState(() {
                          _isEditing = true;
                        });
                      }
                    },
                    child: Text(_isEditing ? 'Enregistrer' : 'Modifier',style: TextStyle(color: Constants.appBarBackgroundColor),),
                  ),
                ],
              ),
            ],
          ),
        );
  }
}
