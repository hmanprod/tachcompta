# Premiers Pas avec FinTrack Pro

## Vue d'ensemble

Ce guide vous accompagne dans vos premiers pas avec FinTrack Pro, de la connexion initiale à la configuration de base de votre système de gestion financière.

## Connexion Initiale

### Premier Lancement

Au premier lancement de FinTrack Pro, l'application détecte qu'aucun utilisateur administrateur n'existe encore. L'écran de configuration initiale s'affiche automatiquement.

### Création de l'Administrateur

1. **Informations Requises**
   - **Email** : Utilisez `admin@fintrack.pro` pour la démonstration
   - **Mot de passe** : Minimum 8 caractères avec majuscules, minuscules et chiffres
   - **Nom complet** : Votre nom et prénom
   - **Poste** : Administrateur Système

2. **Validation**
   - Cliquez sur "Créer Administrateur"
   - L'application crée automatiquement la base de données locale
   - Vous êtes automatiquement connecté avec le rôle Administrateur

### Connexion Ultérieures

1. **Démarrage**
   - Lancez FinTrack Pro depuis votre bureau ou menu applications
   - L'écran de connexion s'affiche

2. **Authentification**
   - **Email** : admin@fintrack.pro (ou votre email)
   - **Mot de passe** : Le mot de passe défini lors de la création
   - Cliquez "Se connecter"

## Interface Utilisateur

### Présentation Générale

FinTrack Pro utilise une interface intuitive avec :

- **Header de Navigation** : Menu principal, notifications, profil utilisateur
- **Zone Centrale** : Contenu principal selon la section sélectionnée
- **Navigation Latérale** : Accès rapide aux modules (visible selon le rôle)

### Navigation Principale

#### Menu Principal (Header)
- **Logo FinTrack** : Retour au dashboard
- **Navigation Pills** :
  - Dashboard (aperçu général)
  - Activités (gestion des activités)
  - Transactions (saisie et validation)
  - Utilisateurs (administration uniquement)
  - Paramètres (configuration système)

#### Raccourcis Clavier
- `Ctrl+N` : Nouvelle activité/transaction
- `Ctrl+S` : Sauvegarder
- `Ctrl+F` : Rechercher
- `F1` : Aide
- `Esc` : Fermer modale/annuler

## Configuration de Base

### Paramètres Système

1. **Accès aux Paramètres**
   - Cliquez sur l'icône ⚙️ dans le header
   - Ou allez dans Paramètres → Configuration Système

2. **Informations Entreprise**
   - **Nom de l'Entreprise** : Votre société
   - **Adresse** : Adresse complète
   - **Téléphone** : Numéro de contact
   - **Email** : Email officiel

3. **Préférences Régionales**
   - **Devise** : EUR (€), USD ($), XAF (FCFA), etc.
   - **Format Date** : JJ/MM/AAAA ou MM/JJ/AAAA
   - **Langue** : Français (principale), Anglais (disponible)
   - **Fuseau Horaire** : Automatique ou manuel

### Création des Premiers Utilisateurs

#### Comptes de Test Recommandés

Pour découvrir toutes les fonctionnalités, créez ces utilisateurs de test :

1. **Agent Service Intermédiaire**
   - Email : `agent@fintrack.pro`
   - Rôle : Agent
   - Utilisation : Validation des transactions

2. **Utilisateur Standard**
   - Email : `user@fintrack.pro`
   - Rôle : Utilisateur
   - Utilisation : Saisie des transactions

#### Procédure de Création

