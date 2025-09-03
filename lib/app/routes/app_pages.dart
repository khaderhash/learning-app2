import 'package:get/get.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/signup_screen.dart';
import '../modules/browse_questions/browse_question_screen.dart';
import '../modules/challenge/challenges_binding.dart';
import '../modules/challenge/challenges_screen.dart';
import '../modules/challenge_quiz/challenge_quiz_binding.dart';
import '../modules/challenge_quiz/challenge_quiz_screen.dart';
import '../modules/create_custom_test/create_custome_binding.dart';
import '../modules/create_custom_test/create_custome_test_screen.dart';
import '../modules/main_screen/main_screen.dart';
import '../modules/main_screen/main_screen_binding.dart';
import '../modules/notifications/notifications_binding.dart';
import '../modules/notifications/notifications_screen.dart';
import '../modules/quiz/quiz_result_binding.dart';
import '../modules/quiz/quiz_result_screen.dart';
import '../modules/subjects/subjects_binding.dart';
import '../modules/subjects/subjects_screen.dart';
import '../modules/teacher_profile/teacher_profile_binding.dart';
import '../modules/teacher_profile/teacher_profile_screen.dart';
import '../modules/teachers/teachers_binding.dart';
import '../modules/teachers/teachers_screen.dart';
import '../modules/lessons/lessons_binding.dart';
import '../modules/lessons/lessons_screen.dart';
import '../modules/lesson_details/lesson_details_binding.dart';
import '../modules/lesson_details/lesson_details_screen.dart';
import '../modules/browse_questions/browse_questions_binding.dart';
import '../modules/quiz/quiz_binding.dart';
import '../modules/quiz/quiz_screen.dart';
import '../modules/my_tests/my_tests_binding.dart';
import '../modules/my_tests/my_tests_screen.dart';
import '../modules/favorites/favorites_binding.dart';
import '../modules/favorites/favorite_teachers_screen.dart';
import '../modules/favorites/favorite_tests_binding.dart';
import '../modules/favorites/favorite_tests_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL_AUTHENTICATED = Routes.MAIN;
  static const INITIAL_UNAUTHENTICATED = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainScreen(),
      binding: MainScreenBinding(),
    ),

    GetPage(
      name: _Paths.SUBJECTS,
      page: () => const SubjectsScreen(),
      binding: SubjectsBinding(),
    ),
    GetPage(
      name: _Paths.MY_TESTS,
      page: () => const MyTestsScreen(),
      binding: MyTestsBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITES,
      page: () => const FavoriteTeachersScreen(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_CUSTOM_TEST,
      page: () => const CreateCustomTestScreen(),
      binding: CreateCustomTestBinding(),
    ),

    GetPage(
      name: _Paths.TEACHERS,
      page: () => const TeachersScreen(),
      binding: TeachersBinding(),
    ),
    GetPage(
      name: _Paths.LESSONS,
      page: () => const LessonsScreen(),
      binding: LessonsBinding(),
    ),
    GetPage(
      name: _Paths.LESSON_DETAILS,
      page: () => const LessonDetailsScreen(),
      binding: LessonDetailsBinding(),
    ),
    GetPage(
      name: _Paths.BROWSE_QUESTIONS,
      page: () => const BrowseQuestionsScreen(),
      binding: BrowseQuestionsBinding(),
    ),

    GetPage(
      name: _Paths.QUIZ,
      page: () => const QuizScreen(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITE_TESTS,
      page: () => const FavoriteTestsScreen(),
      binding: FavoriteTestsBinding(),
    ),
    GetPage(
      name: _Paths.CHALLENGES,
      page: () => const ChallengesScreen(),
      binding: ChallengesBinding(),
    ),
    GetPage(
      name: _Paths.CHALLENGE_QUIZ,
      page: () => const ChallengeQuizScreen(),
      binding: ChallengeQuizBinding(),
    ),
    GetPage(
      name: _Paths.TEACHER_PROFILE,
      page: () => const TeacherProfileScreen(),
      binding: TeacherProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ,
      page: () => const QuizScreen(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ_RESULT,
      page: () => const QuizResultScreen(),
      binding: QuizResultBinding(),
    ),
  ];
}
