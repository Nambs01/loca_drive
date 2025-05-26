import 'package:flutter/material.dart';
import 'package:loca_vam/components/appbar_custom.dart';
import 'package:loca_vam/pages/histogramme_page.dart';
import 'package:loca_vam/pages/location_form_page.dart';

import '../components/bottom_navbar.dart';
import 'location_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _openAddLocationForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationFormPage(
          onSuccess: () {
            Navigator.pop(context); // Retour à la liste après succès
          },
        ),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return const LocationPage();
      case 1:
        return const LocationHistogram();
      default:
        return const SizedBox.shrink(); // Ne devrait jamais arriver
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: appBarCustom(context: context),

      body:  _buildCurrentPage(),

      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        onPressed: () => _openAddLocationForm(),
        tooltip: 'Nouveau location',
        backgroundColor: colors.primary,
        child: const Icon(Icons.add, color: Colors.white,),
      ) : null,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

      bottomNavigationBar: _selectedIndex != 2 ? MyBottomNavbar(
        selectedIndex: _selectedIndex,
        onTabChange: navigateBottomBar,
      ) : null,
    );
  }
}
