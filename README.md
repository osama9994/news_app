# 📰 Flutter News App

A modern, high-performance cross-platform news application built with Flutter that delivers real-time news updates from around the world. The app offers a clean and responsive UI/UX with user authentication, email verification, offline reading capabilities, multi-language support, automated engagement notifications, and powerful search features.

---

## ✨ Features

* 🔐 **User Authentication & Email Verification:** Secure Login, Register, and Account Verification via direct email links before granting full access.
* ✉️ **Email Link Verification:** Direct confirmation links sent to user emails for enhanced account security.
* ⏰ **Periodic Reading Reminders:** Background notifications scheduled every 6 hours to keep users engaged with fresh news.
* 📰 **Browse & Feed Customization:** Real-time news delivery across categories and personal interest feeds.
* 🔍 **Smart Search:** Quickly search news articles by keywords and topics.
* 🏷️ **Category Filtering:** Filter content seamlessly based on reader preferences.
* ❤️ **Favorites & Offline Mode:** Save articles locally via `Hive` to read anytime without an internet connection.
* 🌙 **Dark Mode Support:** Clean, eye-friendly dark theme implementation.
* 🌍 **Localization:** Full Arabic & English support out of the box.
* 🔄 **In-App Translation:** Instant article translation into Arabic.
* 📤 **Social Sharing:** Share news articles effortlessly across platforms.
* 🔔 **Firebase Push Notifications:** Instant updates using Firebase Cloud Messaging (FCM).
* ⚡ **Performance Optimized:** Fast image caching and state management powered by `flutter_bloc`.
* 🛡️ **DevOps & Secure CI/CD:** Automated testing, static code analysis, and release APK generation using GitHub Actions with encrypted secrets.

---

## 🛠️ Tech Stack

| Category | Technology Used |
| :--- | :--- |
| **Framework & Language** | Flutter, Dart |
| **State Management** | BLoC / Cubit (`flutter_bloc`) |
| **Backend & Authentication** | Firebase Authentication, Cloud Firestore |
| **CI/CD & Automation** | GitHub Actions (Automated Linting, Testing, Release APK Build) |
| **Notifications & Scheduling** | Firebase Cloud Messaging (FCM), Local Notifications |
| **Local Storage** | Hive, Shared Preferences |
| **Networking & API** | Dio, Retrofit, REST API (NewsAPI) |
| **Security & Secrets** | GitHub Secrets, Base64 Environment Variable Injection |

---

## ⚙️ DevOps & CI/CD Pipeline

This project incorporates automated **Continuous Integration (CI)** and **Continuous Delivery (CD)** workflows via GitHub Actions:

- **CI Workflow (`ci.yml`):** Runs static code analysis (`flutter analyze`), verifies dependencies, and executes unit/widget tests on every `push` or `pull_request` to the `main` branch.
- **CD Workflow (`cd.yml`):** Automatically builds and exports signed production Release APKs when a release tag (e.g., `v1.0.0`) is published.
- **Security First:** Sensitive configuration files (`.env`, `google-services.json`, `firebase_options.dart`) are excluded from version control and injected dynamically into runner environments using Base64-encoded GitHub Repository Secrets.

---

## 📱 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/8d354e36-fbb7-4803-84b4-bfe9ae55cb14" alt="Home" width="200" />
  <img src="https://github.com/user-attachments/assets/e85a5c36-df49-46ab-8495-4d37366a7dc8" alt="My Interest" width="200" />
  <img src="https://github.com/user-attachments/assets/bd25d3f1-8b3e-4298-aa4c-7785765e52b9" alt="Edit Interest" width="200" />
  <img src="https://github.com/user-attachments/assets/967016fd-a90a-4f07-954c-824ce3470dad" alt="Login Account" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/d248498b-e4e0-418c-b7b9-563a92bc8eaf" alt="Categories" width="200" />
  <img src="https://github.com/user-attachments/assets/560880c6-406d-41ad-9177-2ce7ba4076da" alt="Create Account AR" width="200" />
  <img src="https://github.com/user-attachments/assets/7316e5b4-5d33-48e5-aaa1-50ccd9971b4d" alt="Create Account ENG" width="200" />
  <img src="https://github.com/user-attachments/assets/bd3034f8-f33d-4fe7-b05d-4745532dc0a7" alt="Drawer AR" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/5d496dd8-6e41-4f96-addb-a035021f2b0c" alt="Drawer" width="200" />
  <img src="https://github.com/user-attachments/assets/edd29366-9105-4cb3-80d7-03d9ed531d32" alt="Favorites" width="200" />
  <img src="https://github.com/user-attachments/assets/09571925-1d6a-458c-8f54-82a82bb6a671" alt="Profile" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/56cd1421-fc02-4662-93ef-02fbd8f48733" alt="Read Article" width="200" />
  <img src="https://github.com/user-attachments/assets/6a2e543f-ecc6-4816-a223-75b52ca7df08" alt="Translate Article" width="200" />
</p>

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.19.0 or higher)
* An active API key from [NewsAPI.org](https://newsapi.org/)
* Firebase project with Android configuration (`google-services.json`)

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/osama9994/news_app.git](https://github.com/osama9994/news_app.git)
   cd news_app