# Spécifications UX/UI - FinTrack Pro
## Système de Gestion Financière d'Entreprise

---

## 1. IDENTITÉ VISUELLE

### 1.1 Palette de couleurs
**Couleurs principales :**
- **Vert foncé principal** : `#1A5554` (header, boutons primaires)
- **Vert moyen** : `#2B7A78` (éléments interactifs)
- **Vert clair** : `#3D9B99` (hover states)
- **Vert pastel** : `#E8F5F4` (backgrounds secondaires)

**Couleurs d'accentuation :**
- **Jaune/Ambre** : `#FFB800` (indicateurs négatifs, alertes)
- **Vert success** : `#10B981` (indicateurs positifs)
- **Rouge** : `#EF4444` (erreurs, suppressions)
- **Bleu info** : `#3B82F6` (informations)

**Couleurs neutres :**
- **Blanc** : `#FFFFFF` (backgrounds cards)
- **Gris clair** : `#F3F4F6` (backgrounds page)
- **Gris moyen** : `#9CA3AF` (textes secondaires)
- **Gris foncé** : `#1F2937` (textes principaux)

### 1.2 Typographie
- **Famille principale** : Inter ou Poppins
- **Titre principal (H1)** : 32px, Bold
- **Titre section (H2)** : 24px, SemiBold
- **Sous-titres (H3)** : 18px, Medium
- **Corps de texte** : 14px, Regular
- **Labels/Captions** : 12px, Medium
- **KPIs grands nombres** : 36px, Bold

### 1.3 Espacement & Grille
- **Container max-width** : 1400px
- **Padding latéral** : 24px
- **Gap entre cards** : 20px
- **Border radius cards** : 16px
- **Border radius boutons** : 12px

---

## 2. STRUCTURE GÉNÉRALE

### 2.1 Header (Navigation principale)
**Hauteur** : 80px
**Background** : Vert foncé `#1A5554`

**Éléments (de gauche à droite) :**
1. **Logo + Nom app** : "FinTrack Pro" avec icône
2. **Navigation principale** (boutons pills avec icônes) :
   - Dashboard (icône grid)
   - Activités (icône briefcase)
   - Transactions (icône list)
   - Utilisateurs (icône users) - visible admin uniquement
3. **Zone droite** :
   - Icône paramètres (settings)
   - Icône notifications (bell) avec badge count
   - Avatar utilisateur + nom + rôle

**États interactifs :**
- Hover : Background `#3D9B99`
- Active : Background `#2B7A78` + border bottom 3px

