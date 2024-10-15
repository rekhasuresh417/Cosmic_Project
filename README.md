## Health Data Tracker

A SwiftUI application that fetches and displays health data from Apple's HealthKit, including step counts and heart rates, with animated UI components.

## Features
-	Fetch and display total step counts.
-	Visualize heart rate data with a line chart.
-	Animated updates for a smooth user experience.
-	Loading indicators while fetching data.

 ## Requirements
-	iOS 14.0 or later
-	Xcode 12.0 or later
-	HealthKit enabled on the device

 ## Setup
-	Clone the Repository
bash
Copy code
git clone https://github.com/yourusername/HealthDataTracker.git
cd HealthDataTracker
Open the Project in Xcode

Open HealthDataTracker.xcodeproj in Xcode.

## Enable HealthKit Capability
Go to the "Signing & Capabilities" tab of your target.
Add the "HealthKit" capability.
Request Authorization

Ensure that the app requests authorization to access HealthKit data when it launches. This is handled in the HealthKitManager class.

## Run the App
Connect a physical device (Or we can use simulator).
Build and run the app in Xcode.

## Usage
Upon launching the app, you will be prompted to authorize access to your HealthKit data.
The app will display:
Total steps taken in the past week in a card format.
A line chart showing the heart rate data for the past week.
Animations will enhance the experience when data is updated or fetched.

Code Overview
HealthKitManager
Manages HealthKit data fetching.
Requests authorization and fetches step count and heart rate data.

ContentView
Displays the total steps in a card.
Shows a line chart for heart rate data.
Includes animations for data updates.
LineChartView
A SwiftUI view that visualizes heart rate data using a line chart.

Customization
Modify the HealthKitManager to add more health metrics.
Customize the UI components and animations in ContentView and LineChartView.

## Contributing
Feel free to submit issues or pull requests. Contributions are welcome!

## License
This project is licensed under the MIT License. See the LICENSE file for more information.
