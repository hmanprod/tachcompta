# Guide Agent Service Intermédiaire - FinTrack Pro

## Vue d'ensemble

En tant qu'Agent Service Intermédiaire (ASI), votre rôle principal est d'assurer la qualité et la conformité des transactions financières. Vous êtes le maillon essentiel entre la saisie utilisateur et la validation définitive des opérations.

## Permissions et Responsabilités

### Droits d'Accès

- **Validation Transactions** : Approuver/rejeter les transactions soumises
- **Consultation Globale** : Voir toutes les activités et transactions
- **Gestion Activités** : Créer, modifier, clôturer des activités
- **Rapports** : Générer des rapports de synthèse
- **Pas d'administration** : Pas d'accès à la gestion utilisateurs/système

### Responsabilités Métier

- Validation des transactions selon les règles établies
- Contrôle de cohérence des montants et justifications
- Gestion du workflow d'approbation
- Clôture des activités commerciales
- Reporting auprès de la direction

## Validation des Transactions

### Processus d'Approbation

#### Vue d'Ensemble des Transactions en Attente

1. **Accès au Module**
   - Menu → Transactions → onglet "En attente"
   - Badge rouge indique le nombre de transactions à traiter

2. **Filtres Disponibles**
   - **Par Activité** : Focus sur une activité spécifique
   - **Par Utilisateur** : Transactions d'un utilisateur particulier
   - **Par Montant** : Seuils minimum/maximum
   - **Par Date** : Période spécifique
   - **Par Type** : Recettes ou dépenses uniquement

#### Révision Individuelle

1. **Sélection d'une Transaction**
   - Clic sur la ligne dans le tableau
   - Ou double-clic pour ouverture détaillée

2. **Vérifications Obligatoires**
   - **Cohérence Montant** : Logique par rapport à l'activité
   - **Justification** : Description claire et complète
   - **Date** : Cohérence temporelle
   - **Documents** : Preuves justificatives si requises

3. **Contrôles Automatiques**
   - Alertes seuils dépassés
   - Détection doublons possibles
   - Vérification conformité règles métier

### Décisions d'Approbation

#### Approbation Standard

- **Conditions** : Transaction conforme, bien justifiée
- **Action** : Bouton vert "Approuver"
- **Effets** :
  - Statut passe à "Approuvé"
  - Transaction visible dans les KPIs
  - Notification à l'utilisateur

#### Rejet avec Motif

- **Conditions** : Erreurs détectées, informations manquantes
- **Action** : Bouton rouge "Rejeter" + motif obligatoire
- **Motifs Possibles** :
  - "Montant incohérent"
  - "Justification insuffisante"
  - "Documents manquants"
  - "Date incorrecte"
  - "Doublon détecté"

- **Effets** :
  - Statut passe à "Rejeté"
  - Transaction non comptabilisée
  - Notification avec motif à l'utilisateur

#### Mise en Attente

- **Conditions** : Besoin d'informations complémentaires
- **Action** : Bouton orange "Mettre en attente" + commentaire
- **Processus** : L'utilisateur peut modifier et resoumettre

### Approbation par Lot

#### Sélection Multiple

1. **Cochez les Transactions** : Cases à cocher dans le tableau
2. **Actions Groupées** :
   - "Approuver la sélection"
   - "Rejeter la sélection"
   - "Exporter pour vérification"

#### Bonnes Pratiques

- Grouper par activité pour cohérence
- Traiter par ordre chronologique
- Limiter à 20-30 transactions par lot

## Gestion des Activités

### Création d'Activités

1. **Accès** : Menu → Activités → "Nouvelle Activité"
2. **Informations Requises** :
   - **Nom** : Désignation claire
   - **Type** : Magasin, Transport, Autre
   - **Description** : Contexte et objectifs
   - **Couleur** : Pour identification visuelle

3. **Assignation Utilisateurs** :
   - Sélection des utilisateurs autorisés
   - Définition des rôles (si applicable)

4. **Paramètres Optionnels** :
   - Objectifs financiers
   - Seuils d'alerte
   - Règles spécifiques

### Modification d'Activités

#### Changements Autorisé

- **Propriétés de base** : Nom, description, couleur
- **Assignations** : Ajouter/retirer des utilisateurs
- **Paramètres** : Objectifs, seuils, règles

#### Restrictions

- **Créateur** : Ne peut pas être changé
- **Historique** : Transactions existantes préservées
- **Statut** : Changements contrôlés (voir clôture)

### Clôture d'Activités

#### Processus de Clôture

1. **Vérifications Préliminaires**
   - Toutes transactions approuvées
   - Soldes équilibrés
   - Documents justificatifs complets

2. **Initiation Clôture**
   - Bouton "Clôturer Activité"
   - Confirmation avec commentaire

3. **Étapes Automatiques**
   - Calcul solde final
   - Génération rapport de clôture
   - Archivage données
   - Notifications utilisateurs

#### Transferts Associés

- **Soldes** : Transfert vers activité parente ou compte général
- **Utilisateurs** : Désassignation automatique
- **Historique** : Conservation complète pour audit

## Dashboard et KPIs

### Suivi des Performances

#### Indicateurs Clés

