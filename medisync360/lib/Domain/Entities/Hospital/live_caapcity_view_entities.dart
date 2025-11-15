class LiveCaapcityViewEntities {
  final int id;
  final String name;
  final String city;
  final String state;
  final bool emergencyServices;
  final int totalBeds;
  final int occupiedBeds;
  final int icuBedsTotal;
  final int icuBedsOccupied;
  final int emergencyBedsTotal;
  final int emergencyBedsOccupied;
  final int generalWardTotal;
  final int generalWardOccupied;
  final int cardiologyBedsTotal;
  final int cardiologyBedsOccupied;
  final int pediatricsBedsTotal;
  final int pediatricsBedsOccupied;
  final int surgeryBedsTotal;
  final int surgeryBedsOccupied;
  final int maternityBedsTotal;
  final int maternityBedsOccupied;
  final String establishedYear;
  final double rating;

  LiveCaapcityViewEntities({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.emergencyServices,
    required this.totalBeds,
    required this.occupiedBeds,
    required this.icuBedsTotal,
    required this.icuBedsOccupied,
    required this.emergencyBedsTotal,
    required this.emergencyBedsOccupied,
    required this.generalWardTotal,
    required this.generalWardOccupied,
    required this.cardiologyBedsTotal,
    required this.cardiologyBedsOccupied,
    required this.pediatricsBedsTotal,
    required this.pediatricsBedsOccupied,
    required this.surgeryBedsTotal,
    required this.surgeryBedsOccupied,
    required this.maternityBedsTotal,
    required this.maternityBedsOccupied,
    required this.establishedYear,
    required this.rating,
  });
}