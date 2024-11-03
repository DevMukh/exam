class GradeModel {
  double grade1;
  double grade2;
  double grade3;

  GradeModel({
    required this.grade1,
    required this.grade2,
    required this.grade3,
  });

  // Calculate the total grade sum
  double get totalGradeSum {
    double average = (grade1 + grade2 + grade3) / 3;
    return average.floorToDouble(); // Round down to the nearest integer
  }

  // Calculate percentage representation
  double get grade1Percent => grade1 / 100;
  double get grade2Percent => grade2 / 100;
  double get grade3Percent => grade3 / 100;

  // Get the percentage of total grades
  double get totalGradePercent => totalGradeSum / 100;
}
