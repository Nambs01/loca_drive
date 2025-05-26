// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:loca_vam/components/confirm_delete.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../pages/location_form_page.dart';
import '../stores/location_store.dart';
import '../utils/format_currency.dart';

class LocationItem extends StatelessWidget {
  final Location location;

  const LocationItem({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // onTap: () => _showDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  // Icône voiture
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: colors.primary,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Titre et modèle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.nomLocation,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                        Text(
                          location.designVoiture,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge jours
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${location.nbrJours} j',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Barre séparatrice
              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),

              const SizedBox(height: 12),

              // Détails financiers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAmountItem(
                    context,
                    label: 'Taux journalier',
                    amount: location.taux,
                    icon: Icons.timelapse,
                  ),

                  _buildAmountItem(
                    context,
                    label: 'Montant total',
                    amount: location.montant,
                    icon: Icons.payments,
                    isTotal: true,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Bouton Éditer

                  _textButton(
                    context: context,
                    color: colors.primary,
                    label: "Modifier",
                    icon: Icons.edit_outlined,
                    handleClick: () => _editLocation(context),
                  ),

                  const SizedBox(width: 8),

                  // Bouton Supprimer

                  _textButton(
                    context: context,
                    color: colors.error,
                    label: "Supprimer",
                    icon: Icons.delete_outline,
                    handleClick: () => confirmDelete(context, location),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountItem(BuildContext context, {
    required String label,
    required double amount,
    required IconData icon,
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isTotal ? colors.primary : colors.onSurface.withOpacity(
                  0.6),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          formatCurrency(amount),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? colors.primary : colors.onSurface,
          ),
        ),
      ],
    );
  }

  // void _showDetails(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => buildDetailSheet(context, location),
  //   );
  // }

  TextButton _textButton({
    required BuildContext context,
    required Color color,
    required String label,
    required IconData icon,
    required VoidCallback handleClick,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: color.withOpacity(0.1)
      ),
      onPressed: handleClick,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _editLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationFormPage(
          location: location,
          onSuccess: () {
            // Rafraîchir les données après modification
            Provider.of<LocationStore>(context, listen: false).getListLocation();
            Navigator.pop(context); // Retour à la liste
          },
        ),
      ),
    );
  }
}