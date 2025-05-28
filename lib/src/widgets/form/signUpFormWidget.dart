import 'package:flutter/material.dart';


// // Exemple de route d'inscription
// router.post("/signup", async (req, res) => {
//     const {
//         first_name,
//         last_name,
//         email,
//         password,
//         role_name,
//         phone,
//         phone2,
//         address,
//         billing_address,
//         societeName,
//         sirenNumber,
//         professionalType,
//         isSociete
//     } = req.body;

//     try {
//         // Créer l'utilisateur
//         const newUser = await signUp(first_name, last_name, email, password, role_name);

//         // Si le rôle est 'particulier', créer un client
//         if (role_name === 'particulier') {
//             await signUpCustomers(newUser.id, phone, phone2, isSociete, address, billing_address);
//         }

//         // Si le rôle est 'professionnel', créer un professionnel
//         if (role_name === 'professionnel') {
//             await signUpProfessional(newUser.id, phone, phone2, societeName, address, sirenNumber, professionalType);
//         }

//         res.status(201).json({ message: "Utilisateur créé avec succès", user: newUser });
//     } catch (error) {
//         res.status(400).json({ error: error.message });
//     }
// });


class SignUpFormWidget extends StatefulWidget {
  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _sirenController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _tel2Controller = TextEditingController();
  final TextEditingController _societeController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _adresseFacturationController = TextEditingController();
  
  String _role = 'Particulier';
  String? _profession;
  bool _isSociete = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(_nomController, 'Nom', Icons.person),
        _buildTextField(_prenomController, 'Prénom', Icons.person),
        _buildTextField(_emailController, 'Adresse e-mail', Icons.email, keyboardType: TextInputType.emailAddress),
        _buildTextField(_passwordController, 'Mot de passe', Icons.lock, obscureText: true),
        _buildTextField(_confirmPasswordController, 'Confirmer le mot de passe', Icons.lock, obscureText: true),
        const SizedBox(height: 10),
        const Text("Sélectionnez votre rôle", style: TextStyle(color: Colors.white)),
        DropdownButtonFormField<String>(
          value: _role,
          items: ['Particulier', 'Professionnel'].map((role) {
            return DropdownMenuItem(value: role, child: Text(role));
          }).toList(),
          onChanged: (value) => setState(() => _role = value!),
        ),
        if (_role == 'Professionnel') _buildProfessionFields(),
        if (_role == 'Particulier') _buildParticulierFields(),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildProfessionFields() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Sélectionnez votre profession", style: TextStyle(color: Colors.white)),
        DropdownButtonFormField<String>(
          value: _profession,
          items: ['Dentiste équin', 'Gérant d’écurie'].map((profession) {
            return DropdownMenuItem(value: profession, child: Text(profession));
          }).toList(),
          onChanged: (value) => setState(() => _profession = value),
        ),
        if (_profession == 'Dentiste équin') _buildTextField(_sirenController, 'Numéro de SIREN', Icons.business),
        if (_profession != 'Dentiste équin') ...[
          _buildTextField(_telController, 'Téléphone', Icons.phone, keyboardType: TextInputType.phone),
          _buildTextField(_tel2Controller, 'Téléphone secondaire (optionnel)', Icons.phone, keyboardType: TextInputType.phone),
          _buildTextField(_societeController, 'Nom de la société (optionnel)', Icons.business),
          _buildTextField(_adresseController, 'Adresse (optionnel)', Icons.location_on),
        ],
      ],
    );
  }

  Widget _buildParticulierFields() {
    return Column(
      children: [
        _buildTextField(_telController, 'Téléphone', Icons.phone, keyboardType: TextInputType.phone),
        _buildTextField(_tel2Controller, 'Téléphone secondaire (optionnel)', Icons.phone, keyboardType: TextInputType.phone),
        SwitchListTile(
          title: const Text("Êtes-vous une société ?", style: TextStyle(color: Colors.white)),
          value: _isSociete,
          onChanged: (value) => setState(() => _isSociete = value),
        ),
        _buildTextField(_adresseController, 'Adresse', Icons.location_on),
        _buildTextField(_adresseFacturationController, 'Adresse de facturation (optionnel)', Icons.location_city),
      ],
    );
  }
}
