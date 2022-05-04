class Lecture {
  String classId;
  String className;
  String profName;
  DateTime test;

  Lecture(
    this.classId,
    this.className,
    this.profName,
    this.test,
  );
  @override
  String toString() => '$classId, $className , $profName, $test ';
}
