# 🚀 ReportX-Agent: AI-Powered Performance Intelligence Dashboard

**TalentPulse** - An advanced Flutter application for intelligent data analysis, reporting, and AI-driven agent development using Google's Generative AI APIs.

---

## 📋 Overview

**ReportX-Agent** is a modern Flutter application that provides an intelligent dashboard for data analysis, performance monitoring, and reporting. It leverages Google's cutting-edge AI technologies (Gemini, Vertex AI) to build autonomous agents that can analyze files, generate reports, and provide actionable insights.

### 🎯 Core Objectives

- 📊 Build intelligent dashboards with real-time data visualization
- 🤖 Develop AI agents using Google Generative AI APIs
- 📁 Analyze uploaded files and generate comprehensive reports
- 🎨 Create beautiful, responsive user interfaces
- 🔐 Secure integration with Google Cloud services
- 🌐 Deploy scalable solutions on Firebase and Google Cloud

### ✨ Key Features

- 📊 **Interactive Dashboard** - Real-time data visualization
- 🤖 **AI Agent Framework** - Google Gemini & Vertex AI integration
- 📈 **Advanced Charts** - Using industry-standard `fl_chart` library
- 🎨 **Modern UI** - Beautiful animations with Material Design 3
- 🌐 **Web & Mobile Support** - Cross-platform compatibility
- 📁 **File Analysis** - Process and analyze uploaded documents
- 🔤 **Professional Typography** - Google Fonts integration
- 📅 **Internationalization** - Multi-language and timezone support
- ☁️ **Cloud Integration** - Firebase Hosting & Google Cloud services

---

## 🛠️ Technology Stack

### Core Framework & Language
```
Flutter 3.0.0+  (Multi-platform framework)
Dart 3.0.0+     (Programming language)
```

### Google AI & Cloud Services

#### 1. **Google Gemini API** (Recommended for Agents)
```
Official Documentation: https://ai.google.dev/
Latest Model: gemini-2.0-flash (or latest available)
Purpose: Text generation, analysis, and AI agent logic
```

#### 2. **Google Vertex AI** (Enterprise Grade)
```
Documentation: https://cloud.google.com/vertex-ai/docs/generative-ai/overview
Authentication: Service Account + OAuth 2.0
Features: PaLM API, Gemini, Custom Models
```

#### 3. **Google Cloud APIs**
- **Cloud Storage** - File management and uploads
- **Cloud Functions** - Serverless agent execution
- **Cloud Datastore** - Structured data storage
- **Cloud Logging** - Monitoring and debugging

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| **http** | ^1.1.0 | HTTP requests and API calls |
| **google_fonts** | ^6.1.0 | Premium typography |
| **fl_chart** | ^0.69.2 | Data visualization & charting |
| **uuid** | ^4.0.0 | Unique identifier generation |
| **flutter_animate** | ^4.2.0 | Smooth animations |
| **intl** | ^0.19.0 | Internationalization & localization |
| **file_picker** | ^8.0.0 | File selection & upload |
| **googleapis_auth** | ^1.4.0 | Google OAuth 2.0 authentication |
| **gcloud** | Latest | Google Cloud SDK for Dart |
| **json_serializable** | Latest | JSON serialization helpers |

### Google AI SDKs to Integrate

#### **Option 1: Google Gemini API (REST)**
```dart
Dependencies:
  http: ^1.1.0
  
API Endpoint:
  https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent

Authentication:
  API Key from https://ai.google.dev/
```

#### **Option 2: Google Vertex AI (Recommended for Production)**
```dart
Dependencies:
  googleapis_auth: ^1.4.0
  http: ^1.1.0
  
API Endpoint:
  https://{region}-aiplatform.googleapis.com/v1/projects/{project}/locations/{region}/publishers/google/models/{model}:predict

Authentication:
  Service Account JSON Key + OAuth 2.0 scopes:
  - https://www.googleapis.com/auth/cloud-platform
  - https://www.googleapis.com/auth/vertex-ai
```

---

## 📁 Project Structure

