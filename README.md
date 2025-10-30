Concept de l’application SaaS (version finale avec gestion des utilisateurs)
Objectif : Créer un logiciel flutter de suivi des activités financières d’une entreprise, centralisant les recettes et dépenses, avec un journal pour le suivi, la gestion des activités, et la gestion des utilisateurs.

1. Gestion des utilisateurs
* Types d’utilisateurs :
    1. Administrateur :
        * Gère toutes les activités et tous les utilisateurs
        * Peut ajouter, modifier, supprimer des activités
        * Peut créer et gérer des comptes utilisateurs
    2. Agents du Service Intermédiaire :
        * Collectent les recettes des différentes activités
        * Peuvent clôturer les activités et transférer les fonds vers la caisse centrale
        * Peuvent consulter le journal et les dashboards
    3. Utilisateurs standard :
        * Peuvent ajouter des recettes et des dépenses pour les activités assignées
        * Peuvent consulter les transactions liées à leurs saisies
* Fonctionnalités associées :
    * Gestion des rôles et permissions
    * Authentification sécurisée (login/mot de passe)
    * Historique des actions pour suivi et traçabilité

2. Gestion des activités
* Chaque activité (ex : Magasin 1, Magasin 2, Transport…) a sa propre caisse.
* L’utilisateur peut :
    * Ajouter une nouvelle activité
    * Modifier le nom d’une activité
    * Supprimer une activité si nécessaire
* Les transactions (recettes/dépenses) sont liées à une activité spécifique.

3. Dashboard global
* 4 KPIs principaux pour l’ensemble des activités :
    1. Total des recettes
    2. Total des dépenses
    3. Restes à collecter
    4. Solde total ou autre indicateur pertinent

4. Bloc activité individuelle
* 5 KPIs par activité :
    1. Recettes en attente
    2. Dépenses en attente
    3. Recettes acquises
    4. Dépenses acquises
    5. Restes disponibles
* Listes des transactions :
    * Recettes en attente (colonne 1)
    * Dépenses en attente (colonne 2)
        * Bouton « Modifier » pour passer une dépense en statut réalisée
* Actions possibles pour l’activité :
    * Ajouter une recette
    * Ajouter une dépense
    * Clôturer l’activité (vérification et transfert des fonds vers le Service Intermédiaire)

5. Journal des transactions
* Interface centralisée regroupant toutes les transactions de toutes les activités.
* Filtres possibles : activité, type (recette/dépense), statut, date
* Objectif : suivi opérationnel sans afficher les détails comptables (logique comptable gardée en back-end)

6. Flux général
1. L’administrateur crée les utilisateurs et les activités.
2. Les utilisateurs saisissent quotidiennement les recettes et dépenses.
3. L’agent du Service Intermédiaire collecte et clôture les activités.
4. Le dashboard global et les blocs activité se mettent à jour automatiquement.
5. Le journal permet de consulter l’historique et de filtrer les transactions facilement.
