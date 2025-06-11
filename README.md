# equipro

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


//Quand tu fais une requête à une API qui nécessite d’être authentifié, ajoute un header Authorization: Bearer <token> comme ceci 
// final prefs = await SharedPreferences.getInstance();
// final token = prefs.getString('token');

// final response = await http.get(
//   Uri.parse('https://ton-api.com/protected-route'),
//   headers: {
//     'Authorization': 'Bearer $token',
//     'Content-Type': 'application/json',
//   },
// );




## Légende du schéma 

| Couleur | Signification |
|--------|---------------|
| <span style="color:#1976d2; font-weight:bold;">&#8212;&#8212;&#8212;</span> | Client (Application mobile Flutter) |
| <span style="color:#673ab7; font-weight:bold;">&#8212;&#8212;&#8212;</span> | Backend (API Node.js / Express) |
| <span style="color:#ba68c8; font-weight:bold;">&#8212;&#8212;&#8212;</span> | Bases de données |
| <span style="color:#66bb6a; font-weight:bold;">&#8212;&#8212;&#8212;</span> | Services Cloud |
| <span style="color:#ffb74d; font-weight:bold;">&#8212;&#8212;&#8212;</span> | CI/CD & Monitoring |
| <span style="color:#f06292; font-weight:bold;">&#8212;&#8212;&#8212;</span> | Stores (App Store / Play Store) |
| <span style="color:#ff8a65; font-weight:bold;">&#8212;&#8212;&#8212;</span> | Monitoring & Consoles |

---

**→** : Flux ou appel unidirectionnel  
**↔** : Échanges bidirectionnels  
-- texte --> : Flèche annotée  
-- HTTPS --> : Échanges sécurisés