```
ReportX-Agent/
├── lib/
│   ├── main.dart                      # Entry point
│   ├── models/                        # Data models
│   │   ├── user_model.dart
│   │   ├── report_model.dart
│   │   └── analysis_result.dart
│   ├── services/                      # Business logic & API
│   │   ├── gemini_service.dart        # Gemini AI integration
│   │   ├── vertex_ai_service.dart     # Vertex AI integration
│   │   ├── file_analyzer_service.dart # File processing
│   │   ├── api_client.dart            # HTTP client
│   │   └── auth_service.dart          # Google OAuth
│   ├── pages/                         # Screens
│   │   ├── home_page.dart
│   │   ├── dashboard_page.dart
│   │   ├── file_upload_page.dart
│   │   └── agent_chat_page.dart
│   ├── widgets/                       # Reusable components
│   │   ├── chart_widget.dart
│   │   ├── report_card.dart
│   │   └── ai_response_widget.dart
│   ├── utils/                         # Utilities
│   │   ├── constants.dart
│   │   ├── extensions.dart
│   │   └── formatters.dart
│   └── config/                        # Configuration
│       ├── google_config.dart
│       └── app_config.dart
├── test/                              # Unit & widget tests
├── web/                               # Web platform
│   ├── index.html
│   ├── main.js
│   └── assets/
├── pubspec.yaml                       # Dependencies
├── pubspec.lock                       # Locked versions
├── firebase.json                      # Firebase config
├── .firebaserc                        # Firebase project
├── analysis_options.yaml              # Linter rules
└── .env.example                       # Environment variables (template)
```

### Key Service Files

#### **gemini_service.dart**
```dart
// AI agent service using Gemini API
// - Text generation
// - Prompt engineering
// - Multi-turn conversations
// - Document summarization
// - Report generation
```

#### **vertex_ai_service.dart**
```dart
// Enterprise AI service using Vertex AI
// - Advanced model fine-tuning
// - Custom training
// - Batch processing
// - Production-grade deployment
```

#### **file_analyzer_service.dart**
```dart
// File analysis engine
// - Document parsing (PDF, Excel, CSV, JSON)
// - Data extraction
// - Format conversion
// - Sentiment analysis
// - Pattern recognition
```

---

## 🚀 Quick Start Guide

### Prerequisites

- ✅ **Flutter SDK** 3.0.0+ ([Install](https://flutter.dev/docs/get-started/install))
- ✅ **Dart SDK** 3.0.0+ (included with Flutter)
- ✅ **Google Account** with API access
- ✅ **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- ✅ **Google Cloud Project** (for Vertex AI)

### Installation Steps

#### 1. Clone the Repository
```bash
git clone https://github.com/AbdulMalik-Kahil/ReportX-Agent.git
cd ReportX-Agent
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Configure Google APIs

**For Gemini API:**
```bash
# Get API key from https://ai.google.dev/
# Create a .env file in project root:
echo "GEMINI_API_KEY=your_api_key_here" > .env
```

**For Vertex AI:**
```bash
# Download service account JSON from Google Cloud Console
mkdir -p config
# Copy your-service-account.json to config/
cp /path/to/service-account.json config/google-cloud-key.json
```

#### 4. Update Configuration
Edit `lib/config/google_config.dart`:
```dart
class GoogleConfig {
  static const String geminiApiKey = 'your_api_key_here';
  static const String projectId = 'your-project-id';
  static const String vertexAiRegion = 'us-central1';
  static const String bucketName = 'your-gcs-bucket';
}
```

#### 5. Run the Application

**Android Emulator:**
```bash
flutter run -d emulator
```

**iOS Simulator:**
```bash
flutter run -d iphone
```

**Web Browser:**
```bash
flutter run -d chrome
```

**Device:**
```bash
flutter run
```

#### 6. Build for Release
```bash
# Web
flutter build web --release

# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🤖 AI Agent Development Guide

### Using Google Gemini API

#### **1. Basic Setup**

**pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  dio: ^5.3.0
  google_fonts: ^6.1.0
```

#### **2. Gemini Service Implementation**

```dart
// lib/services/gemini_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  final String apiKey;
  final String model = 'gemini-2.0-flash'; // Latest model
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  GeminiService({required this.apiKey});

  /// Generate text using Gemini
  Future<String> generateText(String prompt) async {
    final url = Uri.parse(
      '$baseUrl/models/$model:generateContent?key=$apiKey'
    );

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'parts': [{'text': prompt}]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 1024,
        'topP': 0.95,
      }
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return text;
      } else {
        throw Exception('Gemini API Error
