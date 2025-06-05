# ZenithX Project Documentation

**Project Name:** ZenithX – Stock Market Analysis & Education App  
**Prepared By:** Team ZenithX  
**Date:** 16 October 2024  
**Version:** 1.0

---

## 1. Introduction

ZenithX is a stock market analysis and education platform designed to provide users with real-time market data, technical and fundamental analysis tools, and educational resources. This document details the system architecture, functionality, and implementation of ZenithX.

---

## 2. System Overview

ZenithX is developed using Flutter and Firebase, integrating stock market APIs and NewsAPI to provide relevant financial insights.

**Key Components:**  
- Frontend: Flutter (Dart)  
- Backend: Firebase (Authentication, Firestore, Storage)  
- APIs Used: Stock Market Data APIs, NewsAPI  
- Security Measures: Firebase rules for data access

---

## 3. System Architecture

### 3.1 High-Level Architecture

- User Interface (UI): Flutter-based mobile app  
- Authentication Layer: Firebase Authentication (Email & Google Sign-In)  
- Database Layer: Firestore for storing user data and stock insights  
- APIs Integration: Fetching stock data and news from external sources  

### 3.2 Data Flow

1. User logs in via Firebase Authentication.  
2. App fetches real-time stock data from API.  
3. User searches for a stock and views analysis.  
4. App stores user preferences in Firestore.

---

## 4. Features & Functionalities

### 4.1 Core Features

- Stock Market News: Displays latest news from NSE, BSE, and NYSE.  
- Technical Analysis: Moving averages, MACD indicators.  
- Fundamental Analysis: Company assets, revenue, and financial ratios.  
- Investment Guide: Stock market basics and strategy tutorials.

### 4.2 Advanced Features (Future Enhancements)

- AI-based stock predictions and alerts.  
- Personalized investment recommendations.  
- Community forum for discussions.

---

## 5. Database Design

### 5.1 Firestore Collections & Documents

- **Users Collection**  
  - userId: Unique identifier  
  - email: User email  
  - watchlist: List of tracked stocks  

- **Stock Data Collection**  
  - stockId: Unique stock identifier  
  - companyName: Name of the company  
  - priceData: Historical stock prices  

- **News Collection**  
  - articleId: Unique article identifier  
  - headline: News headline  
  - source: News provider  
  - date: Date of publication

---

## 6. Deployment Guide

### 6.1 Prerequisites

- Flutter SDK installed  
- Firebase project setup with `google-services.json`  
- API keys for stock data and news

### 6.2 Steps to Deploy

1. Clone the ZenithX repository.  
2. Add `google-services.json` to the `android/app` directory.  
3. Configure API keys in `.env` file.  
4. Run `flutter pub get` to install dependencies.  
5. Build and run using `flutter run`.  
6. Generate APK using `flutter build apk`.  
7. Publish to Google Play Store following Google’s guidelines.

---

## 7. Security & Compliance

- Firebase Authentication with Google & Email Sign-in.  
- Firestore security rules ensuring data privacy.  
- OTP-based document access for enhanced security.  
- Compliance with Play Store policies and privacy regulations.

---

## 8. Testing & Debugging

### 8.1 Testing Approach

- Unit Testing: Widget and API response testing.  
- Integration Testing: Authentication, stock search, news retrieval.  
- User Testing: Feedback-driven improvements.  
- Security Testing: Validation of access controls and encryption.

### 8.2 Common Bugs & Fixes

| Issue                     | Possible Cause          | Fix                             |
|---------------------------|------------------------|--------------------------------|
| App crashes on login      | Firebase config missing| Check `google-services.json`    |
| News not loading          | API key incorrect      | Verify API key settings         |
| OTP verification fails    | Firestore rule mismatch| Adjust Firestore security rules |

---

## 9. Conclusion

ZenithX is a comprehensive stock market analysis and education tool designed to empower investors. With a secure and scalable architecture, real-time market insights, and educational resources, it serves as a valuable asset for both beginners and professionals. Continuous enhancements will further optimize its functionality and user experience.

---

**Prepared By:** Team ZenithX  
**Contact:** zenithx996@gmail.com
