# Guide d'Installation Flutter Windows et Test FinTrack Pro

## Contexte
Ce guide complet vous accompagne étape par étape pour installer Flutter sur Windows et tester l'application FinTrack Pro, une application Flutter Desktop pour la gestion financière d'entreprise.

## 1. Installation Flutter SDK Windows

### 1.1 Téléchargement du Flutter SDK
1. Rendez-vous sur le site officiel : https://flutter.dev/docs/get-started/install/windows
2. Téléchargez la dernière version stable du Flutter SDK (fichier .zip)
3. **Recommandation :** Placez le dossier dans `C:\flutter\` pour éviter les problèmes de permissions

### 1.2 Extraction et installation
1. Extrayez le fichier zip dans `C:\flutter\`
2. Le dossier contiendra : `flutter\bin\`, `flutter\packages\`, etc.

### 1.3 Configuration du PATH système
1. Ouvrez les **Paramètres Windows** (Win + I)
2. Recherchez **"Variables d'environnement"**
3. Cliquez sur **"Variables d'environnement"**
4. Dans **"Variables système"**, sélectionnez **"Path"** et cliquez sur **"Modifier"**
5. Cliquez sur **"Nouveau"** et ajoutez : `C:\flutter\bin`
6. Cliquez sur **"OK"** pour fermer toutes les fenêtres

### 1.4 Vérification de l'installation
Ouvrez l'Invite de commandes et exécutez :
```bash
flutter --version
```
**Résultat attendu :** Version de Flutter affichée (ex: Flutter 3.x.x • channel stable)

### 1.5 Installation via Chocolatey (alternative)
Si vous préférez une installation automatisée :
```bash
# Ouvrez PowerShell en tant qu'administrateur
choco install flutter
```

## 2. Installation dépendances Windows

### 2.1 Installation de Git
Git est requis pour certaines fonctionnalités Flutter et pour cloner le projet :
1. Téléchargez Git depuis : https://git-scm.com/download/win
2. Installez avec les options par défaut
3. Vérifiez l'installation :
```bash
git --version
```

### 2.2 Installation de Visual Studio Code (recommandé)
VS Code est l'IDE recommandé pour le développement Flutter :
1. Téléchargez depuis : https://code.visualstudio.com/
2. Installez avec les options par défaut
3. Installez l'extension Flutter : `Ctrl+Shift+P` > "Flutter: Install Flutter Extension"

### 2.3 Installation d'Android Studio (optionnel mais recommandé)
Bien que l'application soit desktop, Android Studio fournit des outils utiles :
1. Téléchargez depuis : https://developer.android.com/studio
2. Installez avec les SDK par défaut
3. Dans Android Studio : File > Settings > Appearance & Behavior > System Settings > Android SDK
4. Installez Android SDK Platform 33 (ou plus récent)

### 2.4 Vérification des dépendances
Exécutez flutter doctor pour vérifier l'installation :
```bash
flutter doctor
```

**Résultat attendu pour Windows :**
- [✓] Flutter (Channel stable, version actuelle)
- [✓] Windows Version (Windows 10 or later)
- [!] Visual Studio - develop for Windows (Requis pour Windows Desktop)
- [!] Android toolchain (optionnel)

## 3. Configuration environnement Windows

### 3.1 Activation du support Windows Desktop
Activez le développement desktop pour Windows :
```bash
flutter config --enable-windows-desktop
```

### 3.2 Installation de Visual Studio Build Tools
Pour compiler les applications Windows, installez Visual Studio Build Tools :
1. Téléchargez Visual Studio Build Tools depuis : https://visualstudio.microsoft.com/downloads/
2. Lors de l'installation, sélectionnez :
   - Workload "Desktop development with C++"
   - Composants individuels : Windows 10 SDK (dernière version)

### 3.3 Configuration des permissions Windows
Assurez-vous que votre compte utilisateur a les permissions nécessaires :
1. Ouvrez **Paramètres Windows** > **Mise à jour et sécurité** > **Pour les développeurs**
2. Activez le **Mode développeur**

### 3.4 Test des commandes Flutter
Vérifiez que toutes les commandes fonctionnent :
```bash
# Vérifier la configuration
flutter config

# Lister les appareils disponibles
flutter devices

# Vérifier l'état du doctor
flutter doctor -v
```

## 4. Navigation vers le projet FinTrack Pro

### 4.1 Ouverture de l'invite de commandes
1. Appuyez sur `Win + R`, tapez `cmd` et appuyez sur Entrée
2. Ou recherchez "Invite de commandes" dans le menu Démarrer

### 4.2 Navigation vers le dossier du projet
Naviguez vers le répertoire où se trouve le projet FinTrack Pro :
```bash
# Exemple si le projet est dans Documents
cd C:\Users\%USERNAME%\Documents\fintrack_pro

