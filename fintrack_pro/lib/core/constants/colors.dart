// Couleurs principales FinTrack Pro
import 'package:flutter/material.dart';

class FinTrackColors {
  // Couleurs principales (vert)
  static const Color primary = Color(0xFF1A5554);      // Vert foncé - header, boutons primaires
  static const Color secondary = Color(0xFF2B7A78);    // Vert moyen - éléments interactifs
  static const Color accent = Color(0xFF3D9B99);       // Vert clair - hover states
  static const Color light = Color(0xFFE8F5F4);        // Vert pastel - backgrounds secondaires

  // Couleurs d'accentuation
  static const Color warning = Color(0xFFFFB800);      // Jaune/Ambre - alertes
  static const Color success = Color(0xFF10B981);      // Vert success - positif
  static const Color error = Color(0xFFEF4444);        // Rouge - erreurs
  static const Color info = Color(0xFF3B82F6);         // Bleu info

  // Couleurs neutres
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF3F4F6);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textPrimary = Color(0xFF1F2937);

  // Couleurs d'état pour les transactions
  static const Color pending = Color(0xFFFFB800);      // En attente
  static const Color approved = Color(0xFF10B981);     // Approuvé
  static const Color rejected = Color(0xFFEF4444);     // Rejeté
  static const Color completed = Color(0xFF10B981);    // Complété

  // Couleurs d'activité
  static const Color activityActive = Color(0xFF1A5554);
  static const Color activityClosed = Color(0xFF9CA3AF);
  static const Color activitySuspended = Color(0xFFFFB800);
}