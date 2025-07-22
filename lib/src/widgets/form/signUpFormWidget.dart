import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/professionalType.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpFormWidget extends StatefulWidget {
  final Users? currentUser;
  final bool enSaisie;
  final VoidCallback? onCancel;
  final bool originProfil;

  const SignUpFormWidget({super.key, this.currentUser, this.enSaisie = false, this.onCancel, this.originProfil = false,});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  // Controllers
  late final TextEditingController _nomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _sirenController;
  late final TextEditingController _telController;
  late final TextEditingController _tel2Controller;
  late final TextEditingController _societeController;
  // Adresse principale
  late final TextEditingController _idAdresseController;
  late final TextEditingController _adresseController;
  late final TextEditingController _adresseCityController;
  late final TextEditingController _adressePostalCodeController;
  late final TextEditingController _adresseCountryController;
  String _adresseType = 'main'; 

  // Adresse de facturation
  late final TextEditingController _idAdresseFacturationController;
  late final TextEditingController _adresseFacturationController;
  late final TextEditingController _adresseFacturationCityController;
  late final TextEditingController _adresseFacturationPostalCodeController;
  late final TextEditingController _adresseFacturationCountryController;
  String _adresseFacturationType = 'billing';


 // mot de passe visible
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;


  // Professionnels
  List<ProfessionalType> _professionalTypes = [];
  ProfessionalType? _selectedProfession;
  bool _isLoadingProfessions = true;

  // Autres
  bool? _selectedRole; 
  bool _isSociete = false;

  // Fetch les types de professionnels
  Future<List<ProfessionalType>> fetchProfessionalTypes() async {
    final url = Uri.parse('${Constants.apiBaseUrl}/professionalType');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ProfessionalType.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      throw Exception("Aucun type de profession trouvé.");
    } else {
      throw Exception("Erreur serveur : ${response.statusCode}");
    }
  }

  Future<bool> _checkEmailExists(String email) async {
    final response = await http.get(Uri.parse('${Constants.apiBaseUrl}/user/email/checkEmail?email=$email'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] == true;
    } else {
      throw Exception('Erreur lors de la vérification de l\'email');
    }
  }


  Future<bool> _validateForm() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();
    final tel = _telController.text.trim();
    final tel2 = _tel2Controller.text.trim();
    final password = _passwordController.text.trim();
    bool emailExists = false;

    if (widget.currentUser == null || email != widget.currentUser!.email) {
      emailExists = await _checkEmailExists(email);
    }

    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    final phoneRegex = RegExp(r'^(\+33|0)[1-9](\d{2}){4}$');

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return false;
    }
    if (nom.isEmpty || prenom.isEmpty || email.isEmpty || tel.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs obligatoires doivent être remplis.")),
      );
      return false;
    }
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("L'adresse email n'est pas valide.")),
      );
      return false;
    }
    if (emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cet email est déjà utilisé.")),
      );
      return false;
    }
    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Le mot de passe doit contenir au moins 8 caractères, une majuscule, un chiffre et un caractère spécial."),
        ),
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

  return true;
}


  void _validerFormulaire() async {
    if (!await _validateForm()) return;

  final url = Uri.parse("${Constants.apiBaseUrl}/user/all/${widget.currentUser?.id}"); 
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'lastName': _nomController.text,
      'firstName': _prenomController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'phone': _telController.text,
      'phone2': _tel2Controller.text,
      'siretNumber': _sirenController.text,
      'societeName': _societeController.text,
      'isSociete': _isSociete,
      'role': _selectedRole == true ? 'professionnel' : 'particulier',
      'idProfessionalType': _selectedProfession?.idProfessional,
      'addresses': [
        {
          'idAddress': _idAdresseController.text.isEmpty ? null : _idAdresseController.text,
          'address': _adresseController.text,
          'city': _adresseCityController.text,
          'postalCode': _adressePostalCodeController.text,
          'country': _adresseCountryController.text,
          'type': "main",
        },
        {
          'idAdress': _idAdresseFacturationController.text.isNotEmpty ? null : _idAdresseFacturationController.text,
          'address': _adresseFacturationController.text,
          'city': _adresseFacturationCityController.text,
          'postalCode': _adresseFacturationPostalCodeController.text,
          'country': _adresseFacturationCountryController.text,
          'type': "billing",
        },
      ],

    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Modifications enregistrées."),
    ));
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Erreur : ${response.statusCode}"),
    ));
  }
}


  @override
  void initState() {
    super.initState();
    final user = widget.currentUser;

    // Init champs
    _nomController = TextEditingController(text: user?.lastName ?? '');
    _prenomController = TextEditingController(text: user?.firstName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _passwordController = TextEditingController(text: user?.password ?? '');
    _confirmPasswordController = TextEditingController(text: user?.password ?? '');
    _sirenController = TextEditingController(text: user?.siretNumber ?? '');
    _telController = TextEditingController(text: user?.phone ?? '');
    _tel2Controller = TextEditingController(text: user?.phone2 ?? '');
    _societeController = TextEditingController(text: user?.societeName ?? '');
    _idAdresseController = TextEditingController(
      text: (user?.addresses != null && user!.addresses!.isNotEmpty)
          ? user.addresses!.first.idAddress
          : '',
    );
    _adresseController = TextEditingController(
      text: (user?.addresses != null && user!.addresses!.isNotEmpty)
          ? user.addresses!.first.address
          : '',
    );
    _adresseCityController = TextEditingController(
  text: (user?.addresses != null && user!.addresses!.isNotEmpty)
      ? user.addresses!.first.city ?? ''
      : '',
    );
    _adressePostalCodeController = TextEditingController(
  text: (user?.addresses != null && user!.addresses!.isNotEmpty)
      ? user.addresses!.first.postalCode ?? ''
      : '',
    );
    _adresseCountryController = TextEditingController(
      text: (user?.addresses != null && user!.addresses!.isNotEmpty)
          ? user.addresses!.first.country ?? ''
          : '',
    );
    _idAdresseFacturationController = TextEditingController(
      text: (user?.addresses != null && user!.addresses!.length > 1)
          ? user.addresses!.first.idAddress
          : '',
    );
        _adresseFacturationController = TextEditingController(
      text: (user?.addresses != null && user!.addresses!.length > 1)
          ? user.addresses![1].address
          : '',
    );
    _adresseFacturationCityController = TextEditingController(
      text: (user?.addresses != null && user!.addresses!.length > 1)
          ? user.addresses![1].city ?? ''
          : '',
    );
    _adresseFacturationPostalCodeController = TextEditingController(
  text: (user?.addresses != null && user!.addresses!.length > 1)
      ? user.addresses![1].postalCode ?? ''
      : '',
    );
    _adresseFacturationCountryController = TextEditingController(
      text: (user?.addresses != null && user!.addresses!.length > 1)
          ? user.addresses![1].country ?? ''
          : '',
    );

    _adresseType = (user?.addresses != null && user!.addresses!.isNotEmpty)
        ? user.addresses!.first.type ?? ''
        : '';

    _adresseFacturationType = (user?.addresses != null && user!.addresses!.length > 1)
        ? user.addresses![1].type ?? ''
        : '';


    _selectedRole = user?.professional;
    _selectedProfession = user?.typeProfessional;

    _isSociete = user?.isSociete ?? false;

    // Charge les types de professionnels
    fetchProfessionalTypes().then((types) {
      setState(() {
        _professionalTypes = types;
        _isLoadingProfessions = false;

        if (_selectedProfession != null) {
          // Met à jour l'objet sélectionné avec celui de la liste (pour éviter des bugs avec le `Dropdown`)
          _selectedProfession = types.firstWhere(
            (e) => e.idProfessional == _selectedProfession!.idProfessional,
            orElse: () => types.first,
          );
        }
      });
    });
  }

@override
void didUpdateWidget(covariant SignUpFormWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.enSaisie != widget.enSaisie && widget.enSaisie == false) {
    final user = widget.currentUser;
    setState(() {
      _nomController.text = user?.lastName ?? '';
      _prenomController.text = user?.firstName ?? '';
      _emailController.text = user?.email ?? '';
      _passwordController.text = user?.password ?? '';
      _confirmPasswordController.text = user?.password ?? '';
      _sirenController.text = user?.siretNumber ?? '';
      _telController.text = user?.phone ?? '';
      _tel2Controller.text = user?.phone2 ?? '';
      _societeController.text = user?.societeName ?? '';
      _adresseController.text = (user?.addresses != null && user!.addresses!.isNotEmpty)
          ? user.addresses!.first.address
          : '';
      _adresseCityController.text = (user?.addresses != null && user!.addresses!.isNotEmpty)
          ? user.addresses!.first.city
          : '';
       _adresseCountryController.text = (user?.addresses != null && user!.addresses!.isNotEmpty)
          ? user.addresses!.first.country
          : '';
      _adresseFacturationController.text = (user?.addresses != null && user!.addresses!.length > 1)
          ? user.addresses![1].address
          : '';
      _adresseFacturationCityController.text = (user?.addresses != null && user!.addresses!.length > 1)
          ? user.addresses![1].city
          : '';
       _adresseFacturationCountryController.text = (user?.addresses != null && user!.addresses!.length > 1)
          ? user.addresses![1].country
          : '';
      _selectedRole = user?.professional;
      _selectedProfession = user?.typeProfessional;
      _isSociete = user?.isSociete ?? false;
    });
  }
}


  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _sirenController.dispose();
    _telController.dispose();
    _tel2Controller.dispose();
    _societeController.dispose();
    _adresseController.dispose();
    _adresseFacturationController.dispose();
    _adresseCityController.dispose();
    _adressePostalCodeController.dispose();
    _adresseCountryController.dispose();
    _adresseFacturationCityController.dispose();
    _adresseFacturationPostalCodeController.dispose();
    _adresseFacturationCountryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField("Nom *", _nomController, Icons.person),
        _buildTextField("Prénom *", _prenomController, Icons.person),
        _buildTextField("E-mail *", _emailController, Icons.email),
        _buildTextField("Mot de passe *", _passwordController, Icons.lock, obscureText: true, isPasswordField: true),
        _buildTextField("Confirmation mot de passe", _confirmPasswordController, Icons.lock, obscureText: true, isPasswordField: true),
        _buildRoleSelector(),
        if (_selectedRole == true) _buildProfessionnelFields(),
        if (_selectedRole == false) _buildParticulierFields(),
        if (widget.enSaisie) ...[
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                "Valider",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _validerFormulaire,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF323C46), 
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel, color: Colors.white),
              label: const Text(
                "Annuler",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: widget.onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF323C46), 
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],

      ],
    );
  }

