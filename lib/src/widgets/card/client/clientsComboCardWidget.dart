import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:go_router/go_router.dart';


class ClientsComboCardWidget extends StatelessWidget {
  final String proID;
  final List<Users> userList;
  final List<Users> selectedUsers;
  final Function(Users?) onClientSelected;
  final void Function(String?) onAddClientPressed;
  final bool showDropdown;
  final VoidCallback onDropdownCancel;
  final Function(Users) onRemoveUser;
  final bool? isEditing ;

  const ClientsComboCardWidget({
    required this.proID,
    required this.userList,
    required this.selectedUsers,
    required this.onClientSelected,
    required this.onAddClientPressed,
    required this.showDropdown,
    required this.onDropdownCancel,
    required this.onRemoveUser,
    required this.isEditing ,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Propriétaires',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Constants.white,
              ),
            ),
            if (isEditing  == true)
            IconButton(
              icon: Icon(
                showDropdown ? Icons.close : Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                final choice = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Ajouter un propriétaire"),
                    content: const Text("Souhaitez-vous ajouter un propriétaire existant ou en créer un nouveau ?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'ajouter'),
                        child: const Text("Ajouter"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'créer'),
                        child: const Text("Créer"),
                      ),
                    ],
                  ),
                );

                if (choice == 'ajouter') {
                  onAddClientPressed(null);
                } else if (choice == 'créer') {
                  final result = await context.push('/createClient', extra: {
                    'proID': proID,
                    'openWithCreateHorsePage': true,
                  });

                  if (result != null && result is String) {
                    onAddClientPressed(result); // Passe l'ID du nouveau client à la page parent
                  }
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),


          // Liste des propriétaires sélectionnés
          ...selectedUsers.map((user) => Padding(
            key: ValueKey(user.id),
            padding: const EdgeInsets.only(bottom: 12), 
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    initialValue: "${user.firstName} ${user.lastName}",
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
                if (isEditing  == true)
                IconButton(
                  icon: const Icon(Icons.close, color: Constants.secondaryRed),
                  onPressed: () => onRemoveUser(user),
                ),
              ],
            ),
          )).toList(),



          const SizedBox(height: 8),

          // Dropdown affiché uniquement si showDropdown est true
          if (showDropdown)
            Row(
              children: [
                Expanded(
                  child: DropdownSearch<Users>(
                    items: userList,
                    itemAsString: (Users user) => "${user.firstName} ${user.lastName}",
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Rechercher un client",
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
                      itemBuilder: (context, user, isSelected) => ListTile(
                        title: Text("${user.firstName} ${user.lastName}"),
                      ),
                    ),
                    onChanged: onClientSelected,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Constants.white),
                  onPressed: onDropdownCancel,
                ),
              ],
            ),
        ]),
      );
  }
}

