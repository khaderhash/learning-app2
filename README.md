# Student Learning Platform - E-Learning Flutter App


A comprehensive, feature-rich e-learning mobile application designed for students, built with Flutter and GetX. This project showcases a complete student workflow, from authentication and course browsing to interactive quizzes, real-time chat, and community features. The application is architected using the **GetX MVC pattern**, ensuring a clean, scalable, and maintainable codebase.

**[View UI/UX Design on Behance](https://www.behance.net/gallery/234016951/learning-app-for-student)**

---

## ✨ Key Features

This application provides a complete toolset for a modern student's learning journey:

- **User Authentication:** Secure login, registration, and profile management.
- **Dynamic Dashboard:** A personalized home screen welcoming the student and providing quick access to key features.
- **Course & Teacher Discovery:**
  - Browse all available subjects with details.
  - View profiles of teachers for each subject.
  - Request to join a course with a specific teacher.
- **Interactive Learning:**
  - View video lessons and download PDF summaries.
  - Browse lesson-specific Q&A for study and review.
  - **Nested Commenting System:** Engage in discussions, post comments, and reply to others under each lesson.
- **Comprehensive Quiz & Challenge System:**
  - **Lesson Quizzes:** Take tests based on a single lesson.
  - **Custom Quizzes:** Generate random tests from multiple selected lessons.
  - **Live Challenges:** Participate in timed challenges created by teachers.
  - **Instant Results:** Get immediate feedback with scores and status.
- **Social & Engagement Features:**
  - **Real-time Chat:** One-on-one chat with teachers.
  - **Teacher Ratings:** Rate teachers based on your experience.
  - **Favorites System:** Access special quizzes from teachers who have favorited you.
  - **Notifications:** A central hub for all updates, requests, and new challenges.
- **Progress Tracking:**
  - Review history and results of all past tests and challenges in the "My Tests" section.

---

## 🛠️ Tech Stack & Architecture

This project was built using modern technologies and best practices to ensure high performance and scalability.

- **Frontend:**
  - **Framework:** Flutter 3.x
  - **State Management:** GetX (Reactive State Management)
  - **Architecture:** MVC (Model-View-Controller) with GetX
  - **Networking:** `http` package for RESTful API communication.
  - **Local Storage:** `flutter_secure_storage` for securely storing authentication tokens.
- **Backend (External):**
  - A robust **Laravel** backend provides the RESTful APIs for all data operations.

### Architectural Approach

The application follows a **feature-first** directory structure, where each feature (e.g., `auth`, `quiz`, `chat`) is a self-contained module. Within each module, the code is organized into:
- **`Models`**: Defines the data structures.
- **`Providers` (Data Layer)**: Handles raw data fetching from the API.
- **`Controllers` (Logic Layer)**: Manages the state and business logic for each screen.
- **`Views` (UI Layer)**: Renders the UI based on the controller's state.
- **`Bindings`**: Handles dependency injection for the controllers.

This approach ensures a clean separation of concerns, making the app easy to test, debug, and scale.

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK (version 3.x or higher)

### Installation

1. Clone the repo:
   ```sh
   git clone https://github.com/khaderhash/learning-app2.git
