# Guide Complet : Lancement et Test de FinTrack Pro sur Windows

## Vue d'ensemble

Ce guide vous accompagne étape par étape pour installer, lancer et tester l'application **FinTrack Pro** sur votre ordinateur Windows. FinTrack Pro est une application Flutter Desktop de gestion financière d'entreprise offrant une interface moderne et intuitive pour la gestion des activités budgétaires et des transactions financières.

## Table des matières

1. [Prérequis système](#1-prérequis-système)
2. [Installation de Flutter](#2-installation-de-flutter)
3. [Configuration de l'environnement Windows](#3-configuration-de-lenvironnement-windows)
4. [Lancement en mode développement](#4-lancement-en-mode-développement)
5. [Compilation pour différentes plateformes](#5-compilation-pour-différentes-plateformes)
6. [Tests fonctionnels](#6-tests-fonctionnels)
7. [Résolution de problèmes courants](#7-résolution-de-problèmes-courants)

---

## 1. Prérequis système

### Configuration minimale requise

| Composant | Configuration minimale | Configuration recommandée |
|-----------|----------------------|---------------------------|
| **OS** | Windows 10 (version 1903+) | Windows 11 |
| **CPU** | Intel i3 / AMD Ryzen 3 | Intel i5 / AMD Ryzen 5 |
| **RAM** | 8 GB | 16 GB |
| **Stockage** | 5 GB libre | 10 GB SSD |
| **Écran** | 1366x768 | 1920x1080 |

### Logiciels requis

#### Flutter SDK
- **Version** : 3.0.0 ou supérieure
- **Téléchargement** : https://flutter.dev/docs/get-started/install/windows
- **Installation** : Extraire dans `C:\flutter\`

#### Visual Studio Code (recommandé)
- **Téléchargement** : https://code.visualstudio.com/
- **Extensions** :
  - Flutter
  - Dart
  - Material Icon Theme

#### Git
- **Version** : 2.0+
- **Téléchargement** : https://git-scm.com/download/win

#### Android Studio (optionnel mais recommandé)
- **Téléchargement** : https://developer.android.com/studio
- **SDK requis** : Android SDK Platform 33+

### Liens de téléchargement

| Logiciel | Lien officiel |
|----------|---------------|
| Flutter SDK | https://flutter.dev/docs/get-started/install/windows |
| VS Code | https://code.visualstudio.com/ |
| Git | https://git-scm.com/download/win |
| Android Studio | https://developer.android.com/studio |
| Visual Studio Build Tools | https://visualstudio.microsoft.com/downloads/ |

---

## 2. Installation de Flutter

### 2.1 Téléchargement et extraction

```bash
# Téléchargez la dernière version stable depuis flutter.dev
# Extrayez le fichier zip dans C:\flutter\
# Structure attendue après extraction :
C:\flutter\
├── bin\
│   ├── flutter.bat
│   ├── dart.bat
│   └── ...
├── packages\
└── ...
```

### 2.2 Configuration du PATH système

1. **Ouvrir les paramètres système** :
   - Win + R → `sysdm.cpl` → Onglet "Paramètres système avancés"
   - Ou : Paramètres → "Variables d'environnement"

2. **Ajouter Flutter au PATH** :
   - Variable système "Path"
   - Nouveau : `C:\flutter\bin`

3. **Vérification** :
```bash
flutter --version
# Résultat attendu : Flutter 3.x.x • channel stable • ...
```

### 2.3 Installation automatique (alternative)

```bash
# Via Chocolatey (si installé)
choco install flutter
```

---

## 3. Configuration de l'environnement Windows

### 3.1 Activation du développement desktop

```bash
# Activer le support Windows Desktop
flutter config --enable-windows-desktop

# Vérifier la configuration
flutter config
```

### 3.2 Installation de Visual Studio Build Tools

**Pourquoi ?** Nécessaire pour compiler des applications Windows natives.

1. **Téléchargement** : https://visualstudio.microsoft.com/downloads/
2. **Installation** :
   - Sélectionner "Desktop development with C++"
   - Composants requis :
     - MSVC v143 - VS 2022 C++ x64/x86 build tools
     - Windows 10 SDK (dernière version)
     - C++ CMake tools for Windows

3. **Vérification** :
```bash
flutter doctor
# ✓ Visual Studio - develop for Windows (Visual Studio Build Tools 2022)
```

### 3.3 Permissions développeur Windows

```bash
# Activer le mode développeur (si nécessaire)
# Paramètres → Mise à jour et sécurité → Pour les développeurs
# Activer "Mode développeur"
```

### 3.4 Test des commandes essentielles

```bash
# Lister les appareils disponibles
flutter devices

# Vérifier l'état complet
flutter doctor -v
```

**Résultat attendu pour Windows :**
```
[✓] Flutter (Channel stable, 3.x.x, on Microsoft Windows...)
[✓] Windows Version (Installed version of Windows is version 10...)
[✓] Android toolchain - develop for Android devices (requis si Android Studio)
[✓] Visual Studio - develop for Windows
[!] Connected device (aucun appareil connecté)
```

---

## 4. Lancement en mode développement

### 4.1 Navigation vers le projet

```bash
# Ouvrir l'invite de commandes
Win + R → cmd → Entrée

# Naviguer vers le dossier du projet
cd C:\path\to\your\fintrack_pro

# Vérifier la présence des fichiers
dir
```

**Structure attendue :**
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
└── README.md
```

### 4.2 Installation des dépendances

```bash
# Télécharger toutes les dépendances
flutter pub get

# Générer le code de base de données (Drift)
flutter pub run build_runner build

# Vérifier les dépendances
flutter pub deps
```

### 4.3 Analyse du code (recommandé)

```bash
# Vérifier qu'il n'y a pas d'erreurs
flutter analyze

# Résultat attendu : No issues found!
```

### 4.4 Lancement de l'application

#### Mode développement Windows Desktop
```bash
flutter run -d windows
```

#### Autres options de lancement

```bash
# Mode web (Chrome)
flutter run -d chrome

# Mode web (Edge)
flutter run -d edge

# Mode debug avec options
flutter run -d windows --debug

# Mode profile (optimisations)
flutter run -d windows --profile
```

### 4.5 Options de débogage

#### Démarrage avec debugging étendu
```bash
# Activer les logs détaillés
flutter run -d windows --verbose

# Désactiver les optimisations JIT
flutter run -d windows --no-enable-impeller

# Démarrage avec observatoire (profiling)
flutter run -d windows --observatory-port=8888
```

#### Connexion avec émulateurs/simulateurs

```bash
# Lister tous les appareils disponibles
flutter devices

# Démarrer sur un appareil spécifique
flutter run -d windows

# Démarrer sur émulateur Android (si configuré)
flutter run -d emulator-5554
```

---

## 5. Compilation pour différentes plateformes

### 5.1 Application Windows Desktop (principale)

```bash
# Compilation en mode release
flutter build windows

# Compilation avec optimisations
flutter build windows --release

# Compilation avec support des assets
flutter build windows --release --obfuscate --split-debug-info=build/debug-info
```

**Résultat :**
- Exécutable : `build\windows\runner\Release\fintrack_pro.exe`
- Taille approximative : 150-200 MB
- Prêt pour distribution

### 5.2 Application Android (APK)

```bash
# Générer APK debug
flutter build apk

# Générer APK release (nécessite configuration keystore)
flutter build apk --release

# Générer bundle (recommandé pour Play Store)
flutter build appbundle
```

**Résultat :**
- Debug APK : `build\app\outputs\flutter-apk\app-debug.apk`
- Release APK : `build\app\outputs\flutter-apk\app-release.apk`

### 5.3 Application Web (optionnel)

```bash
# Compiler pour le web
flutter build web

# Servir localement pour test
flutter run -d chrome

# Déployer (nécessite serveur web)
# Copier build/web/* vers votre serveur
```

**Résultat :**
- Build web : `build\web\`
- Application accessible via navigateur

### 5.4 Commandes de compilation avancées

```bash
# Compilation avec analyse des performances
flutter build windows --analyze-size

# Compilation avec génération de code source maps
flutter build windows --source-maps

# Compilation multi-plateformes
flutter build apk && flutter build windows && flutter build web
```

---

## 6. Tests fonctionnels

### 6.1 Identifiants de connexion

**Compte administrateur de test :**
- **Email :** admin@fintrack.com
- **Mot de passe :** admin123

**Comptes utilisateur de test :**
- **Agent :** agent@fintrack.com / agent123
- **Utilisateur :** user@fintrack.com / user123

### 6.2 Écran de connexion

1. **Lancement** : L'application démarre sur l'écran de connexion
2. **Interface** :
   - Champ email avec validation
   - Champ mot de passe masqué
   - Bouton "Se connecter"
   - Lien "Mot de passe oublié" (optionnel)

3. **Test de connexion** :
   - Saisir `admin@fintrack.com`
   - Saisir `admin123`
   - Cliquer "Se connecter"
   - **Résultat attendu** : Redirection vers le dashboard

### 6.3 Navigation dans l'application

#### Menu principal (selon le rôle)

**Administrateur :**
- Dashboard (avec tous les KPIs)
- Activités budgétaires
- Transactions
- Gestion utilisateurs
- Paramètres système

**Agent :**
- Dashboard (KPIs filtrés)
- Activités budgétaires
- Transactions (avec validation)
- Gestion utilisateurs (limitée)

**Utilisateur standard :**
- Dashboard personnel
- Mes activités
- Mes transactions
- Historique

#### Test de navigation
1. **Vérifier l'accès aux menus**
2. **Tester la navigation fluide**
3. **Vérifier les permissions** (éléments grisés/cachés selon rôle)

### 6.4 Fonctionnalités principales

#### Dashboard
- **KPIs affichés** :
  - Chiffre d'affaires total
  - Nombre de transactions
  - Activités actives
  - Utilisateurs connectés
- **Graphiques** : Tendances et répartitions
- **Actions** : Bouton de rafraîchissement des données

#### Gestion des Activités
1. **Créer une activité** :
   - Bouton "+" ou "Nouvelle activité"
   - Formulaire : Nom, Description, Budget, Dates
   - Assignation d'utilisateurs

2. **Modifier/Supprimer** :
   - Clic droit sur activité
   - Menu contextuel avec options

3. **Filtrage** :
   - Par statut (Active, Terminée, etc.)
   - Par utilisateur assigné

#### Gestion des Transactions
1. **Créer une transaction** :
   - Depuis dashboard ou menu
   - Formulaire détaillé :
     - Activité liée
     - Type (Recette/Dépense)
     - Montant et devise
     - Description détaillée
     - Date de l'opération

2. **Workflow d'approbation** :
   - Statuts : Brouillon → En attente → Approuvé/Rejeté
   - Notifications d'approbation
   - Historique des modifications

3. **Filtrage avancé** :
   - Par période
   - Par montant
   - Par statut d'approbation

#### Gestion des Utilisateurs (Admin seulement)
1. **Créer un utilisateur** :
   - Formulaire avec rôle (Admin/Agent/User)
   - Gestion des permissions

2. **Modifier les profils**
3. **Désactiver/Activer des comptes**

### 6.5 Tests de performance

#### Démarrage de l'application
```bash
# Mesurer le temps de démarrage
time flutter run -d windows
# Objectif : < 5 secondes
```

#### Navigation fluide
- **Test** : Naviguer rapidement entre les écrans
- **Objectif** : Pas de lag perceptible (< 100ms)

#### Gestion des données
- **Test** : Importer/exporter des données
- **Objectif** : Opérations < 2 secondes

### 6.6 Tests de stabilité

#### Utilisation prolongée
- **Test** : Application ouverte 1 heure avec opérations
- **Vérifier** : Pas de fuites mémoire, performance stable

#### Gestion d'erreurs
- **Test** : Entrées invalides, connexions perdues
- **Vérifier** : Messages d'erreur appropriés, récupération gracieuse

---

## 7. Résolution de problèmes courants

### 7.1 Problèmes d'installation Flutter

#### "flutter command not found"
```bash
# Vérifier le PATH
echo %PATH%

# Ajouter manuellement si nécessaire
set PATH=%PATH%;C:\flutter\bin

# Test
flutter --version
```

#### Flutter doctor montre des erreurs
```bash
# Mise à jour complète
flutter upgrade

# Réparation du cache
flutter doctor --android-licenses
flutter pub cache repair
```

### 7.2 Problèmes de compilation Windows

#### Erreur Visual Studio Build Tools
```
[!] Visual Studio - develop for Windows (Visual Studio 2022 or later is required)
```

**Solution :**
```bash
# Réinstaller Visual Studio Build Tools
# OU vérifier l'installation existante
flutter doctor -v

# Forcer la redétection
flutter config --enable-windows-desktop
```

#### Erreur de génération de code Drift
```bash
# Nettoyer et régénérer
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7.3 Problèmes d'exécution

#### Application ne démarre pas
**Vérifications :**
1. **Dependencies** : `flutter pub get` réussi
2. **Build Tools** : Visual Studio correctement installé
3. **Permissions** : Mode développeur activé
4. **Ports** : 8080 et 8443 libres

**Solution :**
```bash
# Nettoyer et relancer
flutter clean
flutter pub get
flutter run -d windows
```

#### Interface utilisateur défaillante
```bash
# Forcer le redémarrage
flutter clean
flutter pub get
flutter run -d windows --no-enable-impeller
```

#### Performances lentes
```bash
# Mode release pour optimisation
flutter run -d windows --release

# Vérifier utilisation ressources
# Task Manager → onglet Performances
```

### 7.4 Problèmes de base de données

#### Données corrompues
```bash
# Supprimer la base locale (Windows)
rmdir /s %APPDATA%\fintrack_pro\database

# Redémarrer l'application
flutter run -d windows
```

#### Migrations échouées
- Vérifier `lib/core/database/migrations/`
- Restaurer sauvegarde si disponible
- Contacter l'équipe de développement

### 7.5 Problèmes réseau (si fonctionnalités en ligne)

#### Connexion Supabase perdue
```bash
# Vérifier la connectivité
ping api.supabase.co

# Vérifier la configuration réseau
flutter run -d windows --verbose
```

### 7.6 Problèmes spécifiques aux émulateurs

#### Émulateur Android non détecté
```bash
# Lister les appareils
flutter devices

# Redémarrer adb
adb kill-server
adb start-server

# Relancer l'émulateur
flutter emulators --launch emulator-name
```

### 7.7 Commandes de diagnostic avancées

```bash
# Logs détaillés
flutter run -d windows --verbose

# Analyse des dépendances
flutter pub deps --style=compact

# Vérification des assets
flutter build windows --analyze-size

# Test unitaire isolé
flutter test --coverage
```

### 7.8 Support et debug avancé

#### Captures d'écran recommandées
- Erreur complète avec stack trace
- Configuration Flutter doctor
- Structure du projet
- Logs de console

#### Informations à fournir au support
```
Flutter version: 3.x.x
Windows version: 10/11 (build XXXX)
Visual Studio: 2022 (version XX.X)
Erreur exacte: [coller le message]
Étapes pour reproduire: [description détaillée]
```

---

## Commandes de référence rapide

### Installation et configuration
```bash
# Vérification système
flutter doctor -v

# Installation dépendances
flutter pub get
flutter pub run build_runner build

# Configuration Windows
flutter config --enable-windows-desktop
```

### Développement
```bash
# Démarrage développement
flutter run -d windows

# Avec debug étendu
flutter run -d windows --verbose

# Analyse code
flutter analyze
```

### Compilation
```bash
# Windows Desktop
flutter build windows --release

# Android
flutter build apk --release

# Web
flutter build web
```

### Dépannage
```bash
# Nettoyage complet
flutter clean
flutter pub cache repair

# Redémarrage services
flutter pub get
flutter run -d windows
```

---

## Interfaces principales - Descriptions

### Écran de connexion
```
┌─────────────────────────────────────┐
│           FinTrack Pro              │
│                                     │
│ Email: [_______________________]    │
│                                     │
│ Mot de passe: [*****************]   │
│                                     │
│          [   Se connecter   ]       │
│                                     │
│      Mot de passe oublié ?          │
└─────────────────────────────────────┘
```

### Dashboard Principal (Admin)
```
┌─────────────────────────────────────┐
│ 🏠 Dashboard           👤 Admin      │
├─────────────────────────────────────┤
│ KPIs:                               │
│ • CA Total: 2,450,000 €             │
│ • Transactions: 1,234               │
│ • Activités: 12                     │
│ • Utilisateurs: 45                  │
├─────────────────────────────────────┤
│ 📊 Graphiques de tendance           │
│                                     │
│ 📋 Menu:                            │
│ • Dashboard                         │
│ • Activités                         │
│ • Transactions                      │
│ • Utilisateurs                      │
│ • Paramètres                        │
└─────────────────────────────────────┘
```

---

*Guide créé le 03 novembre 2025 - FinTrack Pro v1.0.0*