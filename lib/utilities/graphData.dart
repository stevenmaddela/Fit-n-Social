class GraphData implements Comparable<GraphData> {
  String label;
  double value;

  GraphData(this.label, this.value);

  @override
  int compareTo(GraphData other) {
    return this.value.compareTo(other.value);
  }
  @override
  String toString() {
    // TODO: implement toString
    return this.label + " ," + this.value.toString();
  }
}