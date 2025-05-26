import 'package:flutter/material.dart';
import 'package:loca_vam/components/location_item.dart';
import 'package:provider/provider.dart';
import '../stores/location_store.dart';



class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool _isLoading = true;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Provider
          .of<LocationStore>(context, listen: false)
          .getListLocation();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
    }
    if (_error.isNotEmpty) {
      return Center(child: Text("Erreur : $_error"));
    }

    return Consumer<LocationStore>(
      builder: (context, store, child) {
        if (store.locations.isEmpty) {
          return const Center(child: Text("Aucune location trouvée."));
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              // heading
              Container(
                margin: EdgeInsets.only(top: 20),
                child: const Text(
                  "Liste des locations",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),

              const SizedBox(height: 10),

              ...store.locations.map(
                    (location) => LocationItem(location: location),
              ),

              const SizedBox(height: 80),

            ],
          ),
        );
      },
    );
  }
}
