# Where in the Law? 🇬🇭

A Flutter mobile application that helps Ghanaian citizens understand legal rights and obligations by providing easy access to Ghanaian laws with plain English explanations.

![Flutter](https://img.shields.io/badge/Flutter-3.19-blue)
![Dart](https://img.shields.io/badge/Dart-3.3-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 📱 App Overview

"Where in the Law?" transforms complex legal jargon into understandable language, making Ghana's legal system more accessible to everyone. Search by situation, category, or keywords to find relevant laws and their plain-English explanations.

## 🚀 Key Features

### 🔍 Smart Search & Discovery
- **Situation-based Search**: Find laws by real-life scenarios (rent, police, breastfeeding, driver, etc.)
- **Category Browsing**: Organized by 13+ legal categories with visual indicators
- **Keyword Search**: Real-time search across titles, keywords, and explanations
- **Advanced Filtering**: Combined text and category search with intelligent predicates

### 📚 Comprehensive Legal Categories
- **Housing & Property Law**
- **Rights & Freedoms** 
- **Business & Commercial Law**
- **Employment & Labor Rights**
- **Environmental Law**
- **Consumer Rights & Protection**
- **Education Law**
- **Health & Healthcare**
- **Family & Personal Law**
- **Justice & Legal Aid**
- **Transport & Transportation**
- **Technology & Communication**
- **General Legal Principles**

### 💡 Law Comprehension Tools
- **Dual Text Display**: Original legal text alongside plain English explanations
- **Proper Citations**: Complete law names, codes, and section references
- **Category Color Coding**: Visual theme system for easy category recognition
- **Professional Layout**: Card-based design with gold borders and consistent spacing

### ⭐ User Experience Features
- **Favorites System**: Persistent storage for frequently referenced laws
- **Offline Capability**: Access laws without internet connection
- **Beautiful UI**: Ghana-themed design with professional aesthetics
- **Responsive Design**: Optimized for mobile, tablet, and desktop

## 🛠️ Technical Implementation

### 🏗️ Project Architecture
where_in_the_law/
├── lib/
│ ├── main.dart # App entry point
│ ├── data/
│ │ └── law_data.dart # Law data management
│ ├── models/
│ │ └── law_model.dart # Law data model
│ ├── widgets/
│ │ ├── law_card.dart # Reusable law card widget
│ │ └── filter_dialog.dart # Category filter dialog
│ ├── screens/
│ │ ├── home_screen.dart # Main screen with all laws
│ │ ├── categories_screen.dart # Category browsing
│ │ ├── law_detail_screen.dart # Detailed law view
│ │ ├── search_screen.dart # Advanced search functionality
│ │ └── favorites_screen.dart # Saved laws management
│ └── services/
│ └── favorites_service.dart # Favorites management
├── assets/
│ ├── fonts/
│ │ └── NotoSans-Regular.ttf # Custom typography
│ ├── icon/
│ │ └── icon.png # App branding
│ └── law_data.json # Comprehensive law database

text

### 💾 Data Model
``dart
class Law {
  final String id;
  final String title;
  final String category;
  final String lawName;
  final String lawCode;
  final String section;
  final String legalText;
  final String plainExplanation;
  final List<String> searchKeywords;
  final bool isFavorite;
}
🎨 Design System
Color Scheme:

Primary Blue: #3498DB

Secondary Purple: #8E44AD

Accent Gold: #D4AF37

Background Gradient: #F5F7FA to #C3CFE2

Typography: NotoSans-Regular for optimal readability

Icons: Material Icons with category-specific assignments

Layout Principles: Consistent spacing, card-based design, intuitive navigation

📱 Key Screens & Functionality
Home Screen (home_screen.dart)
Comprehensive law overview with toggle between "All Laws" and "Categories"

Quick access to search and favorites functionality

Dynamic category filtering with visual indicators

Professional gradient background with Ghana-themed aesthetics

Categories Screen (categories_screen.dart)
Grid layout of 13+ legal categories with representative icons

Real-time law count per category

Visual color coding system for easy recognition

Smooth category-based navigation

Law Detail Screen (law_detail_screen.dart)
Complete legal text display with proper formatting

Side-by-side plain English explanations

Category-based color theming

Professional card layout with distinctive gold borders

Search Screen (search_screen.dart)
Real-time search across multiple data fields

Advanced multi-category filtering

Combined search predicates for precise results

Clean, intuitive search interface

Favorites Screen (favorites_screen.dart)
Persistent favorites storage managed by FavoritesService

Quick access to frequently referenced laws

Seamless integration with main navigation

🚀 Getting Started
Prerequisites
Flutter SDK (3.19 or higher)

Dart (3.3 or higher)

Android Studio/VSCode with Flutter extension

Installation & Development
bash
# Clone repository
git clone https://github.com/life2allsofts/where_in_the_law.git

# Navigate to project
cd where_in_the_law

# Install dependencies
flutter pub get

# Run development version
flutter run
Production Builds
bash
# Android APK
flutter build apk --release

# iOS Application
flutter build ios --release

# Web Deployment
flutter build web --release

# Windows Desktop
flutter build windows --release

# macOS Desktop  
flutter build macos --release

# Linux Desktop
flutter build linux --release
🔧 Technical Features
State Management
Built-in Flutter state management with setState

FutureBuilder for efficient async data loading

Service-based architecture for favorites persistence

Navigation System
Flutter Navigator with named routes

Modal routes for category selection

Efficient argument passing between screens

Search & Filtering Engine
Advanced real-time text search algorithm

Multi-category filtering system

Combined search predicates for precision

📊 Platform Support
✅ Android (Primary)

✅ iOS (Full Support)

✅ Web (Progressive Web App)

✅ Windows (Flutter Desktop)

✅ macOS (Flutter Desktop)

✅ Linux (Flutter Desktop)

🎓 Portfolio Project
🌐 This project is featured on my professional developer [portfolio](https://tetteh-apotey.vercel.app)

👨‍💻 Developer
Isaac Tetteh-Apotey

📧 Email: tettehapotey@gmail.com

📱 Phone: +233-559846747

🌐 Portfolio: life2allsofts.github.io

💼 LinkedIn: [Isaac Tetteh-Apotey](https://www.linkedin.com/in/isaac-tetteh-apotey-67408b89/)

Professional Background
Geomatics Engineer with 15+ years domain expertise

Quantic MSSE Candidate (Expected 2026)

Ghana Institution of Surveyors (GhIS) Member

Full-Stack Developer specializing in cross-platform solutions

🔧 Development Approach
AI Collaboration
This project was developed through AI-assisted programming, demonstrating how domain experts can leverage modern tools to build sophisticated software solutions that address real societal challenges.

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

🤝 Contributing
Fork the project repository

Create your feature branch (git checkout -b feature/AmazingFeature)

Commit your changes (git commit -m 'Add some AmazingFeature')

Push to the branch (git push origin feature/AmazingFeature)

Open a Pull Request for review

🙏 Acknowledgments
Ghana Legal System for the comprehensive law content

Flutter Team for the robust cross-platform framework

Material Design for the intuitive UI components

Noto Sans Font Family for clean, readable typography

Project represents meaningful technology for public service and access to justice - contributing to Ghana's digital transformation through legal tech innovation.
