# Dépannage et FAQ - FinTrack Pro

## Vue d'ensemble

Ce guide rassemble les problèmes courants rencontrés avec FinTrack Pro, leurs causes probables et les solutions associées. Il est organisé par catégories pour faciliter la recherche.

## Problèmes d'Installation

### Erreur "MSVCP140.dll manquant" (Windows)

**Symptômes** :
- Application refuse de démarrer
- Erreur "La procédure du point d'entrée... MSVCP140.dll introuvable"

**Cause** : Bibliothèques Microsoft Visual C++ manquantes

**Solution** :
1. Télécharger Visual C++ Redistributable :
   ```
   https://aka.ms/vs/17/release/vc_redist.x64.exe
   ```
2. Installer le package complet
3. Redémarrer l'ordinateur
4. Relancer FinTrack Pro

**Prévention** : Toujours installer les prérequis système mentionnés dans le guide d'installation

### Problème de Permissions (Tous OS)

**Symptômes** :
- "Accès refusé" lors de l'installation
- Base de données ne se crée pas
- Sauvegardes échouent

**Solutions par OS** :

**Windows** :
```cmd
# Lancer en tant qu'Administrateur
# Ou vérifier permissions dossier :
icacls "C:\Program Files\FinTrack Pro" /grant Users:F
```

**macOS** :
```bash
# Vérifier permissions Applications :
sudo chown -R $USER /Applications/FinTrack\ Pro.app
```

**Linux** :
```bash
# Permissions dossier utilisateur :
chmod -R 755 ~/.fintrack_pro
# Ou installation système :
sudo chown -R $USER:$USER /opt/fintrack-pro
```

### Erreur Base de Données Corrompue

**Symptômes** :
- Application démarre mais données absentes
- Erreurs "database disk image is malformed"

**Récupération** :
1. Fermer FinTrack Pro
2. Restaurer dernière sauvegarde fonctionnelle
3. Si pas de sauvegarde :
   ```bash
   # Sauvegarde fichiers existants
   cp fintrack.db fintrack.db.backup

   # Reconstruction base (risqué)
   sqlite3 fintrack.db ".recover" > recovered.sql
   ```
4. Contacter support technique pour assistance

## Problèmes de Connexion

### Mot de Passe Oublié

**Procédure** :
1. Sur écran connexion : "Mot de passe oublié"
2. Entrer email professionnel
3. Vérifier boîte mail (y compris spam)
4. Suivre lien sécurisé (expire en 24h)
5. Définir nouveau mot de passe fort (8+ caractères)

**Si email non reçu** :
- Vérifier configuration SMTP administrateur
- Contacter administrateur système
- Utiliser compte secondaire si configuré

### Compte Verrouillé

**Cause** : 3 tentatives de connexion échouées

**Déblocage** :
- Attendre 15 minutes (déblocage automatique)
- Ou contacter administrateur pour déblocage manuel
- Vérifier casse mot de passe et email

### Erreur "Licence expirée"

**Symptômes** : Application refuse démarrage avec message licence

**Solutions** :
1. **Licence d'évaluation** : Contacter support renouvellement
2. **Licence commerciale** : Vérifier date expiration contrat
3. **Migration version** : Mise à jour peut résoudre

## Problèmes Fonctionnels

### Transactions Non Approuvées

**Symptômes** : Transactions restent en "En attente" indéfiniment

**Causes Possibles** :
1. **Agent indisponible** : Aucun Agent connecté pour approbation
2. **Règles métier** : Montant supérieur seuil Agent
3. **Documents manquants** : Justificatifs obligatoires absents

**Solutions** :
- Vérifier statut Agents dans Administration
- Ajouter documents justificatifs
- Contacter Agent pour approbation prioritaire
- Modifier seuils si nécessaire (Admin uniquement)

### KPIs Non Mis à Jour

**Symptômes** : Tableaux de bord affichent des valeurs obsolètes

**Résolution** :
1. Rafraîchir page (`F5` ou `Ctrl+R`)
2. Vérifier calculs automatiques actifs
3. Redémarrer application si nécessaire
4. Vérifier intégrité base de données

### Performances Lentes

**Causes Courantes** :
- Base de données volumineuse (> 1GB)
- Nombreuses transactions (> 100k)
- Machine ancienne (< 8GB RAM)
- Antivirus trop agressif

