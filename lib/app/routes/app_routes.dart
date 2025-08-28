part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const MAIN = _Paths.MAIN;
  static const SUBJECTS = _Paths.SUBJECTS;
  static const TEACHERS = _Paths.TEACHERS;
  static const LESSONS = _Paths.LESSONS;
  static const LESSON_DETAILS = _Paths.LESSON_DETAILS;
  static const BROWSE_QUESTIONS = _Paths.BROWSE_QUESTIONS;
  static const QUIZ = _Paths.QUIZ;
  static const MY_TESTS = _Paths.MY_TESTS;
  static const CREATE_CUSTOM_TEST = _Paths.CREATE_CUSTOM_TEST;
  static const FAVORITES = _Paths.FAVORITES;
  static const FAVORITE_TESTS = _Paths.FAVORITE_TESTS;
  static const CHALLENGE_QUIZ = _Paths.CHALLENGE_QUIZ;
  static const CHALLENGES = _Paths.CHALLENGES;
  static const TEACHER_PROFILE = _Paths.TEACHER_PROFILE;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
}

abstract class _Paths {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const MAIN = '/main';
  static const SUBJECTS = '/subjects';
  static const TEACHERS = '/teachers';
  static const LESSONS = '/lessons';
  static const LESSON_DETAILS = '/lesson-details';
  static const BROWSE_QUESTIONS = '/browse-questions';
  static const QUIZ = '/quiz';
  static const MY_TESTS = '/my-tests';
  static const CREATE_CUSTOM_TEST = '/create-custom-test';
  static const FAVORITES = '/favorites';
  static const FAVORITE_TESTS = '/favorite-tests';
  static const CHALLENGES = '/challenges';
  static const CHALLENGE_QUIZ = '/challenge-quiz';
  static const TEACHER_PROFILE = '/teacher-profile';
  static const NOTIFICATIONS = '/notifications';
}
