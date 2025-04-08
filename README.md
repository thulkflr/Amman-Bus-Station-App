# Amman-Bus-Station-App

This project is a mobile application developed using *Flutter* that helps users find bus stations, view available bus schedules, and track bus locations in real-time. The app is designed to make public transportation easier and more accessible for users.

## 🚍 Features
- *Find Nearby Bus Stations*: Use GPS to find bus stations near your current location.
- *View Bus Schedules*: See available bus schedules for different routes.
- *Real-Time Bus Tracking*: Track the location of buses in real time.
- *Route Information*: Get detailed information about each bus route.
- *Notifications*: Receive alerts for bus arrivals and schedule changes by SMS message.

## ⚙ Technologies Used
- *Flutter*: Cross-platform mobile development framework.
- *Dart*: Programming language used with Flutter.
- *Twilio Integration*: To enable SMS notifications for bus arrivals and schedule changes
- *Firebase*: Used for real-time database management, notifications, and authentication.

## 📱 How to Run the App Locally

1. Clone this repository:
    bash
    git clone https://github.com/your-username/bus-station-app.git
    

2. Install the required dependencies:
    bash
    flutter pub get
    

3. Run the app:
    bash
    flutter run
    

## 🧑‍💻 Developer Setup

1. Install *Flutter* by following the installation guide on [Flutter's official website](https://flutter.dev/docs/get-started/install).
2. Set up an *IDE* (like *VSCode* or *Android Studio*) with Flutter support.
3. Ensure that you have a physical or virtual Android/iOS device to run the app.

## 💡 Future Improvements
- *User Accounts*: Allow users to create accounts to save their favorite bus routes and stations.
- *Route Optimization*: Add functionality for route suggestions based on user preferences and real-time traffic data.
- *Voice Search*: Integrate voice search functionality for easier station and route search.

## 🔐 Twilio Integration (SMS Notifications)

To enable SMS notifications for bus arrivals and schedule changes, the app integrates with [Twilio](https://www.twilio.com/).

### 📝 Setup Instructions

1. Create an account at [Twilio Sign Up](https://www.twilio.com/try-twilio).
2. Once registered, get the following credentials from the [Twilio Console](https://console.twilio.com/):
   - **Account SID**
   - **Auth Token**
   - **Twilio Phone Number**

3. In the project directory, create a file named `.env` or use a secure configuration method depending on your app's architecture.

4. Add the following variables:

    ```env
    TWILIO_ACCOUNT_SID=your_account_sid
    TWILIO_AUTH_TOKEN=your_auth_token
    TWILIO_PHONE_NUMBER=+1234567890
    ```

5. Make sure to **never commit your secrets**. Add `.env` to your `.gitignore` file to avoid pushing it to GitHub.

### 📦 Flutter Environment Package

You can use the [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv) package to load environment variables:

```yaml
dependencies:
  flutter_dotenv: ^5.0.2
```
## 📄 Presentation
You can view or download the PDF presentation for this project here: 
[Project Presentation]([Amman Station App Presintation.pdf](https://github.com/user-attachments/files/19649557/Amman.Station.App.Presintation.pdf)
)

## 💬 Contributing
Contributions are welcome! Please feel free to fork this project, submit issues, or create pull requests.

1. Fork the repository
2. Create a new branch
3. Make your changes and commit them
4. Push your changes to your fork
5. Open a pull request

## 📧 Contact
For any questions or suggestions, feel free to contact me at [thualkflrbabah@gmail.com].

---

> *Note*: "The goal of this app is to make bus travel easier and more efficient for users."
