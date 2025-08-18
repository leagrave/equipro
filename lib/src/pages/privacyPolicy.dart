import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final _secureStorage = const FlutterSecureStorage();

  PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politique de confidentialité'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  '''
Politique de confidentialité – EquiPro

Date d’entrée en vigueur : 18 août 2025

EquiPro (ci-après « l’Application ») s’engage à protéger la vie privée et les données personnelles de ses utilisateurs. La présente politique de confidentialité décrit comment nous collectons, utilisons et protégeons vos informations, conformément au Règlement Général sur la Protection des Données (RGPD).

1. Responsable du traitement
Le responsable du traitement de vos données est :  
EquiPro – [equipro / 0681695629]  
Adresse : [17 rue marius saluzzo 13110 port de bouc]  
Email : [lea.grave@orange.fr]

2. Données collectées
Lors de l’utilisation de l’Application, nous pouvons collecter les informations suivantes :  
- Données personnelles : nom, prénom, email, numéro de téléphone, adresse, informations sur le cheval/client.  
- Données de compte : identifiants, historique des rendez-vous, factures et messages.  
- Données techniques : type d’appareil, système d’exploitation, identifiants uniques d’appareil, logs d’utilisation.  
- Messages et fichiers : contenus échangés via la messagerie interne (Firebase).

3. Finalités du traitement
Les données collectées sont utilisées pour :  
1. Gérer votre compte utilisateur et vos accès à l’Application.  
2. Permettre la prise de rendez-vous et la gestion des interventions équines.  
3. Gérer la facturation et les documents (stockés sur AWS S3).  
4. Assurer la communication via la messagerie intégrée (Firebase).  
5. Améliorer et sécuriser l’Application.

4. Base légale
Le traitement de vos données repose sur :  
- Votre consentement, nécessaire pour la création de compte et l’utilisation des services.  
- L’exécution d’un contrat entre vous et EquiPro.  
- Le respect d’obligations légales (ex. conservation de factures).

5. Partage des données
Vos données peuvent être partagées avec :  
- Les prestataires techniques (hébergement Render, AWS S3, Firebase) uniquement pour l’exécution de leurs services.  
- Aucune donnée n’est vendue ou communiquée à des tiers à des fins commerciales.

6. Sécurité
Nous mettons en place des mesures techniques et organisationnelles pour protéger vos données contre toute perte, accès non autorisé ou modification.

7. Durée de conservation
- Les données liées à votre compte sont conservées tant que votre compte est actif.  
- Les documents et factures sont conservés conformément aux obligations légales.

8. Vos droits
Conformément au RGPD, vous disposez des droits suivants :  
- Accès à vos données personnelles  
- Rectification ou suppression de vos données  
- Limitation ou opposition au traitement  
- Portabilité de vos données  
- Retrait du consentement à tout moment  

Pour exercer ces droits, contactez-nous à [contact@equipexemple.com].

9. Cookies et technologies similaires
L’Application peut utiliser des cookies pour améliorer l’expérience utilisateur. Aucune donnée personnelle n’est collectée à votre insu.

10. Modifications de la politique
Nous pouvons mettre à jour cette politique de confidentialité. Les modifications seront publiées dans l’Application avec la date de mise à jour.
''',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Enregistrer le consentement
                await _secureStorage.write(key: 'privacyConsent', value: 'true');
                // Revenir à la page précédente
                context.pop();
              },
              child: const Text('J’accepte'),
            ),
          ],
        ),
      ),
    );
  }
}
