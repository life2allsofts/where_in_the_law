I'll update your README.md to include the comprehensive quiz section. Here's the enhanced version with the quiz features prominently featured:

```markdown
# Where in the Law? 🇬🇭

A Flutter mobile application that helps Ghanaian citizens understand legal rights and obligations by providing easy access to Ghanaian laws with plain English explanations and interactive legal quizzes.

![Flutter](https://img.shields.io/badge/Flutter-3.19-blue)
![Dart](https://img.shields.io/badge/Dart-3.3-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 📱 App Overview

"Where in the Law?" transforms complex legal jargon into understandable language and tests legal knowledge through interactive quizzes. Making Ghana's legal system more accessible and educational for everyone - from students to professionals.

## 🚀 Key Features

### 🎮 **Interactive Legal Quizzes (NEW!)**
- **Multiple Difficulty Levels**: Beginner, Intermediate, and Expert modes
- **Professional Categories**: Specialized quizzes for Surveying, Health, Law, Engineering, and more
- **Daily Challenges**: Fresh questions every day with bonus rewards
- **Progress Tracking**: Score tracking, experience points, and achievement badges

#### **Quiz Game Modes:**
- **📚 Beginner Mode**: Basic legal concepts and fundamental rights
- **⚖️ Intermediate Mode**: Practical legal scenarios and workplace regulations  
- **🎓 Expert Mode**: Complex legal principles and professional practice
- **📅 Daily Challenge**: Mixed-difficulty questions that change daily
- **👷 Professional Quizzes**: Category-specific tests for students and professionals

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

### 👷 **Professional Quiz Categories (NEW!)**
- **📐 Surveying Rules & Regulations**: Survey Act, boundary disputes, cadastral surveys
- **🏥 Health & Medical**: Medical ethics, patient rights, NHIS regulations
- **⚖️ Legal Profession**: Lawyer ethics, court procedures, professional conduct
- **🔧 Engineering**: Engineering standards, safety regulations, professional practice
- **📊 Accounting**: Auditing standards, tax compliance, professional ethics
- **🏫 Education**: Teaching regulations, student rights, curriculum standards
- **🏠 Real Estate**: Property sales, agency regulations, tenant rights

### 💡 Law Comprehension Tools
- **Dual Text Display**: Original legal text alongside plain English explanations
- **Proper Citations**: Complete law names, codes, and section references
- **Category Color Coding**: Visual theme system for easy category recognition
- **Professional Layout**: Card-based design with gold borders and consistent spacing

### ⭐ User Experience Features
- **Gamification System**: Earn Cedi Coins, level up, and unlock achievements
- **Favorites System**: Persistent storage for frequently referenced laws
- **Offline Capability**: Access laws without internet connection
- **Beautiful UI**: Ghana-themed design with professional aesthetics
- **Responsive Design**: Optimized for mobile, tablet, and desktop

## 🎮 **Quiz System Deep Dive**

### **Question Database**
- **400+ Curated Questions**: Generated from 320+ Ghanaian laws
- **Automatic Question Generation**: Questions created from `law_data.json`
- **Quality Filtering**: Only high-quality, relevant questions included
- **Professional Relevance**: Questions aligned with real exam patterns

### **Difficulty Levels**
| Level | Questions | Target Audience | Points |
|-------|-----------|----------------|--------|
| **Beginner** | 180+ | General public, students | 5 points |
| **Intermediate** | 108+ | Employees, business owners | 10 points |
| **Expert** | 121+ | Legal professionals, experts | 15 points |

### **Game Mechanics**
- **⏱️ Timed Questions**: 30 seconds per question with countdown timer
- **💡 Hint System**: Use Cedi Coins for hints during quizzes
- **🏆 Scoring System**: Bonus points for quick answers
- **📈 Experience Points**: Level up system with increasing difficulty
- **💰 Cedi Coins**: Earn virtual currency for correct answers

### **Professional Exam Preparation**
- **Survey Rules & Regulations**: Ideal for surveying students (KNUST, UCC, UDS)
- **NHIS Compliance**: Healthcare professional certification practice
- **Legal Ethics**: Lawyer professional development and CPD
- **Engineering Standards**: Professional engineering exam preparation

## 🛠️ Technical Implementation

### 🏗️ Project Architecture
```
where_in_the_law/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── data/
│   │   ├── law_data.dart            # Law data management
│   │   ├── game_questions.dart      # Quiz question management
│   │   ├── game_question_loader.dart # Question loading system
│   │   └── law_question_generator.dart # Automatic question generation
│   ├── models/
│   │   ├── law_model.dart           # Law data model
│   │   ├── game_question.dart       # Quiz question model
│   │   └── professional_category.dart # Professional categories model
│   ├── widgets/
│   │   ├── law_card.dart            # Reusable law card widget
│   │   └── filter_dialog.dart       # Category filter dialog
│   ├── screens/
│   │   ├── home_screen.dart         # Main screen with all laws
│   │   ├── categories_screen.dart   # Category browsing
│   │   ├── law_detail_screen.dart   # Detailed law view
│   │   ├── search_screen.dart       # Advanced search functionality
│   │   ├── favorites_screen.dart    # Saved laws management
│   │   ├── quiz_screen.dart         # Main quiz interface
│   │   ├── quiz_result_screen.dart  # Quiz results and statistics
│   │   └── professional_quiz_screen.dart # Professional category quizzes
│   └── services/
│       ├── favorites_service.dart   # Favorites management
│       ├── game_service.dart        # Game progress and user profiles
│       └── ad_service.dart          # Ad monetization integration
├── assets/
│   ├── fonts/
│   │   └── NotoSans-Regular.ttf     # Custom typography
│   ├── icon/
│   │   └── icon.png                 # App branding
│   ├── law_data.json                # Comprehensive law database (320+ laws)
│   └── game_questions.json          # Curated quiz questions
```

### 💾 Data Models
```dart
// Law Model
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

