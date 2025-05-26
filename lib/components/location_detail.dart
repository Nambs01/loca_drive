
import 'package:flutter/material.dart';

import '../models/location.dart';
import '../utils/format_currency.dart';

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

Widget buildDetailSheet(BuildContext context, Location location) {
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Détails de la location',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Nom de location', location.nomLocation),
        _buildDetailRow('Modèle', location.designVoiture),
        _buildDetailRow('Durée', '${location.nbrJours} jours'),
        _buildDetailRow('Taux journalier', formatCurrency(location.taux)),
        _buildDetailRow('Montant total', formatCurrency(location.montant)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer' , style: TextStyle(color: Colors.white),),
          ),
        ),
      ],
    ),
  );
}