# Ou utiliser l'explorateur Windows pour copier le chemin complet
cd "chemin\vers\votre\dossier\fintrack_pro"
```

### 4.3 Vérification de la présence des fichiers du projet
Listez le contenu du dossier pour vérifier la structure :
```bash
dir
```

**Structure attendue du projet :**
```
fintrack_pro/
├── lib/
│   ├── main.dart
│   ├── core/
│   ├── features/
│   └── shared/
├── windows/
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md
```

### 4.4 Vérification des fichiers de configuration
Assurez-vous que les fichiers essentiels sont présents :
- `pubspec.yaml` : Configuration des dépendances
- `lib/main.dart` : Point d'entrée de l'application
- `windows/` : Configuration spécifique Windows

## 5. Installation des dépendances Flutter

### 5.1 Téléchargement des packages Flutter
Installez toutes les dépendances du projet :
```bash
flutter pub get
```

Cette commande :
- Télécharge tous les packages listés dans `pubspec.yaml`
- Crée le fichier `pubspec.lock` avec les versions exactes
- Configure les dépendances dans `.dart_tool/`

### 5.2 Vérification de l'installation des packages
Affichez la liste des dépendances installées :
```bash
flutter pub deps
```

**Dépendances principales attendues :**
- flutter_riverpod : Gestion d'état
- drift : Base de données SQLite
- fl_chart : Graphiques et chartes
- go_router : Navigation
- path_provider : Gestion des chemins de fichiers
- shared_preferences : Stockage local
- intl : Internationalisation

### 5.3 Génération des fichiers Drift (base de données)
Générez le code de la base de données :
```bash
flutter pub run build_runner build
```

Cette commande crée automatiquement :
- `lib/core/database/database.g.dart`
- Les classes de données pour les tables

### 5.4 Résolution des problèmes de dépendances
Si des erreurs surviennent :
```bash
# Nettoyer le cache
flutter pub cache repair

# Mettre à jour les versions
flutter pub upgrade

# Vérifier les conflits
flutter pub get --dry-run
```

## 6. Test de compilation

### 6.1 Analyse statique du code
Vérifiez qu'il n'y a pas d'erreurs dans le code :
```bash
flutter analyze
```

**Résultat attendu :** Pas d'erreurs fatales (quelques warnings sont acceptables).

### 6.2 Compilation pour Windows
Compilez l'application pour Windows Desktop :
```bash
flutter build windows
```

Cette commande :
- Génère l'exécutable dans `build\windows\runner\Release\`
- Crée `fintrack_pro.exe`
- Optimise le code pour la production

### 6.3 Test de démarrage en mode debug
Lancez l'application en mode développement :
```bash
flutter run -d windows
```

**Options de déploiement alternatives :**
```bash
# Démarrage dans Chrome (web)
flutter run -d chrome

# Démarrage dans Edge (web)
flutter run -d edge
```

### 6.4 Vérification du fonctionnement de base
L'application devrait démarrer avec :
- Fenêtre d'application native Windows
- Interface utilisateur moderne
- Écran de connexion
- Navigation fonctionnelle

## 7. Guide d'utilisation application FinTrack Pro

### 7.1 Interface utilisateur
FinTrack Pro présente une interface moderne et intuitive avec :
- **Design responsive :** Adapté aux écrans desktop Windows
- **Navigation latérale :** Menu principal pour accéder aux fonctionnalités
- **Thème cohérent :** Couleurs professionnelles et lisibles
- **Boutons d'action :** Boutons clairs pour les opérations principales

### 7.2 Authentification
**Identifiants de test :**
- **Email :** admin@fintrack.com
- **Mot de passe :** admin123

**Procédure de connexion :**
1. Lancez l'application
2. Entrez les identifiants ci-dessus
3. Cliquez sur "Se connecter"
4. Vous accédez au dashboard principal

### 7.3 Navigation dans l'application
**Menu principal :**
- **Dashboard :** Vue d'ensemble avec KPIs et graphiques
- **Activités :** Gestion des activités budgétaires
- **Transactions :** Gestion des transactions financières
- **Utilisateurs :** Administration des comptes utilisateur

**Navigation :**
- Utilisez la barre latérale pour naviguer entre les sections
- Les boutons de retour permettent de revenir en arrière
- L'interface maintient l'état de navigation

### 7.4 Fonctionnalités principales

#### Dashboard
- **KPIs affichés :**
  - Chiffre d'affaires total
  - Nombre de transactions
  - Activités en cours
  - Utilisateurs actifs
- **Graphiques :** Visualisation des tendances financières
- **Actualisation :** Bouton pour rafraîchir les données

#### Gestion des Activités
- **Créer une activité :** Bouton "+" pour ajouter une nouvelle activité
- **Modifier :** Clic droit sur une activité pour éditer
- **Supprimer :** Option de suppression avec confirmation
- **Statuts :** En cours, Terminée, Annulée

#### Gestion des Transactions
- **Nouvelle transaction :** Formulaire de saisie détaillé
- **Workflow d'approbation :** Boutons Approuver/Rejeter
- **Historique :** Liste complète avec filtres
- **Filtrage :** Par date, montant, statut

## 6. Dépannage et résolution de problèmes

### 6.1 Problèmes courants de compilation

#### Erreur : "flutter pub get" échoue
**Solution :**
```bash
# Vider le cache
flutter pub cache repair

