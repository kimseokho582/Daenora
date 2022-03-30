class User {
  String name;
  String studentId;

  User(this.name, this.studentId);
  @override
  String toString() => '$name , $studentId';
}
