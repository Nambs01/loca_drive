class Location {
  final int id;
  String nomLocation;
  String designVoiture;
  int nbrJours;
  double taux;
  double montant;

  Location({
    required this.id,
    required this.nomLocation,
    required this.designVoiture,
    required this.nbrJours,
    required this.taux,
    required this.montant,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      nomLocation: json['nom_location'],
      designVoiture: json['design_voiture'],
      nbrJours: json["nbr_jours"],
      taux: json['taux'],
      montant: json['montant']
    );
  }
}

class LocationCreateDto {
  final String nomLocation;
  final String designVoiture;
  final int nbrJours;
  final double taux;

  LocationCreateDto({
    required this.nomLocation,
    required this.designVoiture,
    required this.nbrJours,
    required this.taux,
  });

  Map<String, dynamic> toJson() => {
    'nom_location': nomLocation,
    'design_voiture': designVoiture,
    'nbr_jours': nbrJours,
    'taux': taux,
  };
}