# Mettre à jour pub
flutter pub get
```

#### Erreur de génération de code Drift
**Solution :**
```bash
# Supprimer les fichiers générés
rm lib/core/database/database.g.dart

# Régénérer
flutter pub run build_runner build
```

#### Erreur de plateforme non configurée
**Solution :**
```bash
flutter config --enable-[platform]-desktop
flutter doctor
```

### 6.2 Problèmes d'exécution

#### Application ne démarre pas
**Vérifications :**
- Flutter doctor passe tous les tests
- Aucune erreur de compilation
- Plateforme desktop activée
- Ports 8080 et 8443 libres

#### Interface utilisateur défaillante
**Solution :**
```bash
# Redémarrer l'application
flutter clean
flutter pub get
flutter run -d [platform]
```

### 6.3 Problèmes de performance

#### Application lente au démarrage
**Optimisations :**
- Vérifier la taille de la base de données
- Nettoyer les fichiers temporaires
- Mettre à jour Flutter à la dernière version

#### Mémoire consommée excessive
**Solution :**
- Fermer les autres applications
- Augmenter la RAM allouée si possible
- Vérifier les fuites mémoire dans les providers

### 6.4 Problèmes de base de données

#### Données corrompues
**Solution :**
```bash
# Supprimer la base de données locale
rm -rf [user_data]/fintrack_pro/database/

# Redémarrer l'application pour recréer la DB
flutter run -d [platform]
```

#### Migrations échouées
**Solution :**
- Vérifier les fichiers de migration dans `lib/core/database/migrations/`
- Restaurer une sauvegarde si disponible

## 7. Guide d'utilisation

### 7.1 Premiers pas
1. **Démarrage :** Lancer l'application via `flutter run`
2. **Connexion :** Utiliser les identifiants par défaut
3. **Exploration :** Naviguer dans les différentes sections

### 7.2 Fonctionnalités disponibles

#### Dashboard Principal
- Vue d'ensemble des KPIs financiers
- Graphiques de tendance
- Alertes et notifications

#### Gestion des Activités
- Création et suivi des activités budgétaires
- Assignation aux utilisateurs
- Suivi du statut (En cours, Terminée, etc.)

#### Gestion des Transactions
- Saisie des transactions financières
- Workflow d'approbation
- Historique complet

#### Administration
- Gestion des utilisateurs
- Configuration du système
- Exports de rapports

### 7.3 Interface utilisateur
- **Design :** Interface moderne et intuitive
- **Responsive :** Adaptée aux écrans desktop
- **Thème :** Couleurs cohérentes et lisibles
- **Accessibilité :** Navigation au clavier supportée

### 7.4 Workflow de test
1. **Test unitaire :** Chaque fonctionnalité individuellement
2. **Test d'intégration :** Flux complets utilisateur
3. **Test de performance :** Chargement et navigation
4. **Test de stabilité :** Utilisation prolongée

---

## Commandes de référence rapide

```bash
# Installation
flutter pub get
flutter pub run build_runner build

# Tests
flutter analyze
flutter test

# Compilation
flutter build [platform]

# Démarrage
flutter run -d [platform]

# Nettoyage
flutter clean
flutter pub cache repair
```

## Support et contact
Pour toute question ou problème non résolu, consultez :
- Documentation Flutter : https://flutter.dev/docs
- Issues GitHub du projet
- Équipe de développement FinTrack Pro