Widget _buildTextField(
  String label,
  TextEditingController controller,
  IconData icon, {
  bool obscureText = false,
  bool isPasswordField = false,
}) {
  bool obscure = obscureText;
  if (isPasswordField) {
    // Choisir quel booléen utiliser selon le label (ou passer un paramètre)
    if (label == "Mot de passe") {
      obscure = _obscurePassword;
    } else if (label == "Confirmation mot de passe") {
      obscure = _obscureConfirmPassword;
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      readOnly: !widget.enSaisie,
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
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: widget.enSaisie
                    ? () {
                        setState(() {
                          if (label == "Mot de passe") {
                            _obscurePassword = !_obscurePassword;
                          } else if (label == "Confirmation mot de passe") {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          }
                        });
                      }
                    : null,
              )
            : null,
      ),
      style: const TextStyle(color: Colors.white),
    ),
  );
}


  Widget _buildRoleSelector() {
    return DropdownButtonFormField<bool>(
      value: _selectedRole,
      items: const [
        DropdownMenuItem(value: false, child: Text("Particulier")),
        DropdownMenuItem(value: true, child: Text("Professionnel")),
      ],
      onChanged: (value) {
        setState(() {
          _selectedRole = value;
        });
      },
      decoration: const InputDecoration(
        labelText: "Rôle",
        labelStyle: TextStyle(color: Colors.white),
      ),
      dropdownColor: Colors.grey[800],
      iconEnabledColor: Colors.white,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildProfessionnelFields() {
    return Column(
      children: [
        _isLoadingProfessions
          ? const CircularProgressIndicator()
          : DropdownButtonFormField<ProfessionalType>(
              value: _selectedProfession,
              items: _professionalTypes.map((type) {
                return DropdownMenuItem<ProfessionalType>(
                  value: type,
                  child: Text(type.nameProfessional),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProfession = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Profession",
                labelStyle: TextStyle(color: Colors.white),
                
              ),
              
              dropdownColor: Colors.grey[800],
              iconEnabledColor: Colors.white,
              style: const TextStyle(color: Colors.white),
            ),
        _buildTextField("SIREN", _sirenController, Icons.business),
        _buildTextField("Téléphone *", _telController, Icons.phone),
        _buildTextField("Téléphone secondaire", _tel2Controller, Icons.phone),
        _buildTextField("Nom de la société", _societeController, Icons.business),
        _buildTextField("Adresse", _adresseController, Icons.location_on),
        _buildTextField("Ville", _adresseCityController, Icons.location_city),
        _buildTextField("Code postal", _adressePostalCodeController, Icons.location_city),
        _buildTextField("Pays", _adresseCountryController, Icons.public),

        //_buildTextField("Adresse de facturation", _adresseFacturationController, Icons.location_city),
      ],
    );
  }

  Widget _buildParticulierFields() {
    return Column(
      children: [
        _buildTextField("Téléphone *", _telController, Icons.phone),
        _buildTextField("Téléphone secondaire", _tel2Controller, Icons.phone),
        SwitchListTile(
          title: const Text("Êtes-vous une société ?", style: TextStyle(color: Colors.white)),
          value: _isSociete,
          onChanged: widget.enSaisie
              ? (value) => setState(() => _isSociete = value)
              : null,
        ),
        _buildTextField("Adresse", _adresseController, Icons.location_on),
        _buildTextField("Ville", _adresseCityController, Icons.location_city),
        _buildTextField("Code postal", _adressePostalCodeController, Icons.location_city),
        _buildTextField("Pays", _adresseCountryController, Icons.public),
        if (_selectedRole == false) 
          _buildTextField("Adresse de facturation", _adresseFacturationController, Icons.location_city),
          _buildTextField("Ville", _adresseFacturationCityController, Icons.location_city),
          _buildTextField("Code postal", _adresseFacturationPostalCodeController, Icons.location_city),
          _buildTextField("Pays", _adresseFacturationCountryController, Icons.public),

      ],
    );
  }
}