// Quiz Question Model
class GameQuestion {
  final String id;
  final String question;
  final List<QuestionOption> options;
  final String explanation;
  final String lawReference;
  final String category;
  final String difficulty; // beginner, intermediate, expert
  final int points;
}

// Professional Category Model
class ProfessionalCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final List<String> keyActs;
  final List<String> targetAudience;
  final int questionCount;
}
```

### 🎨 Design System
- **Color Scheme**:
  - Primary Blue: `#3498DB`
  - Secondary Purple: `#8E44AD`
  - Accent Gold: `#D4AF37`
  - Background Gradient: `#F5F7FA` to `#C3CFE2`
  - Quiz Colors: Green (correct), Red (incorrect), Orange (timer)
- **Typography**: NotoSans-Regular for optimal readability
- **Icons**: Material Icons with category-specific assignments
- **Layout Principles**: Consistent spacing, card-based design, intuitive navigation

## 📱 Key Screens & Functionality

### **Quiz Screen (quiz_screen.dart)**
- Interactive quiz interface with timer and progress tracking
- Color-coded answer feedback (green for correct, red for incorrect)
- Hint system using Cedi Coins
- Detailed explanations after each answer
- Smooth animations and transitions

### **Quiz Results Screen (quiz_result_screen.dart)**
- Comprehensive score breakdown
- Experience points and level progression
- Cedi Coins earned
- Category performance analytics
- Share results functionality

### **Professional Quiz Screen (professional_quiz_screen.dart)**
- Specialized interface for professional categories
- Key legislation display for each profession
- Difficulty selection (Beginner, Professional, Exam Simulation)
- Target audience information

### **Home Screen (home_screen.dart)**
- Comprehensive law overview with toggle between "All Laws" and "Categories"
- Quick access to search, favorites, and quiz modes
- Dynamic category filtering with visual indicators
- Professional gradient background with Ghana-themed aesthetics

### **Categories Screen (categories_screen.dart)**
- Grid layout of 13+ legal categories with representative icons
- Real-time law count per category
- Visual color coding system for easy recognition
- Smooth category-based navigation

### **Law Detail Screen (law_detail_screen.dart)**
- Complete legal text display with proper formatting
- Side-by-side plain English explanations
- Category-based color theming
- Professional card layout with distinctive gold borders

### **Search Screen (search_screen.dart)**
- Real-time search across multiple data fields
- Advanced multi-category filtering
- Combined search predicates for precise results
- Clean, intuitive search interface

