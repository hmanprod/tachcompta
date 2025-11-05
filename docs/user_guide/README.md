# Guide Utilisateur FinTrack Pro

## Vue d'ensemble

Bienvenue dans la documentation utilisateur complète de **FinTrack Pro**, l'application desktop de gestion financière d'entreprise développée avec Flutter.

Cette documentation couvre tous les aspects du logiciel, des premiers pas à l'administration avancée, pour permettre à tous les utilisateurs de maîtriser efficacement FinTrack Pro.

## Structure de la Documentation

### 📚 Guides par Rôle

#### Pour Tous les Utilisateurs
- **[01_installation.md](01_installation.md)** - Guide d'installation complet (Windows/Mac/Linux)
- **[02_premiers_pas.md](02_premiers_pas.md)** - Premiers pas et configuration initiale

#### Guides Spécialisés par Rôle
- **[03_guide_administrateur.md](03_guide_administrateur.md)** - Administration système et gestion utilisateurs
- **[04_guide_agent_si.md](04_guide_agent_si.md)** - Validation transactions et gestion activités
- **[05_guide_utilisateur.md](05_guide_utilisateur.md)** - Saisie transactions quotidienne

### 🔧 Documentation Technique

#### Fonctionnalités Détaillées
- **[06_fonctionnalites_detaillees.md](06_fonctionnalites_detaillees.md)** - Toutes les fonctionnalités techniques
- **[07_configuration_avancee.md](07_configuration_avancee.md)** - Paramètres avancés et personnalisation
- **[08_export_rapports.md](08_export_rapports.md)** - Exports et génération de rapports

#### Support et Maintenance
- **[09_troubleshooting.md](09_troubleshooting.md)** - Dépannage et FAQ
- **[10_annexes_techniques.md](10_annexes_techniques.md)** - Architecture et spécifications techniques

## 🎯 Rôles et Permissions

### Matrice des Permissions

| Fonctionnalité | Administrateur | Agent SI | Utilisateur |
|---|---|---|---|
| **Installation & Configuration** | ✅ | ❌ | ❌ |
| **Gestion Utilisateurs** | ✅ | ❌ | ❌ |
| **Création Activités** | ✅ | ✅ | ❌ |
| **Validation Transactions** | ✅ | ✅ | ❌ |
| **Saisie Transactions** | ✅ | ✅ | ✅ |
| **Consultation Données** | ✅ | ✅ | ✅ (limité) |
| **Exports & Rapports** | ✅ | ✅ | ✅ (personnel) |
| **Configuration Avancée** | ✅ | ❌ | ❌ |

### Comptes de Test Recommandés

Pour explorer toutes les fonctionnalités :
- **Administrateur** : `admin@fintrack.pro`
- **Agent SI** : `agent@fintrack.pro`
- **Utilisateur** : `user@fintrack.pro`

## 🚀 Démarrage Rapide

