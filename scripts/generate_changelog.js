// scripts/generate_changelog.js
// avant de lancer cela faire ="flutter pub outdated --json | Out-File -Encoding utf8 scripts/outdated.json" dans le terminal
const fs = require('fs');
const path = require('path');

const outdatedPath = path.join(__dirname, './outdated.json'); // adapte le chemin si besoin
const changelogPath = path.join(__dirname, '..', 'CHANGELOG.md');

let jsonData; // on déclare une seule fois

try {
  // Lire le fichier en UTF-8 et supprimer le BOM éventuel
  let data = fs.readFileSync(outdatedPath, 'utf8');
  data = data.replace(/^\uFEFF/, '').trim(); // retire le BOM si présent et les espaces inutiles

  jsonData = JSON.parse(data); // on assigne à la variable globale
  console.log('JSON chargé avec succès !');
} catch (err) {
  console.error('Erreur lors de la lecture ou du parsing de outdated.json :', err);
  process.exit(1); // on sort si le JSON est invalide
}

// On vérifie que packages existe
const packages = jsonData?.packages || [];

let markdown = '# Changelog des packages Flutter upgradable\n\n';
markdown += '| Package | Version actuelle | Version compatible | Dernière version |\n';
markdown += '|---------|-----------------|------------------|----------------|\n';

for (const pkg of packages) {
  const packageName = pkg.package;
  const current = pkg.current?.version || '-';
  const upgradable = pkg.upgradable?.version || '-';
  const latest = pkg.latest?.version || '-';

  // On ne garde que les packages qui peuvent être mis à jour
  if (upgradable !== '-' && current !== upgradable) {
    markdown += `| ${packageName} | ${current} | ${upgradable} | ${latest} |\n`;
  }
}

try {
  fs.writeFileSync(changelogPath, markdown, 'utf8');
  console.log(`Changelog généré dans ${changelogPath}`);
} catch (err) {
  console.error('Erreur lors de l’écriture du changelog :', err);
  process.exit(1);
}
