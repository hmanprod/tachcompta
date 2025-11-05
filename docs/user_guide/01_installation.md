# Guide d'Installation - FinTrack Pro

## Vue d'ensemble

FinTrack Pro est une application desktop Flutter multiplateforme conçue pour la gestion financière d'entreprises. Ce guide fournit des instructions détaillées d'installation pour Windows, macOS et Linux.

## Prérequis Système

### Configuration Minimale
- **OS** : Windows 10+, macOS 10.15+, Ubuntu 18.04+ ou équivalent
- **RAM** : 4 Go minimum (8 Go recommandé)
- **Disque** : 500 Mo d'espace libre
- **Processeur** : Intel/AMD x64 ou Apple Silicon (avec Rosetta 2)

### Configuration Recommandée
- **RAM** : 8 Go ou plus
- **Disque SSD** : 1 Go d'espace libre pour les données utilisateur
- **Écran** : 1920x1080 minimum (support 4K)

## Installation par Plateforme

### Windows

#### Méthode 1 : Installation Automatique (Recommandée)

1. **Téléchargement**
   - Rendez-vous sur le site officiel de FinTrack Pro
   - Téléchargez le fichier `FinTrackPro-Setup.exe`
   - Vérifiez l'intégrité du fichier avec le checksum fourni

2. **Installation**
   ```
   FinTrackPro-Setup.exe
   ```
   - Cliquez sur "Suivant" pour commencer
   - Acceptez les termes de la licence
   - Choisissez le dossier d'installation (défaut : `C:\Program Files\FinTrack Pro`)
   - Cliquez sur "Installer"

3. **Premier Lancement**
   - Lancez FinTrack Pro depuis le menu Démarrer
   - Ou double-cliquez sur l'icône du bureau

#### Méthode 2 : Installation Manuelle

1. **Installation de Flutter**
   ```bash
   # Télécharger Flutter SDK depuis https://flutter.dev
   # Extraire dans C:\flutter
   # Ajouter au PATH : C:\flutter\bin
   ```

2. **Configuration du Projet**
   ```bash
   cd chemin/vers/fintrack_pro
   flutter pub get
   flutter build windows --release
   ```

3. **Démarrage**
   ```bash
   flutter run -d windows
   ```

### macOS

#### Installation Automatique

1. **Téléchargement**
   - Téléchargez `FinTrackPro.dmg` depuis le site officiel
   - Ouvrez le fichier DMG

2. **Installation**
   - Glissez l'icône FinTrack Pro dans le dossier Applications
   - Lancez l'application depuis le Launchpad ou Spotlight

#### Installation Développeur

1. **Prérequis**
   ```bash
   # Installation Xcode
   xcode-select --install

   # Installation Flutter
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

2. **Configuration**
   ```bash
   cd chemin/vers/fintrack_pro
   flutter config --enable-macos-desktop
   flutter pub get
   flutter build macos --release
   ```

### Linux

#### Installation Automatique (Ubuntu/Debian)

1. **Téléchargement**
   ```bash
   wget https://site-officiel.com/fintrack-pro/linux/fintrack-pro.deb
   ```

2. **Installation**
   ```bash
   sudo dpkg -i fintrack-pro.deb
   sudo apt-get install -f  # Résoudre les dépendances
   ```

3. **Lancement**
   ```bash
   fintrack-pro
   ```

#### Installation Manuelle

1. **Prérequis**
   ```bash
   # Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

   # Installation Flutter
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

2. **Configuration**
   ```bash
   cd chemin/vers/fintrack_pro
   flutter config --enable-linux-desktop
   flutter pub get
   flutter build linux --release
   ```

3. **Démarrage**
   ```bash
   ./build/linux/x64/release/bundle/fintrack_pro
   ```

## Configuration Post-Installation

### Création du Premier Administrateur

1. **Lancement Initial**
   - Au premier lancement, l'application détecte qu'aucun utilisateur n'existe
   - L'écran de configuration initiale s'affiche automatiquement

2. **Création de l'Admin**
   - **Email** : admin@fintrack.pro (recommandé pour la démo)
   - **Mot de passe** : Choisissez un mot de passe fort (8+ caractères)
   - **Informations** : Nom complet et poste