**Optimisations** :
```sql
-- Nettoyage base de données (Admin)
VACUUM;
REINDEX;

-- Fermer applications inutiles
-- Désactiver antivirus temporairement (risqué)
-- Mise à jour RAM si possible
```

## Problèmes de Données

### Données Dupliquées

**Détection** :
- Transactions identiques apparaissent
- Montants dupliqués dans rapports

**Nettoyage** :
1. Identifier doublons via recherche avancée
2. Garder transaction avec justificatifs complets
3. Supprimer doublons (avec confirmation)
4. Prévention : Vérifier avant soumission

### Données Incohérentes

**Symptômes** : Soldes incorrects, totaux erronés

**Diagnostic** :
```sql
-- Vérification cohérence (outil diagnostic)
SELECT
  activity_id,
  SUM(CASE WHEN type = 'recette' THEN amount ELSE 0 END) as recettes,
  SUM(CASE WHEN type = 'depense' THEN amount ELSE 0 END) as depenses,
  SUM(CASE WHEN type = 'recette' THEN amount ELSE -amount END) as solde_calcule
FROM transactions
WHERE status = 'approved'
GROUP BY activity_id;
```

**Correction** : Recalcul via outil Administration → Diagnostic

### Documents Justificatifs Inaccessibles

**Symptômes** : "Fichier introuvable" lors ouverture documents

**Causes** :
- Fichier supprimé du disque
- Permissions changées
- Stockage réseau déconnecté
- Corruption fichier

**Solutions** :
- Vérifier chemin fichier dans base
- Restaurer depuis sauvegarde
- Réuploader document si disponible
- Supprimer référence si irrécupérable

## Problèmes d'Export

### Export CSV Excel Vide

**Cause** : Filtres trop restrictifs ou données absentes

**Vérifications** :
- Période sélectionnée contient des données
- Filtres activité/utilisateur corrects
- Statut transactions (approuvées uniquement exportées)
- Permissions export activées

### Erreur Mémoire Export PDF

**Symptômes** : "Mémoire insuffisante" sur gros exports

**Solutions** :
- Réduire période export
- Augmenter RAM système
- Exporter par lots (par activité)
- Utiliser CSV plutôt que PDF

### Exports Programmés Non Envoyés

**Dépannage** :
1. Vérifier configuration SMTP
2. Tester envoi manuel
3. Contrôler quota email
4. Vérifier antispam destinataire
5. Consulter logs application

## Problèmes Système

### Application Se Ferme Inopinément

**Diagnostic** :
- Consulter logs erreurs (`%APPDATA%/fintrack_pro/logs/`)
- Vérifier utilisation RAM/CPU
- Tester sur autre machine
- Désactiver antivirus temporairement

**Logs Typiques** :
```
ERROR: OutOfMemoryError: Java heap space
SOLUTION: Augmenter RAM système ou réduire données chargées
```

### Synchronisation Cloud Échoue

**Si configuré Supabase** :
- Vérifier connexion internet
- Contrôler clés API valides
- Tester connectivité Supabase
- Vérifier quota usage
- Consulter logs synchronisation

### Mises à Jour Bloquées

**Cause** : Permissions insuffisantes ou antivirus

**Résolution** :
```bash
# Windows : Lancer en Admin
# macOS : Permissions complètes
# Linux : sudo ou chown correct
```

## Problèmes par Rôle

### Utilisateur Standard

**"Impossible de saisir transaction"**
- Vérifier assignation à activité
- Contrôler activité active (pas suspendue)
- Permissions saisie activées

**"Documents rejetés à l'upload"**
- Formats autorisés : PDF, JPG, PNG (< 10MB)
- Antivirus peut bloquer
- Espace disque suffisant

### Agent Service Intermédiaire

**"Bouton approuver grisé"**
- Toutes vérifications requises complétées
- Permissions approbation activées
- Règles métier respectées

**"Notifications non reçues"**
- Paramètres email configurés
- Adresse email valide
- Pas de filtrage antispam

### Administrateur

**"Création utilisateur échoue"**
- Email unique dans système
- Mot de passe respecte politique
- Quota utilisateurs non atteint

**"Configuration non sauvegardée"**
- Permissions dossier configuration
- Format JSON valide
- Redémarrage application requis

## Outils de Diagnostic

### Diagnostic Automatique

**Accès** : Administration → Outils → Diagnostic Système

**Tests Exécutés** :
- ✅ Intégrité base de données
- ✅ Permissions fichiers
- ✅ Connectivité réseau
- ✅ Configuration système
- ✅ Utilisation ressources