- **Transactions en Attente** : Volume à traiter
- **Temps Moyen Approbation** : Performance de traitement
- **Taux Rejet** : Qualité des saisies utilisateurs
- **Activités Actives** : Nombre sous responsabilité

#### Tableaux de Bord Personnalisés

- **Par Activité** : KPIs détaillés par entité
- **Par Utilisateur** : Performance des équipes
- **Tendances** : Évolution temporelle
- **Alertes** : Seuils dépassés, anomalies

### Rapports de Synthèse

#### Génération Rapports

1. **Accès** : Menu → Rapports → "Nouveau Rapport"
2. **Types Disponibles** :
   - Rapport d'activité (une activité)
   - Rapport global (toutes activités)
   - Rapport utilisateur (performance équipe)
   - Rapport période (analyse temporelle)

3. **Paramètres** :
   - Période (date début/fin)
   - Filtres (activités, utilisateurs, types)
   - Format (PDF, Excel, CSV)

#### Contenu Standard

- **Résumé Exécutif** : KPIs principaux
- **Détail Transactions** : Liste complète filtrée
- **Graphiques** : Évolution, répartition
- **Annexes** : Justificatifs si nécessaire

## Notifications et Alertes

### Gestion des Notifications

#### Types de Notifications

- **Nouvelles Transactions** : À approuver
- **Activités à Clôturer** : Rappels périodiques
- **Seuils Dépassés** : Alertes budgétaires
- **Rapports Générés** : Confirmations
- **Actions Utilisateurs** : Modifications importantes

#### Paramètres Notifications

- **Canaux** : Interface, email, push (si configuré)
- **Fréquence** : Immédiat, quotidien, hebdomadaire
- **Filtres** : Par type, priorité, activité

### Traitement des Alertes

#### Priorisation

- **Critique** : Transactions importantes en attente
- **Important** : Clôtures à effectuer
- **Information** : Mises à jour système

#### Acquittement

- Clic pour marquer comme lu
- Commentaire optionnel
- Historique conservé

## Workflows Métier

### Règles de Validation

#### Contrôles Automatiques

- **Cohérence Montants** : Par rapport aux moyennes activité
- **Doublons** : Détection transactions similaires
- **Seuils** : Alertes dépassement limites définies
- **Chronologie** : Dates cohérentes avec l'activité

#### Règles Métier Personnalisables

- **Par Activité** : Règles spécifiques à chaque entité
- **Par Type Transaction** : Contrôles recettes/dépenses
- **Par Montant** : Seuils d'approbation automatique

### Gestion des Urgences

#### Procédures Exceptionnelles

- **Approbation Express** : Pour transactions critiques
- **Contournement Règles** : Avec justification obligatoire
- **Blocage Temporaire** : En cas d'anomalies détectées

#### Escalade Hiérarchique

- **Transmission Supérieur** : Pour décisions majeures
- **Validation Multiple** : Double contrôle requis
- **Audit Automatique** : Traçabilité complète

## Outils de Productivité

### Raccourcis Clavier

- `Ctrl+Entrée` : Approuver transaction sélectionnée
- `Ctrl+Suppr` : Rejeter avec motif rapide
- `Ctrl+Maj+A` : Tout approuver (avec confirmation)
- `F5` : Actualiser la vue
- `Ctrl+F` : Recherche rapide

### Modèles et Automatisation

#### Modèles de Rejet

- Bibliothèque de motifs prédéfinis
- Insertion rapide dans commentaires
- Statistiques d'usage pour optimisation

#### Règles d'Approbation Automatique

- Configuration de seuils d'auto-approbation
- Par montant, par utilisateur, par activité
- Traçabilité des décisions automatiques

## Formation et Support

### Ressources Disponibles

#### Guides Contextuels

- Aide intégrée (`F1`) pour chaque écran
- Infobulles explicatives
- Messages d'erreur avec suggestions

#### Support Équipe

- **Administrateur** : Configuration système
- **Utilisateurs** : Formation saisie transactions
- **Direction** : Rapports et analyses

### Bonnes Pratiques ASI

#### Organisation Quotidienne

- **Matin** : Revue transactions en attente prioritaires
- **Journée** : Traitement continu avec alternance activités
- **Fin journée** : Clôtures à effectuer, rapports

#### Qualité et Performance

- **Taux Rejet** : Maintenir < 5% (objectif qualité)
- **Délais** : Approuver dans les 24h
- **Feedback** : Former les utilisateurs aux bonnes pratiques

#### Prévention Erreurs

- Vérifier les tendances avant approbation
- Demander justifications pour montants inhabituels
- Utiliser les filtres pour traiter par priorité

## Métriques de Performance

### Indicateurs Personnels

- **Volume Traité** : Nombre transactions/jour
- **Temps Moyen** : Durée traitement transaction
- **Taux Rejet** : Pourcentage rejets sur total
- **Satisfaction** : Feedback utilisateurs

### Objectifs Recommandés

- **Productivité** : 50-100 transactions/jour
- **Qualité** : Taux rejet < 3%
- **Délais** : 95% traités sous 24h
- **Formation** : 2h/semaine utilisateurs

---

*FinTrack Pro v1.0 - Guide Agent Service Intermédiaire - Mis à jour le 31/10/2025*