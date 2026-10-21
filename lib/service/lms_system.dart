import '../model/student.dart';
import '../model/course.dart';
import '../model/result.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<Result> results = [];
 
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  void addCourse({required String courseId, required String courseName}) {
    Course? course = _findCourseOrNull(courseId);
    if (course != null) {
      throw Exception('Course $course already exists');
    }

    courses.add(Course(id: courseId, name: courseName));
  }

  void addResult({required String courseId, required String studentId, required double score}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }

    if (score < 0 || score > 100) {
      throw Exception('Score must be between 0 and 100');
    }
    Result? existingResult = _findResultOrNull(courseId, studentId);
    if (existingResult != null) {
      throw Exception('Result for student $studentId in course $courseId already exists');
    }

    results.add(Result(courseId: courseId, studentId: studentId, score: score));
  }
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);

    // 2- Remove student from all courses
    for (Course course in courses) {
      course.studentIds.remove(studentId);
    }
  }

  void removeCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (course.studentIds.isNotEmpty) {
      throw Exception('Course $courseId has students enrolled');
    }
    courses.removeWhere((course) => course.id == courseId);
  }

  void removeResult({required String courseId, required String studentId}) {
    Result? result = _findResultOrNull(courseId, studentId);
    if (result == null) {
      throw Exception('Result for student $studentId in course $courseId not found');
    }
    results.removeWhere((result) => result.courseId == courseId && result.studentId == studentId);
  }

  void enrollStudentInCourse({required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    if (course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is already enrolled in course $courseId');
    }

    course.studentIds.add(studentId);
  }

  void discardStudentFromCourse({required String studentId, required String courseId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }

    course.studentIds.remove(studentId);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null;
  } 

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }
    return null;
  }

  Result? _findResultOrNull(String courseId, String studentId) {
    for (Result r in results) {
      if (r.courseId == courseId && r.studentId == studentId) {
        return r;
      }
    }
    return null;
  }
}
