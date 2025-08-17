import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('test_results.json');
  if (!file.existsSync()) {
    print('Fichier test_results.json introuvable');
    exit(1);
  }

  final content = file.readAsStringSync();
  final lines = content.split('\n').where((line) => line.isNotEmpty);
  final failedTests = <String>[];

  for (var line in lines) {
    final data = jsonDecode(line);
    if (data['type'] == 'testDone' && data['result'] == 'failure') {
      failedTests.add(data['test']['name']);
    }
  }

  if (failedTests.isEmpty) {
    print('Tous les tests ont réussi ✅');
    exit(0);
  }

  final githubToken = Platform.environment['GITHUB_TOKEN'];
  if (githubToken == null) {
    print('GITHUB_TOKEN non défini');
    exit(1);
  }

  final issueTitle = 'Tests Flutter échoués (${failedTests.length})';
  final issueBody = failedTests.map((t) => '- $t').join('\n');

  final owner = 'leagrave';
  final repo = 'equipro';

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
    print('Issue créée avec succès ✅');
  } else {
    print('Erreur lors de la création de l\'issue: ${response.statusCode}');
    exit(1);
  }
}
