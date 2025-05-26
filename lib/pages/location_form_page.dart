import 'package:flutter/material.dart';
import 'package:loca_vam/components/appbar_custom.dart';
import 'package:loca_vam/components/toast.dart';
import 'package:loca_vam/models/location.dart';
import 'package:loca_vam/stores/location_store.dart';
import 'package:provider/provider.dart';

class LocationFormPage extends StatefulWidget {
  final Location? location;
  final VoidCallback onSuccess;

  const LocationFormPage({
    super.key,
    this.location,
    required this.onSuccess,
  });
  @override
  State<LocationFormPage> createState() => _LocationFormPageState();
}

class _LocationFormPageState extends State<LocationFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _modeleController;
  late TextEditingController _joursController;
  late TextEditingController _tauxController;
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.location != null;
    _nomController = TextEditingController(text: widget.location?.nomLocation ?? '');
    _modeleController = TextEditingController(text: widget.location?.designVoiture ?? '');
    _joursController = TextEditingController(text: widget.location?.nbrJours.toString() ?? '');
    _tauxController = TextEditingController(text: widget.location?.taux.toString() ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _modeleController.dispose();
    _joursController.dispose();
    _tauxController.dispose();
    super.dispose();
  }

  void _clear() {
    _nomController = TextEditingController(text: "");
    _modeleController = TextEditingController(text: "");
    _joursController = TextEditingController(text: "");
    _tauxController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: appBarCustom(context: context),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditMode ? "Modifier la location" : "Ajouter une nouvelle location",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 10),

                // Champ Nom de la location
                ..._buildFormField(
                  controller: _nomController,
                  label: 'Nom de la location',
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Veuillez entrer le nom'
                      : null,
                ),

                // Champ Modèle de voiture
                ..._buildFormField(
                  controller: _modeleController,
                  label: 'Modèle du véhicule',
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Veuillez entrer le modèle'
                      : null,
                ),

                // Champ Durée en jours
                ..._buildFormField(
                  controller: _joursController,
                  label: 'Durée (jours)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Veuillez entrer la durée';
                    if (int.tryParse(value!) == null || int.tryParse(value)! < 1) return 'Nombre entier requis';
                    return null;
                  },
                ),

                // Champ Taux horaire
                ..._buildFormField(
                  controller: _tauxController,
                  label: 'Taux journalier',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Veuillez entrer le taux';
                    if (double.tryParse(value!) == null || double.tryParse(value)! < 1) return 'Nombre valide requis';
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Boutons d'action
                Row(
                  children: [
                    // Bouton Annuler
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _cancelForm,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: BorderSide(color: colors.primary),
                        ),
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: colors.primary, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Bouton Valider
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: colors.primary,
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                          color: colors.primary,
                          strokeWidth: 2,
                        )
                            : Text(
                          'Valider',
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {

    return [
      const SizedBox(height: 20),

      Text(label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 5),

      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          counterStyle: TextStyle(
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: validator,
        keyboardType: keyboardType,
      )
    ];
  }

  void _cancelForm() {
    widget.onSuccess();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final store = Provider.of<LocationStore>(context, listen: false);

      final location = LocationCreateDto(
        nomLocation: _nomController.text,
        designVoiture: _modeleController.text,
        nbrJours: int.tryParse(_joursController.text) ?? 0,
        taux: double.tryParse(_tauxController.text) ?? 0,
      );

      if (_isEditMode) {
        await store.updateLocation(widget.location!.id, location);
      } else {
        await store.addLocation(location);
      }
      if (!mounted) return;
      widget.onSuccess();
       showSuccessMessage(context, _isEditMode
           ? 'Location modifiée avec succès!'
           : 'Location ajoutée avec succès!'
       );
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(context, e);
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }
}