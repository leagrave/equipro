import 'dart:convert';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:equipro/src/widgets/list/horseListWidget.dart';
import 'package:collection/collection.dart';

class ClientListWidget extends StatelessWidget {
  final String? currentUserId;
  final List<Users> filteredUsers;
  final Function(Users) onClientTap;

  const ClientListWidget({
    Key? key,
    required this.currentUserId,
    required this.filteredUsers,
    required this.onClientTap
  }) : super(key: key);


String getMainOrBillingCity(Users user) {
  final addresses = user.addresses ?? [];

  final main = addresses.firstWhereOrNull((addr) => addr.type == 'main');
  if (main?.city != null) return main!.city!;

  final billing = addresses.firstWhereOrNull((addr) => addr.type == 'billing');
  return billing?.city ?? 'Ville non spécifiée';
}

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Impossible d\'ouvrir $phoneNumber';
    }
  }


    void navigateToManagementHorsePage(BuildContext context, String horseId) async {
    context.push('/managementHorse', extra: {
      'horseId': horseId,
      'proID': currentUserId,
    });
  }


  Future<List<Horse>> _fetchClientHorses(String userId) async {
    try {
      final response = await http.get(Uri.parse("${Constants.apiBaseUrl}/horses/user/$userId"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => Horse.fromJson(data)).toList();
      } else {
        throw Exception("Échec du chargement des chevaux : code ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors du fetch des chevaux pour userId=$userId : $e");
      return []; 
    }
  }


  @override
  Widget build(BuildContext context) {
    return filteredUsers.isNotEmpty
        ? ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFF323C46),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: const CircleAvatar(
                        backgroundColor: Constants.gradientStartColor,
                        child: Icon(Icons.person, color: Constants.white),
                      ),
                      title: Text(
                        "${user.lastName} ${user.firstName}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Constants.white),
                      ),
                      subtitle: Text(
                        getMainOrBillingCity(user),
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.call, color: Constants.secondaryGreen),
                            onPressed: () => _makePhoneCall('${user.phone}'), 
                          ),
                          IconButton(
                            icon: const Icon(Icons.message, color: Constants.secondaryBleu),
                            onPressed: () {
                            //context.push('/chat', extra: {'userId': user.id}); // a revoir
                              context.push(
                                '/chat/5jHqjqRJrHTyONJAj8fN', //  ${conv.id}',
                                extra: currentUserId, 
                            );
                            },
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Constants.white),
                        ],
                      ),
                      onTap: () => onClientTap(user),
                    ),

                    // Liste des chevaux associés 
                    if ((user.horses ?? []).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 44.0, right: 18.0, top: 0.0, bottom: 4.0), 
                        child: HorseListWidget(
                          horses: user.horses ?? [],
                          onHorseTap: (horse) => navigateToManagementHorsePage(context, horse.id),
                          isFromListHorsePage: false, 
                        ),
                      ),
                  ],
                ),
              );
            },
          )
        : const Center(
            child: Text(
              "Aucun client trouvé",
              style: TextStyle(color: Constants.white),
            ),
          );
  }
}
