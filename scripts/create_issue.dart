import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('test/results/test_results.ndjson');

  if (!file.existsSync()) {
    print('Fichier test_results.ndjson introuvable');
    exit(1);
  }

  final lines = file.readAsLinesSync();
  final failedTests = <String>[];

  for (var line in lines) {
    if (line.trim().isEmpty) continue;

    final data = jsonDecode(line);

    if (data['type'] == 'testDone') {
      final result = data['result'] ?? (data['success'] == true ? 'success' : 'failure');
      if (result == 'failure') {
        failedTests.add(data['test']?['name']?.toString() ?? 'Test inconnu');
      }
    }
  }

  if (failedTests.isEmpty) {
    print('Aucun test en échec');
    exit(0);
  }

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
  final respBody = await response.transform(utf8.decoder).join();

  if (response.statusCode == 201) {
    print('Issue GitHub créée avec succès');
  } else {
    print('Erreur lors de la création de l\'issue: ${response.statusCode}');
    print(respBody);
  }
}
