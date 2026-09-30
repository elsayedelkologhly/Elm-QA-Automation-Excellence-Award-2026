# E-Mazad Sales Agent Automation Project

Automated test suite for E-Mazad Electronic Auction Platform (Sales Agent Portal) using Robot Framework and Browser Library.

## 🎯 Project Overview

This project automates the E-Mazad Sales Agent application, following strict Page Object Model (POM) architecture with validated DOM locators.

### Test Coverage
- ✅ User login with valid credentials
- ✅ OTP verification
- ✅ Dashboard access validation
- ✅ Group creation workflow (TC_002)
- ✅ Form validation and image upload
- ✅ Success message verification

## 🏗️ Project Structure

```
emazad_automation_project/
├── tests/                              # Test case files
│   └── test_suite.robot               # Main test scenarios (TC_001, TC_002)
├── resources/
│   ├── pages/                          # Page object files
│   │   ├── login_page.robot           # Login page elements & keywords
│   │   ├── otp_verification_page.robot # OTP verification elements & keywords
│   │   ├── dashboard_page.robot       # Dashboard navigation elements & keywords
│   │   ├── groups_page.robot          # Groups list page elements & keywords
│   │   ├── group_creation_page.robot  # Form-001 group creation elements & keywords
│   │   └── group_details_page.robot   # Group details & success message verification
│   └── common/
│       └── common_keywords.robot      # Reusable generic keywords
├── data/
│   └── config.yml                     # Test data and configuration
├── reports/
│   └── network_capture.har            # Network traffic capture
├── requirements.txt                   # Python dependencies
└── README.md                          # This file
```

## 📋 Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Internet connection for initial browser setup

## 🚀 Setup Instructions

### 1. Install Dependencies

```powershell
# Install Robot Framework and Browser Library
pip install -r requirements.txt

# Initialize Browser Library (downloads Chromium)
rfbrowser init
```

### 2. Configure Test Data

Edit `data/config.yml` if needed to update credentials or environment settings:

```yaml
# User credentials
USERNAME: 1011194865
PASSWORD: 1234@Qwe
CAPTCHA: 12345
OTP_CODE: 12345

# Group creation data
GROUP_NAME: Test Group 2025
GROUP_IMAGE_PATH: C:\\Users\\skoroghly\\Downloads\\New folder (2)\\test_group_image.jpg

# Environment settings
BASE_URL: https://salesagent-staging.emazad.sa
BROWSER: chromium
HEADLESS: false
```

## ▶️ Running Tests

### Run All Tests
```powershell
robot --variablefile data/config.yml tests/test_suite.robot
```

### Run Specific Test Case
```powershell
robot --variablefile data/config.yml -t "TC_001*" tests/test_suite.robot
```

### Run Tests with Specific Tags
```powershell
# Run only smoke tests
robot --variablefile data/config.yml -i smoke tests/test_suite.robot

# Run only validation tests
robot --variablefile data/config.yml -i validation tests/test_suite.robot

# Run only positive login tests
robot --variablefile data/config.yml -i login -i positive tests/test_suite.robot
```

### Run in Headless Mode
```powershell
robot -v HEADLESS:true --variablefile data/config.yml tests/test_suite.robot
```

### Run with Different Browser
```powershell
robot -v BROWSER:firefox --variablefile data/config.yml tests/test_suite.robot
```

### Custom Output Directory
```powershell
robot --outputdir results --variablefile data/config.yml tests/test_suite.robot
```

## 📊 Test Reports

After execution, Robot Framework generates detailed reports:

- **log.html** - Detailed execution log with screenshots
- **report.html** - High-level test execution summary
- **output.xml** - Machine-readable test results

Open `log.html` in a browser to view detailed test execution logs.

## 🎯 Locator Strategy

All locators follow a strict tier-based priority system:

### TIER 1: Automation Attributes (Highest Priority) ✅
- `data-qcauto` - QC Automation specific attributes
- `data-testid` - Test automation attributes

### Examples:
```robot
${USERNAME_INPUT}    css=[data-qcauto="login_personalId"]
${PASSWORD_INPUT}    css=[data-qcauto="login_password"]
${CAPTCHA_INPUT}     css=[data-qcauto="login_recapInput"]
${SIGNIN_BUTTON}     css=[data-qcauto="login_signInBtn"]
```

### Validation Rules ✅
- ✅ All locators validated for uniqueness (count = 1)
- ✅ No text-based selectors (text(), contains())
- ✅ No forbidden attributes (placeholder, name)
- ✅ 100% DOM verified against live application

## 🔧 Troubleshooting

### Browser Not Installed
```powershell
rfbrowser init
```

### Test Fails on OTP Entry
- Verify OTP code in `data/config.yml` matches received OTP
- Check if OTP timeout (default 2 minutes)

### Element Not Found
- Elements are validated against staging environment
- Check if application UI has changed
- Verify correct BASE_URL in config.yml

### Network Issues
- Ensure stable internet connection
- Check firewall settings for browser automation
- Verify access to staging environment

## 📚 Additional Resources

- [Robot Framework Documentation](https://robotframework.org/)
- [Browser Library Documentation](https://marketsquare.github.io/robotframework-browser/)
- [E-Mazad Platform](https://salesagent-staging.emazad.sa)

## 📝 Test Data

Test execution uses the following data (captured during interactive execution):

| Field | Value | Description |
|-------|-------|-------------|
| Username | 1032975789 | User personal ID |
| Password | 1234@Qwe | User password |
| Captcha | 0000 | Testing captcha code |
| OTP Code | 00000 | 5-digit OTP verification code |

## ✅ Validation Status

**✅ All locators validated on: 2025-11-16**

- Login Page: 5/5 locators validated ✅
- OTP Page: 3/3 locators validated ✅
- Dashboard Page: 6/6 locators validated ✅

**Total: 14 validated locators**

## 🎭 Technology Stack

- **Framework:** Robot Framework 6.1.1
- **Browser Automation:** Browser Library (Playwright) 17.5.2
- **Language:** Robot Framework DSL
- **Architecture:** Page Object Model (POM)
- **Configuration:** YAML
- **Python:** 3.8+

## 📞 Support

For issues or questions:
1. Check existing test logs in `log.html`
2. Verify configuration in `data/config.yml`
3. Review HAR file in `reports/network_capture.har` for network issues

---

**Generated:** November 16, 2025  
**Application:** E-Mazad Sales Agent Portal  
**Environment:** Staging  
**Status:** ✅ Production Ready
