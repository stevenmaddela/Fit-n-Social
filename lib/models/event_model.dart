class Event{
  final String title;
  final String date;
  final String timeFrom;
  final String timeTo;
  final String location;
  final String image;
  final String description;
  final List<EventAtendee> atendees;

  Event(this.title, this.date, this.timeFrom, this.timeTo, this.location,
      this.image, this.description, this.atendees);

}

class EventAtendee {
  final String image;
  final String name;

  EventAtendee(
    this.image,
    this.name,
  );
}