### 2.2 Layout principal
```
┌─────────────────────────────────────┐
│          HEADER (fixe)              │
├─────────────────────────────────────┤
│  GREETING + ACTIONS                 │
│  ┌───────────────────────────────┐  │
│  │  Content Area (scrollable)    │  │
│  │                               │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

---

## 3. PAGE DASHBOARD

### 3.1 Zone de salutation
**Background** : Dégradé vert foncé
**Padding** : 32px

**Contenu :**
- "Bonjour," (texte small, opacity 0.8)
- Nom utilisateur (H1, blanc)
- Sélecteur période (dropdown avec icône calendrier) : 2023, 2024, etc.
- Bouton "Exporter Data" (blanc, outline)

### 3.2 KPIs Globaux (4 cards horizontales)
**Disposition** : Grid 4 colonnes (responsive : 2x2 sur tablette, 1 col sur mobile)

**Structure de chaque card KPI :**
- Background : Blanc
- Border radius : 16px
- Padding : 24px
- Shadow : `0 2px 8px rgba(0,0,0,0.08)`
- Icône en haut gauche (cercle vert pastel, icône vert foncé)
- Flèche externe en haut droite (hover : translate)
- Nombre principal : 36px, Bold, noir
- Badge pourcentage : small pill (vert ou jaune selon positif/négatif)
- Label : 14px, gris moyen, dessous

**Les 4 KPIs :**
1. **Total Recettes** 
   - Icône : TrendingUp
   - Badge vert : +X.XX%
2. **Total Dépenses**
   - Icône : TrendingDown
   - Badge jaune : -X.XX%
3. **Restes à Collecter**
   - Icône : Clock
   - Badge neutre ou jaune
4. **Solde Global**
   - Icône : Wallet
   - Badge vert/rouge selon positif/négatif

### 3.3 Bouton "Ajouter un widget"
**Dernière card dans la grid**
- Background : Blanc
- Border : dashed 2px vert moyen
- Icône + centré verticalement/horizontalement
- Texte : "Ajouter un widget"
- Hover : background vert pastel

---

## 4. SECTION ACTIVITÉS

### 4.1 Liste des activités (Grid 2-3 colonnes)
Chaque activité = Card expansible

**Card Activité (Vue collapsée) :**
- Header avec :
  - Nom activité (H3) + icône
  - Menu 3 points (modifier/supprimer)
  - Bouton expand/collapse
- Mini KPIs (2x2 grid compacte)
- Bouton "Voir détails"

**Card Activité (Vue expandée) :**

**Section 1 : KPIs détaillés (5 indicateurs)**
Grid 5 colonnes avec mini-cards :
1. Recettes en attente
2. Dépenses en attente
3. Recettes acquises
4. Dépenses acquises
5. Reste disponible

Chaque mini-KPI :
- Icône + label
- Nombre (20px, Bold)
- Couleur background selon statut

**Section 2 : Transactions en attente (2 colonnes)**

**Colonne 1 : Recettes en attente**
- Liste verticale de cards
- Chaque recette :
  - Montant (Bold)
  - Libellé
  - Date
  - Statut badge "En attente"
  - Actions : Valider, Modifier, Supprimer

**Colonne 2 : Dépenses en attente**
- Même structure que recettes
- Bouton "Marquer comme réalisée"
- Actions : Modifier, Supprimer

**Section 3 : Actions principales**
Barre de boutons :
- "Ajouter une Recette" (vert primaire)
- "Ajouter une Dépense" (vert secondaire)
- "Clôturer l'activité" (outline, rouge si validation nécessaire)

---

## 5. PAGE JOURNAL DES TRANSACTIONS

### 5.1 Filtres (Barre supérieure)
**Layout horizontal avec :**
- Dropdown "Activité" (All, Activité 1, 2...)
- Dropdown "Type" (All, Recettes, Dépenses)
- Dropdown "Statut" (All, En attente, Validé, Réalisé)
- Date range picker
- Bouton "Rechercher"
- Bouton "Réinitialiser filtres"

### 5.2 Tableau des transactions
**Colonnes :**
1. Date (sortable)
2. Activité (badge avec couleur)
3. Type (Recette/Dépense avec icône)
4. Libellé
5. Montant (aligné droite, coloré)
6. Statut (badge)
7. Utilisateur (avatar + nom)
8. Actions (icône 3 points)

**Fonctionnalités :**
- Tri par colonne
- Pagination (50 items par page)
- Export CSV/Excel
- Ligne hover : background gris très clair
- Ligne sélectionnée : border gauche vert

---

## 6. GESTION DES UTILISATEURS (Admin uniquement)

### 6.1 Vue d'ensemble
**Card principale avec :**
- Statistiques utilisateurs (Total, Actifs, Inactifs)
- Bouton "Ajouter un utilisateur"

### 6.2 Liste des utilisateurs (Tableau/Cards)
**Chaque utilisateur :**
- Avatar + Nom + Rôle
- Email
- Dernière connexion
- Statut (actif/inactif toggle)
- Actions : Modifier, Réinitialiser mot de passe, Supprimer

### 6.3 Modal d'ajout/modification utilisateur
**Formulaire avec :**
- Nom complet
- Email
- Rôle (dropdown : Admin, Agent SI, Utilisateur standard)
- Activités assignées (multi-select)
- Photo de profil (upload)
- Boutons : Annuler / Enregistrer

---

## 7. COMPOSANTS RÉUTILISABLES

### 7.1 Boutons
**Primaire :**
- Background : Vert foncé
- Text : Blanc
- Hover : Vert moyen
- Padding : 12px 24px
- Border radius : 12px

**Secondaire (Outline) :**
- Border : 2px vert foncé
- Text : Vert foncé
- Hover : Background vert pastel

**Danger :**
- Background : Rouge
- Text : Blanc

**Tailles :**
- Small : 10px 20px, text 12px
- Medium : 12px 24px, text 14px
- Large : 16px 32px, text 16px

### 7.2 Cards
**Standard :**
- Background : Blanc
- Border radius : 16px
- Padding : 24px
- Shadow : `0 2px 8px rgba(0,0,0,0.08)`
- Hover : Shadow `0 4px 12px rgba(0,0,0,0.12)` + translate Y -2px

### 7.3 Badges
**Statuts :**
- En attente : Jaune/Ambre
- Validé : Bleu
- Réalisé : Vert
- Rejeté : Rouge

**Structure :**
- Padding : 4px 12px
- Border radius : 8px
- Font size : 12px
- Font weight : Medium

### 7.4 Modals
**Structure :**
- Overlay : rgba(0,0,0,0.5)
- Modal : Blanc, max-width 600px, border-radius 20px
- Header : Padding 24px, border-bottom
- Body : Padding 24px
- Footer : Padding 24px, border-top, boutons alignés droite

### 7.5 Formulaires
**Inputs :**
- Height : 48px
- Border : 1px gris clair
- Border radius : 10px
- Focus : Border vert moyen + shadow vert légère
- Padding : 12px 16px

**Labels :**
- Font size : 14px
- Font weight : Medium
- Margin bottom : 8px

---

## 8. ÉTATS INTERACTIFS

### 8.1 Loading states
- Skeleton screens pour les cards
- Spinner vert pour actions asynchrones
- Progress bar pour uploads

### 8.2 Empty states
- Illustration + Texte centré
- Bouton d'action principal
- Message explicatif

### 8.3 Error states
- Border rouge sur inputs
- Message d'erreur en rouge (12px)
- Toast notifications pour erreurs globales

### 8.4 Success states
- Toast vert avec icône check
- Animation de validation sur boutons
- Feedback visuel immédiat

---

## 9. RESPONSIVE DESIGN

### 9.1 Breakpoints
- **Desktop** : > 1024px
- **Tablette** : 768px - 1024px
- **Mobile** : < 768px

### 9.2 Adaptations mobiles
**Header :**
- Burger menu pour navigation
- Avatar + notifications conservés

**KPIs :**
- Grid 1 colonne
- Swipe horizontal optionnel

**Activités :**
- Stack vertical
- Cards full-width

**Tableau transactions :**
- Vue card au lieu de tableau
- Filtres en modal

---

## 10. ANIMATIONS & MICRO-INTERACTIONS

### 10.1 Transitions
- Durée standard : 200ms
- Easing : cubic-bezier(0.4, 0, 0.2, 1)

### 10.2 Animations
- Fade in sur modal : opacity 0 → 1
- Slide up sur toast : translateY(20px) → 0
- Scale sur hover boutons : scale(1) → scale(1.02)
- Rotate sur icône expand : rotate(0) → rotate(180deg)

### 10.3 Feedback utilisateur
- Ripple effect sur boutons
- Loading spinner sur actions asynchrones
- Highlight sur nouveaux éléments
- Smooth scroll sur navigation

---

## 11. ACCESSIBILITÉ

### 11.1 Contrastes
- Ratio minimum : 4.5:1 pour texte normal
- Ratio minimum : 3:1 pour texte large

### 11.2 Navigation clavier
- Focus visible sur tous les éléments interactifs
- Tab order logique
- Shortcuts clavier pour actions principales

### 11.3 ARIA
- Labels appropriés
- Roles définis
- States communiqués

---

## 12. WORKFLOW CLÔTURE D'ACTIVITÉ

### 12.1 Étapes
1. **Validation préalable**
   - Vérification : toutes dépenses en attente réalisées ?
   - Vérification : toutes recettes validées ?
   - Si non : Modal d'alerte avec liste des éléments en attente

2. **Récapitulatif**
   - Modal avec résumé :
     - Total recettes collectées
     - Total dépenses réalisées
     - Solde à transférer
     - Date de clôture
   - Champ commentaire optionnel

3. **Confirmation**
   - Bouton "Confirmer la clôture"
   - Animation de chargement
   - Success toast
   - Mise à jour dashboard

4. **Post-clôture**
   - L'activité passe en mode "Clôturée"
   - Nouvelle période automatiquement ouverte
   - Notification envoyée à l'admin

---

## 13. NOTIFICATIONS & ALERTES

### 13.1 Types de notifications
**In-app (Bell icon) :**
- Badge count sur icône
- Dropdown avec liste notifications
- Types :
  - Activité clôturée
  - Nouveau utilisateur créé
  - Dépense en attente d'approbation
  - Seuil d'alerte dépassé

**Toast notifications :**
- Position : Top-right
- Auto-dismiss : 5 secondes
- Types : Success, Error, Warning, Info

### 13.2 Design des notifications
- Card blanche avec shadow
- Icône + Titre + Message
- Timestamp
- Action rapide optionnelle
- Bouton fermer

---

## 14. EXPORTS & RAPPORTS

### 14.1 Bouton "Exporter Data"
**Options d'export :**
- Format : Excel, CSV, PDF
- Période : Sélection date range
- Contenu : Dashboard, Activité spécifique, Journal complet
- Filtres appliqués conservés

### 14.2 Génération de rapport
- Modal avec options
- Preview avant export
- Progress bar pendant génération
- Download automatique

---

## 15. GESTION DES PERMISSIONS

### 15.1 Visibilité des éléments par rôle

**Administrateur :**
- Accès total
- Toutes les pages visibles
- Tous les boutons d'action disponibles

**Agent Service Intermédiaire :**
- Dashboard : Lecture seule
- Activités : Peut clôturer, pas modifier/supprimer
- Transactions : Lecture seule
- Utilisateurs : Non visible

**Utilisateur Standard :**
- Dashboard : Ses activités uniquement
- Activités : Peut ajouter recettes/dépenses sur ses activités assignées
- Transactions : Ses saisies uniquement
- Utilisateurs : Non visible

### 15.2 États désactivés
- Boutons grisés avec tooltip explicatif
- Message "Accès restreint" sur sections non autorisées

---

## 16. RECHERCHE & FILTRES AVANCÉS

### 16.1 Barre de recherche globale
- Position : Header (optionnel)
- Recherche dans : Activités, Transactions, Utilisateurs
- Résultats groupés par catégorie
- Highlight des termes recherchés

### 16.2 Filtres combinés
- Opérateurs AND/OR
- Sauvegarde de filtres favoris
- Reset rapide

---

## ANNEXE : CHECKLIST DESIGN

### Phase 1 : Wireframes
- [ ] Structure header
- [ ] Layout dashboard
- [ ] Cards activités
- [ ] Tableau transactions
- [ ] Modals principales
- [ ] Navigation responsive

### Phase 2 : UI Design
- [ ] Charte graphique définie
- [ ] Composants atomiques (boutons, inputs, badges)
- [ ] Templates de pages principales
- [ ] États interactifs définis
- [ ] Illustrations & icônes

### Phase 3 : Prototype
- [ ] Navigation fonctionnelle
- [ ] Micro-interactions
- [ ] Animations de transition
- [ ] Flows utilisateurs complets
- [ ] Tests utilisateurs

### Phase 4 : Handoff Dev
- [ ] Design system documenté
- [ ] Assets exportés
- [ ] Spécifications techniques
- [ ] Tokens de design (couleurs, spacing...)
- [ ] Documentation accessibilité

---

**Version** : 1.0  
**Date** : Octobre 2024  
**Auteur** : Équipe UX/UI FinTrack Pro