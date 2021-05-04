class Event{
  final String college;
  final String hash;
  final String title;
  final String date;
  final String timeFrom;
  final String timeTo;
  final String location;
  final String image;
  final String description;
  final List<EventAtendee> atendees;

  Event(this.college, this.hash, this.title, this.date, this.timeFrom, this.timeTo, this.location,
      this.image, this.description, this.atendees);

  @override
  int compareTo(Event other) {

    if (this.timeFrom == null || other == null) {
      return null;
    }

    if (double.parse(this.timeFrom.replaceAll(new RegExp(r':'), '.').substring(0,timeFrom.length-3)) < double.parse(other.timeFrom.replaceAll(new RegExp(r':'), '.').substring(0,other.timeFrom.length-3))) {
      return 1;
    }

    if (double.parse(this.timeFrom.replaceAll(new RegExp(r':'), '.').substring(0,timeFrom.length-3)) > double.parse(other.timeFrom.replaceAll(new RegExp(r':'), '.').substring(0,other.timeFrom.length-3))) {
      return -1;
    }

    if (double.parse(this.timeFrom.replaceAll(new RegExp(r':'), '.').substring(0,timeFrom.length-3)) == double.parse(other.timeFrom.replaceAll(new RegExp(r':'), '.').substring(0,other.timeFrom.length-3))) {
      return 0;
    }

    return null;
  }
}

class EventAtendee {
  final String image;
  final String name;
  final String id;

  EventAtendee(
    this.image,
    this.name,
      this.id,
  );
}