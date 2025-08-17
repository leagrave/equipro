import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('test_results.json');

  if (!file.existsSync()) {
    print('Fichier test_results.json introuvable');
    exit(1);
  }

  final content = file.readAsLinesSync();
  final failedTests = <String>[];

  for (var line in content) {
    if (line.trim().isEmpty) continue;

    final data = jsonDecode(line);

    // On ne garde que les tests échoués
    if (data['type'] == 'testDone') {
      // Flutter <3.10 peut utiliser 'result', sinon check via 'success'
      final result = data['result'] ?? (data['success'] == true ? 'success' : 'failure');
      if (result == 'failure') {
        final testName = data['test']?['name']?.toString() ?? 'Test inconnu';
        failedTests.add(testName);
      }
    }
  }

  if (failedTests.isEmpty) {
    print('Tous les tests ont réussi ✅');
    exit(0);
  }

  // Récupération du token GitHub depuis l'environnement
  final githubToken = Platform.environment['GITHUB_TOKEN'];
  if (githubToken == null) {
    print('GITHUB_TOKEN non défini');
    exit(1);
  }

  final owner = 'leagrave';
  final repo = 'equipro';
  final issueTitle = 'Tests Flutter échoués (${failedTests.length})';
  final issueBody = failedTests.map((t) => '- $t').join('\n');

  final url = Uri.https('api.github.com', '/repos/$owner/$repo/issues');
  final request = await HttpClient().postUrl(url);
  request.headers
    ..set(HttpHeaders.authorizationHeader, 'token $githubToken')
    ..set(HttpHeaders.contentTypeHeader, 'application/json');

  request.add(utf8.encode(jsonEncode({
    'title': issueTitle,
    'body': issueBody,
  })));

  final response = await request.close();

  if (response.statusCode == 201) {
    print('Issue GitHub créée avec succès ✅');
    exit(0);
  } else {
    final respBody = await response.transform(utf8.decoder).join();
    print('Erreur lors de la création de l\'issue: ${response.statusCode}');
    print(respBody);
    exit(1);
  }
}