### Logs d'Application

**Localisation Logs** :
- **Windows** : `%APPDATA%\fintrack_pro\logs\`
- **macOS** : `~/Library/Application Support/fintrack_pro/logs/`
- **Linux** : `~/.fintrack_pro/logs/`

**Niveaux** :
- `INFO` : Informations générales
- `WARN` : Avertissements non critiques
- `ERROR` : Erreurs nécessitant attention
- `DEBUG` : Détails techniques (mode développeur)

### Outils Système

**Vérifications OS** :

**Windows** :
```cmd
# État système
systeminfo | findstr /C:"Total Physical Memory"
# Espaces disque
wmic logicaldisk get size,freespace,caption
# Processus
tasklist | findstr fintrack
```

**Linux/macOS** :
```bash
# Mémoire
free -h
# Disque
df -h
# Processus
ps aux | grep fintrack
# Logs système
journalctl -u fintrack-pro --since today
```

## FAQ - Questions Fréquemment Posées

### Questions Générales

**Q: FinTrack Pro est-il gratuit ?**
R: Version d'évaluation 30 jours gratuite. Licence commerciale ensuite selon usage.

**Q: Puis-je utiliser FinTrack sur plusieurs ordinateurs ?**
R: Oui, avec synchronisation cloud optionnelle. Licence par organisation, usage simultané illimité.

**Q: Mes données sont-elles sécurisées ?**
R: Chiffrement AES-256, sauvegardes automatiques, conformité RGPD. Aucune donnée envoyée sans consentement.

**Q: Support de quelles devises ?**
R: Toutes devises ISO avec configuration personnalisable (symbole, format, décimales).

### Questions Techniques

**Q: Quelle est la taille maximale de la base ?**
R: Théoriquement illimitée, testé jusqu'à 10GB. Performance optimale < 2GB.

**Q: Puis-je importer mes données existantes ?**
R: Oui, via CSV/Excel. Templates disponibles. Support migrations ERP.

**Q: L'application fonctionne-t-elle hors ligne ?**
R: Oui, fonctionnement complet hors ligne. Synchronisation cloud optionnelle.

**Q: Fréquence des sauvegardes ?**
R: Automatique toutes les 30 minutes + manuelle à la demande. Configurable.

### Questions Métier

**Q: Puis-je personnaliser les workflows ?**
R: Oui, via configuration avancée. Seuils approbation, règles validation, notifications.

**Q: Support des multi-devises ?**
R: Oui, conversion automatique ou manuelle. Rapports multi-devises.

**Q: Intégration avec notre ERP ?**
R: APIs REST disponibles. Formats FEC, SAF-T supportés. Développement spécifique possible.

**Q: Formation équipe disponible ?**
R: Guides complets, vidéos tutoriels, support formation inclus licence.

### Questions Sécurité

**Q: Conformité RGPD ?**
R: Audit trails complets, chiffrement données, droit oubli, minimisation données.

**Q: Récupération en cas de sinistre ?**
R: Sauvegardes multiples (local, cloud, réseau). Plan récupération documenté.

**Q: Accès d'urgence ?**
R: Comptes administrateur secondaires, récupération mot de passe sécurisée.

## Support et Assistance

### Canaux Support

**Priorité 1 (Critique)** :
- Application indisponible
- Données corrompues
- Sécurité compromise
- **Temps réponse** : 4h ouvrées

**Priorité 2 (Important)** :
- Fonctionnalité défaillante
- Performance dégradée
- Demande évolution majeure
- **Temps réponse** : 24h ouvrées

**Priorité 3 (Normal)** :
- Question utilisation
- Demande évolution mineure
- Formation complémentaire
- **Temps réponse** : 72h ouvrées

### Contact Support

**Email** : support@fintrack.pro
**Téléphone** : 01-XX-XX-XX-XX (9h-18h CET)
**Chat** : Interface application (bouton "?")
**Forum** : community.fintrack.pro

### Préparation Demande Support

**Informations Requises** :
- Version FinTrack Pro exacte
- Système d'exploitation et version
- Description détaillée problème
- Étapes reproduction
- Captures d'écran
- Logs erreurs pertinents
- Configuration système

**Rapport Automatique** :
- Bouton "Générer Rapport Support" dans Aide
- Collecte automatique informations système
- Envoi sécurisé support technique

---

*FinTrack Pro v1.0 - Dépannage et FAQ - Mis à jour le 31/10/2025*