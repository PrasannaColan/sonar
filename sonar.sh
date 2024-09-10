# Download dependencies
flutter pub get
# Run tests with User feedback (in case some test are failing)
flutter test
# Run tests without user feedback regeneration tests.output and coverage/lcov.info
flutter test --machine --coverage > tests.output

#node convert-lcov-to-jacoco.js

# Run the analysis and publish to the SonarQube server
/Users/cipl0950/Downloads/sonar-scanner-6.0.0.4432-macosx/bin/sonar-scanner