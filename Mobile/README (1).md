# Robot Framework Appium Integration

## Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Create a Virtual Environment**
   ```bash
   python3 -m venv env
   source env/bin/activate  # For Linux/Mac
   env\Scripts\activate     # For Windows
   ```

3. **Install Dependencies**
   ```bash
   pip install --upgrade -r requirements.txt
   ```

---

## [Mobile] Set Up iOS/Android Local or Real Devices

### 1. Install Appium
- **Install Node.js**  
  Download and install the suitable version of Node.js from [Node.js Downloads](https://nodejs.org/en/download/).  
  Ensure Node.js is installed in a location with full Read/Write permissions.

- **Install Appium**  
  Run the following commands in the terminal:
   ```bash
   npm install -g appium
   npm install -g appium@<version>  # Replace <version> with the desired version
   ```

- **Install Appium Drivers and Client Libraries**  
  - Install a driver (e.g., UiAutomator2) and its dependencies. Refer to the [Appium Drivers Documentation](https://appium.io/docs/en/2.0/ecosystem/#drivers).
  - Install an Appium client library for your preferred language (e.g., Python, JavaScript, Java).

---

### 2. Set Up the Device

#### For Android:
1. Enable **Developer Options**:
   - Go to `Settings > Developer Options` and enable:
     - **USB Debugging**: Debug mode when USB is connected.
     - **Install via USB**: Allow installing apps via USB.
     - **USB Debugging (Security Setting)**: Allow granting permissions and simulating input via USB debugging.

2. Connect your Android device to your computer via USB and confirm the trust prompt.

3. Install **Android SDK**:
   - Download [Android Studio](https://developer.android.com/studio) and manage SDK tools (e.g., platform-tools).
   - Set the environment variable `ANDROID_HOME` (or `ANDROID_SDK_ROOT`) to the SDK path.

4. Install **Java JDK**:
   - Download and install the [Java JDK](https://openjdk.java.net/install/).
   - Set the environment variable `JAVA_HOME` to the JDK installation path.

#### For Android Emulator:
Refer to the [Android Studio Emulator Configuration Guide](#).

#### For  iOS:
1. Install Xcode	 
2. Register your device for development with Xcode in Apple Developer. To learn about registering your device in Apple Developer, refer to this Apple document: Register a single device in Apple Developer.
3. In Xcode > Preferences > Account, click Add (+) to enter your Apple Developer Account ID and password.
4. Connect your iOS devices to your computer via a USB cable. Confirm to accept or trust the phone.
To enable UI Automation on the iOS device, navigate to Settings > Developer. In the UI Automation section, turn on Enable UI Automation.
  # If you want to execute mobile browser tests (Safari on iOS), you will need to enable the following settings in Settings > Safari > Advanced:
    JavaScript
    Web Inspector
      Remote Automation

## BrowserStack Integration with Robot Framework Appium (Python)

### 1. Upload Your App
Upload your Android (.apk/.aab) or iOS (.ipa) app to BrowserStack servers using the REST API:
```bash
curl -u "BROWSERSTACK_USERNAME:BROWSERSTACK_ACCESS_KEY" \
-X POST "https://api-cloud.browserstack.com/app-automate/upload" \
-F "file=@/path/to/apk/file"
```
The response will include a unique `app_url` to identify the uploaded app. Add this to your `.yml` config file under the `app` key.

---

### 2. Set BrowserStack Credentials
You can set your BrowserStack credentials as environment variables:
```bash
export BROWSERSTACK_USERNAME=<browserstack-username>
export BROWSERSTACK_ACCESS_KEY=<browserstack-access-key>
```

Alternatively, configure them directly in the `.yml` file.

---

## Running Tests

### Android

- **Run a Single Test**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/android/config/browserstack-single.yml"
   browserstack-sdk robot tests/android/SingleTestAndroid.robot
   ```

- **Run Tests on Multiple Devices in Parallel**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/android/config/browserstack-parallel-devices.yml"
   browserstack-sdk robot tests/android/SingleTestAndroid.robot
   ```

- **Run Local Tests**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/android/config/browserstack-local.yml"
   browserstack-sdk robot tests/android/LocalTestAndroid.robot
   ```

- **Run Test Suites in Parallel**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/android/config/browserstack-parallel.yml"
   browserstack-sdk robot tests/android/*.robot
   ```

- **Run Test Case Level Parallel Tests** (using [Pabot](https://pabot.org/)):
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/android/config/browserstack-parallel.yml"
   browserstack-sdk pabot --testlevelsplit ./tests/android/ParallelTestAndroid.robot
   ```

- **Run Test Cases and Suites Together in Parallel**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/android/config/browserstack-parallel.yml"
   browserstack-sdk pabot --testlevelsplit ./tests/android/*.robot
   ```

---

### iOS

- **Run a Single Test**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/ios/config/browserstack-single.yml"
   browserstack-sdk robot tests/ios/SingleTestiOS.robot
   ```

- **Run Tests on Multiple Devices in Parallel**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/ios/config/browserstack-parallel-devices.yml"
   browserstack-sdk robot tests/ios/SingleTestiOS.robot
   ```

- **Run Local Tests**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/ios/config/browserstack-local.yml"
   browserstack-sdk robot tests/ios/LocalTestiOS.robot
   ```

- **Run Test Suites in Parallel**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/ios/config/browserstack-parallel.yml"
   browserstack-sdk robot tests/ios/*.robot
   ```

- **Run Test Case Level Parallel Tests** (using [Pabot](https://pabot.org/)):
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/ios/config/browserstack-parallel.yml"
   browserstack-sdk pabot --testlevelsplit ./tests/ios/ParallelTestiOS.robot
   ```

- **Run Test Cases and Suites Together in Parallel**:
   ```bash
   export BROWSERSTACK_CONFIG_FILE="tests/ios/config/browserstack-parallel.yml"
   browserstack-sdk pabot --testlevelsplit ./tests/ios/*.robot
   ```

---

## Notes

- View test results on the [BrowserStack Automate Dashboard](https://www.browserstack.com/automate).
- Use the [SDK Config Generator](https://www.browserstack.com/docs/automate/selenium/sdk-config-generator) to configure `.yml` files.
- Estimate parallel sessions with the [Parallel Test Calculator](https://www.browserstack.com/automate/parallel-calculator?ref=github).

---

## Additional Resources

- [Writing Automate Test Scripts in Python](https://www.browserstack.com/automate/python)
- [Customizing Tests on BrowserStack](https://www.browserstack.com/automate/capabilities)
- [Supported Browsers & Devices](https://www.browserstack.com/list-of-browsers-and-platforms?product=automate)
- [Using REST API for Test Information](https://www.browserstack.com/automate/rest-api)