3. **Validation**
   - L'application crée automatiquement la base de données
   - Un utilisateur administrateur est créé avec tous les droits

### Paramètres de Base

1. **Accédez aux Paramètres**
   - Connectez-vous avec le compte admin
   - Allez dans Paramètres → Configuration Système

2. **Configuration Requise**
   - **Nom de l'Entreprise** : Votre nom d'entreprise
   - **Devise** : EUR, USD, ou autre
   - **Format Date** : JJ/MM/AAAA (Europe) ou MM/JJ/AAAA (US)
   - **Langue** : Français (support anglais disponible)

## Vérification de l'Installation

### Tests Fonctionnels

1. **Connexion Administrateur**
   - Utilisez les identifiants créés lors de l'installation

2. **Création d'une Activité Test**
   - Allez dans "Activités" → "Nouvelle Activité"
   - Créez une activité "Test" de type "Magasin"

3. **Saisie d'une Transaction**
   - Dans l'activité Test, cliquez "Ajouter Transaction"
   - Saisissez une recette de 100€
   - Vérifiez que les KPIs se mettent à jour

### Diagnostics Système

L'application inclut un outil de diagnostic accessible via :
- Paramètres → Diagnostic Système
- Vérifie la connectivité base de données
- Teste les permissions fichier
- Valide l'intégrité des données

## Dépannage Installation

### Problèmes Courants Windows

**Erreur "MSVCP140.dll manquant"**
```
Solution : Installez Microsoft Visual C++ Redistributable
Téléchargement : https://aka.ms/vs/17/release/vc_redist.x64.exe
```

**Problème de Permissions**
```
Solution : Lancez en tant qu'Administrateur
Ou vérifiez les droits du dossier Program Files
```

### Problèmes Courants macOS

**Erreur "App non vérifiée"**
```
Solution : Ouvrez les Préférences Système → Sécurité
Cliquez "Ouvrir quand même" pour FinTrack Pro
```

**Problème Xcode**
```
Solution : Acceptez la licence Xcode
sudo xcodebuild -license accept
```

### Problèmes Courants Linux

**Dépendances Manquantes**
```bash
# Ubuntu/Debian
sudo apt-get install libgtk-3-dev libxss1 libgconf-2-4 libxrandr2 libasound2 libpangocairo-1.0-0 libatk1.0-0 libcairo-gobject2 libgtk-3-0 libgdk-pixbuf2.0-0

# Fedora/CentOS
sudo dnf install gtk3-devel libXScrnSaver GConf2 libXrandr alsa-lib pango cairo atk cairo-gobject gtk3 gdk-pixbuf2
```

**Problème de Display**
```
Solution : Assurez-vous que la variable DISPLAY est définie
echo $DISPLAY
```

## Mise à Jour

### Mise à Jour Automatique
- L'application vérifie automatiquement les mises à jour au lancement
- Une notification apparaît lorsqu'une nouvelle version est disponible
- Cliquez "Mettre à jour" pour installer automatiquement

### Mise à Jour Manuelle
1. Téléchargez la nouvelle version depuis le site officiel
2. Fermez FinTrack Pro
3. Installez la nouvelle version (elle remplace l'ancienne)
4. Relancez l'application

## Désinstallation

### Windows
- Allez dans Paramètres → Applications → FinTrack Pro
- Cliquez "Désinstaller"
- Ou utilisez l'outil "Programmes et fonctionnalités"

### macOS
- Glissez l'application du dossier Applications vers la Corbeille
- Videz la Corbeille

### Linux
```bash
# Ubuntu/Debian
sudo apt-get remove fintrack-pro

# Suppression des données utilisateur
rm -rf ~/.fintrack_pro
```

## Support Technique

En cas de problème lors de l'installation :

- **Documentation** : Consultez ce guide ou la FAQ
- **Logs** : Vérifiez les logs dans `%APPDATA%/fintrack_pro/logs` (Windows)
- **Support** : Contactez support@fintrack.pro avec les détails du problème

---

*FinTrack Pro v1.0 - Guide d'installation - Mis à jour le 31/10/2025*