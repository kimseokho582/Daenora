class Assignment {
  String title;
  String state;
  String startDate;
  String endDate;

  Assignment(this.title, this.state, this.startDate, this.endDate);
  @override
  String toString() => '$title $state $startDate $endDate';
}
