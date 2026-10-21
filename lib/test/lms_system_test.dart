// import 'package:lms_layered_architecture_example/model/student.dart';
import 'package:test/test.dart';

import '../service/lms_system.dart';

void main() {
  test('tests', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    lms.addCourse(courseId: 'C1', courseName: "Maths");

    lms.addCourse(courseId: 'C2', courseName: "Physics");

    expect(lms.students.first.name, 'ronan');

    lms.removeCourse(courseId: 'C2');

    print(lms.courses.map((course) => course.id).toList());
  });

  test('enrolls a student in a course', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    lms.addCourse(courseId: 'C1', courseName: "Maths");

    lms.enrollStudentInCourse(studentId: 'S1', courseId: 'C1');

    expect(lms.courses.first.studentIds.contains('S1'), true);

    print(lms.courses.first.studentIds);
  });

  test('rejects enrolling a student if student does not exist', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: "Maths");

    expect(
      () => lms.enrollStudentInCourse(studentId: 'S1', courseId: 'C1'),
      throwsA(isA<Exception>()),
    );
  });

  test('rejects enrolling a student if course does not exist', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(
      () => lms.enrollStudentInCourse(studentId: 'S1', courseId: 'C1'),
      throwsA(isA<Exception>()),
    );
  });

  test('rejects enrolling a student if student is already enrolled in the course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: "ronan");

    lms.addCourse(courseId: 'C1', courseName: "Maths");

    lms.enrollStudentInCourse(studentId: 'S1', courseId: 'C1');

    expect(
      () => lms.enrollStudentInCourse(studentId: 'S1', courseId: 'C1'),
      throwsA(isA<Exception>()),
    );
  });

  test('verify that a student is removed from the course when the student is removed from course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: "ronan");

    lms.addCourse(courseId: 'C1', courseName: "Maths");

    lms.enrollStudentInCourse(studentId: 'S1', courseId: 'C1');

    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');

    expect(lms.courses.first.studentIds.contains('S1'), false);
  });

  test('verify that a student is removed from the course when the student is removed from the system', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: "ronan");

    lms.addCourse(courseId: 'C1', courseName: "Maths");

    lms.enrollStudentInCourse(studentId: 'S1', courseId: 'C1');

    lms.removeStudent(studentId: 'S1');

    expect(lms.courses.first.studentIds.contains('S1'), false);
  });
}