1. **Accès** : Paramètres → Gestion Utilisateurs → "Nouveau Utilisateur"
2. **Informations** :
   - Email professionnel
   - Mot de passe temporaire (l'utilisateur devra le changer)
   - Rôle approprié (Admin/Agent/Utilisateur)
   - Nom complet et poste

## Création de Votre Première Activité

### Qu'est-ce qu'une Activité ?

Une activité représente une entité économique (magasin, transport, projet) pour laquelle vous souhaitez suivre les recettes et dépenses.

### Étapes de Création

1. **Accès au Module**
   - Cliquez sur "Activités" dans le menu principal
   - Ou utilisez le raccourci `Ctrl+N` dans la section Activités

2. **Informations de Base**
   - **Nom** : "Magasin Central" ou "Transport Marchandises"
   - **Type** : Magasin, Transport, ou Autre
   - **Description** : Description détaillée (optionnel)
   - **Couleur** : Choisissez une couleur distinctive

3. **Assignation d'Utilisateurs**
   - Sélectionnez les utilisateurs autorisés à saisir des transactions
   - Au minimum, assignez-vous en tant qu'administrateur

4. **Validation**
   - Cliquez "Créer Activité"
   - L'activité apparaît dans la liste avec le statut "Active"

## Saisie de Premières Transactions

### Types de Transactions

FinTrack Pro gère deux types principaux :
- **Recettes** : Entrées d'argent (ventes, paiements reçus)
- **Dépenses** : Sorties d'argent (achats, frais, paiements effectués)

### Saisie d'une Recette

1. **Accès**
   - Dans le dashboard, cliquez sur votre activité
   - Ou allez dans Transactions → "Nouvelle Transaction"

2. **Informations Requises**
   - **Activité** : Sélectionnez l'activité créée
   - **Type** : Recette
   - **Montant** : Ex: 1000.00 €
   - **Description** : "Vente produits divers"
   - **Date** : Date de la transaction (aujourd'hui par défaut)

3. **Validation**
   - Cliquez "Enregistrer"
   - La transaction apparaît avec le statut "En attente" (nécessite approbation)

### Approbation de Transaction (Rôle Agent requis)

1. **Accès aux Transactions en Attente**
   - Connectez-vous avec un compte Agent (`agent@fintrack.pro`)
   - Allez dans Transactions → onglet "En attente"

2. **Approbation**
   - Cliquez sur la transaction
   - Vérifiez les informations
   - Cliquez "Approuver" ou "Rejeter" avec motif

3. **Résultat**
   - Transaction approuvée : Statut "Approuvé" → "Complété"
   - Les montants s'ajoutent aux KPIs de l'activité

## Comprendre les KPIs

### Dashboard Principal

Le dashboard affiche 4 cartes KPI principales :

1. **Total Recettes** : Somme de toutes les recettes approuvées
2. **Total Dépenses** : Somme de toutes les dépenses approuvées
3. **Reste à Collecter** : Objectif - Recettes acquises
4. **Solde Global** : Recettes - Dépenses

### KPIs par Activité

Chaque activité affiche ses propres indicateurs :
- **Recettes Acquises** : Transactions recettes approuvées
- **Recettes en Attente** : Transactions soumises mais non approuvées
- **Dépenses Acquises** : Transactions dépenses approuvées
- **Dépenses en Attente** : Transactions dépenses en attente
- **Solde Activité** : Recettes - Dépenses pour cette activité

## Workflow Complet de Démonstration

### Scénario d'Exemple

1. **Connexion Admin** → Créer activité "Boutique Paris"
2. **Créer utilisateurs** : Agent et Utilisateur standard
3. **Connexion Utilisateur** → Saisir 3 recettes (500€, 750€, 300€)
4. **Connexion Agent** → Approuver les recettes
5. **Connexion Utilisateur** → Saisir 2 dépenses (200€, 150€)
6. **Connexion Agent** → Approuver les dépenses
7. **Vérifier Dashboard** : Recettes: 1550€, Dépenses: 350€, Solde: 1200€

### Résultat Attendu

- Dashboard mis à jour avec les vrais montants
- Activité "Boutique Paris" avec solde positif
- Historique des transactions complet
- Notifications pour chaque approbation

## Gestion des Sessions

### Déconnexion
- Cliquez sur votre avatar dans le header
- Sélectionnez "Se déconnecter"
- L'application revient à l'écran de connexion

### Sessions Multiples
- Plusieurs utilisateurs peuvent être connectés simultanément
- Chaque session est indépendante
- Les modifications sont visibles en temps réel pour tous les utilisateurs

## Sauvegarde et Sécurité

### Sauvegarde Automatique
- FinTrack Pro sauvegarde automatiquement vos données toutes les 30 minutes
- Les sauvegardes sont stockées localement dans le dossier utilisateur
- Aucune donnée n'est envoyée sur internet sans consentement explicite

### Sécurité des Données
- Mots de passe hashés et salés
- Chiffrement des données sensibles
- Audit trail complet des modifications
- Gestion granulaire des permissions

## Prochaines Étapes

Maintenant que vous maîtrisez les bases :

1. **Explorez les fonctionnalités avancées** dans les guides spécialisés
2. **Créez des activités réelles** pour votre entreprise
3. **Formez vos équipes** avec les comptes utilisateur créés
4. **Configurez les exports** pour vos rapports périodiques
5. **Personnalisez les paramètres** selon vos besoins métier

## Aide et Support

### Aide Contextuelle
- Appuyez sur `F1` à tout moment pour l'aide contextuelle
- Infobulles sur les boutons et champs importants
- Messages d'erreur explicites avec suggestions de correction

### Ressources Additionnelles
- **FAQ** : Questions fréquemment posées avec réponses
- **Guide Avancé** : Fonctionnalités expertes et configuration
- **Support** : Contactez support@fintrack.pro pour assistance

---

*FinTrack Pro v1.0 - Guide Premiers Pas - Mis à jour le 31/10/2025*