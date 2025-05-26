import 'package:flutter/material.dart';
import 'package:loca_vam/components/toast.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../stores/location_store.dart';

Future<void> confirmDelete(BuildContext context, Location location) async {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // Empêche la fermeture en cliquant à l'extérieur
    builder: (context) => AlertDialog(
      title: const Text('Confirmer la suppression'),
      content: Text(
        'Voulez-vous vraiment supprimer la location "${location.nomLocation}" ?',
        style: theme.textTheme.bodyMedium,
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        // Bouton Annuler
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.onSurface,
            side: BorderSide(color: colors.outline),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),

        // Bouton Supprimer
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Supprimer'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    try {
      await Provider.of<LocationStore>(context, listen: false)
          .removeLocation(location);
      showSuccessMessage(context, "Location supprimer avec succès");
    } catch (e) {
      showErrorMessage(context, e);
    }
  }
}