### **Favorites Screen (favorites_screen.dart)**
- Persistent favorites storage managed by FavoritesService
- Quick access to frequently referenced laws
- Seamless integration with main navigation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.19 or higher)
- Dart (3.3 or higher)
- Android Studio/VSCode with Flutter extension

### Installation & Development
```bash
# Clone repository
git clone https://github.com/life2allsofts/where_in_the_law.git

# Navigate to project
cd where_in_the_law

# Install dependencies
flutter pub get

# Run development version
flutter run
```

### Production Builds
```bash
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
```

## 🔧 Technical Features

### **State Management**
- Built-in Flutter state management with `setState`
- `FutureBuilder` for efficient async data loading
- Service-based architecture for favorites and game progress persistence

### **Navigation System**
- Flutter Navigator with named routes
- Modal routes for category selection
- Efficient argument passing between screens
- Smooth quiz question transitions

### **Search & Filtering Engine**
- Advanced real-time text search algorithm
- Multi-category filtering system
- Combined search predicates for precision

### **Quiz System Architecture**
- Async question loading with caching
- Difficulty-based question distribution
- Random question selection with seed-based daily challenges
- Fallback question generation system

### **Game Progress System**
- User profile persistence
- Level progression algorithm
- Virtual currency (Cedi Coins) management
- Achievement tracking

## 📊 Platform Support
- ✅ **Android** (Primary)
- ✅ **iOS** (Full Support)
- ✅ **Web** (Progressive Web App)
- ✅ **Windows** (Flutter Desktop)
- ✅ **macOS** (Flutter Desktop)
- ✅ **Linux** (Flutter Desktop)

## 🎓 **Educational Value**

### **For General Public**
- Learn basic legal rights and responsibilities
- Understand common legal situations
- Prepare for interactions with legal systems

### **For Students**
- Surveying students: Prepare for "Survey Rules and Regulations" course exams
- Law students: Practice legal principles and ethics
- Medical students: Learn healthcare regulations and patient rights
- Engineering students: Study professional standards and safety regulations

### **For Professionals**
- Continuing Professional Development (CPD)
- Certification exam preparation
- Stay updated on regulatory changes
- Professional ethics reinforcement

## 👨‍💻 Developer

**Isaac Tetteh-Apotey**

- 📧 Email: tettehapotey@gmail.com
- 📱 Phone: +233-559846747
- 🌐 Portfolio: [life2allsofts.github.io](https://life2allsofts.github.io)
- 💼 LinkedIn: [Isaac Tetteh-Apotey](https://www.linkedin.com/in/isaac-tetteh-apotey-67408b89/)

### Professional Background
- Geomatics Engineer with 15+ years domain expertise
- Quantic MSSE Candidate (Expected 2026)
- Ghana Institution of Surveyors (GhIS) Member
- Full-Stack Developer specializing in cross-platform solutions

## 🔧 Development Approach

### **AI Collaboration**
This project was developed through AI-assisted programming, demonstrating how domain experts can leverage modern tools to build sophisticated software solutions that address real societal challenges.

### **Domain Expertise Integration**
- Real Ghanaian laws and regulations
- Professional surveying knowledge integration
- Educational curriculum alignment
- Practical legal scenario coverage

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing
1. Fork the project repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request for review

## 🙏 Acknowledgments
- **Ghana Legal System** for the comprehensive law content
- **Flutter Team** for the robust cross-platform framework
- **Material Design** for the intuitive UI components
- **Noto Sans Font Family** for clean, readable typography
- **Ghana Institution of Surveyors (GhIS)** for professional standards inspiration

---

## 🎯 **Project Vision**

"Where in the Law?" represents meaningful technology for public service and access to justice - contributing to Ghana's digital transformation through legal tech innovation. By combining comprehensive legal information with interactive educational quizzes, the app serves multiple audiences:

1. **🇬🇭 General Ghanaian Public**: Understand legal rights and obligations
2. **🎓 Students**: Prepare for professional exams and courses
3. **👷 Professionals**: Continuing education and certification preparation
4. **⚖️ Legal Community**: Quick reference and educational tool

The app bridges the gap between complex legal systems and everyday citizens, making the law accessible, understandable, and engaging for all Ghanaians.
```