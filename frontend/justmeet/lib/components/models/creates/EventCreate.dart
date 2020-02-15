class EventCreate {
  final String name;
  final String location;
  final String description;
  final String date;
  final bool isFree;
  final String category;
  final int maxPersons;

  EventCreate({
    this.name,
    this.location,
    this.description,
    this.date,
    this.isFree,
    this.category,
    this.maxPersons,
  });
}