### 1. Installation
Suivez le **[Guide d'Installation](01_installation.md)** selon votre système d'exploitation.

### 2. Première Connexion
- Lancez FinTrack Pro
- Créez l'administrateur avec `admin@fintrack.pro`
- Configurez les paramètres de base

### 3. Configuration Initiale
- **[Premiers Pas](02_premiers_pas.md)** pour la configuration générale
- Création des utilisateurs selon les rôles
- Paramétrage des activités principales

### 4. Formation par Rôle
- **Administrateur** → Consultez le guide dédié pour la gestion système
- **Agent SI** → Maîtrisez les workflows de validation
- **Utilisateur** → Apprenez la saisie des transactions

## 📋 Fonctionnalités Principales

### ✅ Authentification et Sécurité
- Connexion sécurisée avec hash des mots de passe
- Gestion des sessions et timeout automatique
- Rôles et permissions granulaires
- Audit trail complet des actions

### ✅ Gestion des Activités
- Création d'activités (Magasin, Transport, Autre)
- Assignation utilisateurs par activité
- États : Active, Suspendue, Fermée
- Clôture avec calcul des soldes finaux

### ✅ Transactions Financières
- Saisie recettes et dépenses
- Workflow d'approbation : Brouillon → En attente → Approuvé/Rejeté → Complété
- Documents justificatifs (PDF, JPG, PNG)
- Validation automatique selon seuils

### ✅ KPIs et Tableaux de Bord
- 4 KPIs principaux en temps réel
- Graphiques interactifs (lignes, barres, secteurs)
- Dashboards personnalisables
- Mise à jour automatique des calculs

### ✅ Exports et Rapports
- Formats : CSV, Excel, PDF, JSON
- Exports programmés et manuels
- Rapports personnalisés avec éditeur
- Intégrations ERP (FEC, SAF-T)

### ✅ Notifications et Alertes
- Notifications en temps réel
- Alertes seuils dépassés
- Rappels échéances
- Paramètres personnalisables

## 🔧 Configuration Avancée

### Paramètres Système
- Configuration base de données et performances
- Politiques de sécurité et mots de passe
- Paramètres régionaux (devise, date, langue)
- Synchronisation cloud optionnelle

### Personnalisation Métier
- Règles d'approbation personnalisées
- Seuils et alertes configurables
- Modèles de rapports sur mesure
- Intégrations externes (APIs, webhooks)

## 🆘 Support et Assistance

### Ressources Disponibles

#### Documentation Contextuelle
- Aide intégrée avec `F1`
- Infobulles explicatives
- Messages d'erreur détaillés

#### Support Technique
- **Email** : support@fintrack.pro
- **Forum** : community.fintrack.pro
- **Chat** : Interface application
- **Téléphone** : 01-XX-XX-XX-XX (9h-18h CET)

### Priorités de Support
- **Critique** : Application indisponible, données perdues
- **Important** : Fonctionnalité défaillante
- **Normal** : Questions générales, demandes évolution

### Génération Rapport Support
Bouton "Générer Rapport Support" collectant automatiquement :
- Version application et système
- Configuration actuelle
- Logs erreurs récents
- Métriques performance

## 📊 Métriques et Performance

### Indicateurs de Qualité
- **Disponibilité** : 99.9% uptime garanti
- **Performance** : < 2 secondes temps réponse moyen
- **Sécurité** : Conformité RGPD, audit trails
- **Évolutivité** : Support jusqu'à 10GB base données

### Recommandations Système
- **Minimum** : 4GB RAM, 500MB disque
- **Recommandé** : 8GB RAM, 1GB SSD
- **Optimal** : 16GB RAM, SSD NVMe

## 🔄 Mises à Jour et Évolution

### Canal de Mise à Jour
- **Stable** : Versions validées en production
- **Beta** : Fonctionnalités avancées testées
- **Dev** : Versions développement (experts)

### Processus de Mise à Jour
- Détection automatique des nouvelles versions
- Téléchargement en arrière-plan
- Installation sans interruption service
- Rollback automatique en cas de problème

### Feuille de Route
- **v1.1** : Synchronisation cloud avancée
- **v1.2** : API REST complète
- **v1.3** : Intelligence artificielle prédictive
- **v2.0** : Interface web complémentaire

## 📖 Glossaire

### Termes Métier
- **Activité** : Entité économique (magasin, transport) traçant recettes/dépenses
- **Transaction** : Opération financière (recette ou dépense)
- **KPI** : Indicateur clé de performance calculé automatiquement
- **Workflow** : Processus d'approbation des transactions

### Termes Techniques
- **Clean Architecture** : Structure modulaire pour maintenabilité
- **SQLite + Drift** : Base de données locale avec ORM
- **Riverpod** : Gestion d'état réactive
- **Flutter Desktop** : Framework multiplateforme

## 📞 Contact et Informations

### Éditeur
**FinTrack Software SAS**
123 Avenue des Technologies
75001 Paris, France

### Support Commercial
- **Site web** : https://fintrack-pro.com
- **Email** : contact@fintrack-pro.com
- **Téléphone** : 01-XX-XX-XX-XX

### Licence
FinTrack Pro est distribué sous licence propriétaire.
Versions d'évaluation disponibles sur demande.

---

*Documentation FinTrack Pro v1.0 - Dernière mise à jour : 31/10/2025*

**Retour à l'accueil** | **[Installation](01_installation.md)** | **[Premiers Pas](02_premiers_pas.md)**