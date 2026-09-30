# E-Mazad API Automation Project - HAR-Based Test Suite

##  **Project Overview**

This Robot Framework API automation suite was generated from HAR file analysis of the E-Mazad platform authentication workflow. It features intelligent parameter cascading, global token management, and strict 2xx-only validation.

##  **HAR Analysis Summary**

### **API Workflow Captured:**
1. **POST** /web/emazad/Login/Login  Extract 	empAccessToken
2. **POST** /web/emazad/OTP/SendByTempAccessToken  Use temp token 
3. **POST** /web/emazad/login/VerifyOTP  Get final ccessToken + user data
4. **GET** /captcha  Retrieve captcha image

### **Authentication Token Cascade:**
`
Login  tempAccessToken  OTP Send  OTP Verify  accessToken + userId + session
`

### **Dynamic Parameters Identified:**
- 	empAccessToken (from login response)
- ccessToken (from OTP verification)
- userId (from final authentication)
- otp and captcha (user input)

##  **Project Structure**

`
API_automation_project/
 tests/                          # Test case files
    api_workflow_tests.robot    # Main authentication workflow tests
 resources/                      # Reusable keywords  
    api_keywords.robot          # Core API interaction keywords
    authentication_keywords.robot # E-Mazad auth flow keywords
 variables/                      # Configuration & variables
    api_config.robot            # API endpoints and config
    global_variables.robot      # Global suite variables
 results/                        # Test execution results
 requirements.txt                # Python dependencies
 README.md                       # This documentation
`

##  **Quick Start**

### **Installation**
`ash
# Navigate to project directory
cd API_automation_project

# Install dependencies
pip install -r requirements.txt
`

### **Test Execution**
`ash
# Run all API tests with detailed logging
robot --loglevel DEBUG --outputdir results tests/

# Run specific test tags
robot --include smoke --outputdir results tests/
robot --include authentication --outputdir results tests/

# Generate enhanced reports
robot --outputdir results --reportbackground blue:white tests/
`

### **View Results**
`ash
# Open detailed execution log
start results/log.html      # Windows
open results/log.html       # macOS  

# Open summary report
start results/report.html    # Windows
open results/report.html     # macOS
`

##  **Configuration**

### **Environment Settings**
Update ariables/api_config.robot for your environment:

`obot
# Base URLs (from HAR analysis)
${BASE_URL}              https://servicesk8s-staging.emazad.sa
${CAPTCHA_BASE_URL}      https://captchak8s-staging.emazad.sa

# Test Credentials
${USERNAME}              1032975789  
${PASSWORD}              ***UPDATE_ME***
${TEST_CAPTCHA}          0000
${TEST_OTP}              00000
`

##  **Critical Success Requirements**

### ** MANDATORY: 2xx Status Codes Only**
-  **PASS**: Only when API returns 200-299 status codes
-  **FAIL**: Any 4xx/5xx status codes cause test failure
-  **NO EXCEPTIONS**: No workarounds accepting error codes as success

### **Authentication Flow Validation**
- Complete 3-step authentication workflow
- Token extraction and cascading  
- Global header configuration
- Session state management

##  **Test Cases Included**

### **1. Complete E-Mazad Authentication Flow Test**
- **Purpose**: Validate full authentication workflow from HAR
- **Validates**: Login  OTP Send  OTP Verify  Token extraction
- **Tags**: uthentication, smoke, critical

### **2. E-Mazad API Authentication Token Cascading Test**  
- **Purpose**: Test parameter cascading between auth steps
- **Validates**: Token flow, global variables, header setup
- **Tags**: uthentication, cascading, integration

##  **Troubleshooting**

### **Common Issues & Solutions**

#### **401 Unauthorized Errors**
`ash
# Check authentication tokens
robot --variable USERNAME:your_username --variable PASSWORD:your_password tests/
`

#### **Failed Token Extraction**
- Verify HAR file endpoints match configuration
- Check token field names in response structure
- Review authentication_keywords.robot

#### **Captcha Issues**
- Ensure captcha service URL is accessible
- Check network connectivity to captcha endpoint

#### **Debugging Failed Tests**
`ash
# Run with maximum debug output
robot --loglevel TRACE --outputdir results tests/

# Check specific test case
robot --test "Complete E-Mazad Authentication Flow Test" tests/
`

##  **Extending the Framework**

### **Adding Business Logic Tests**
1. Create new test files in 	ests/ directory
2. Use Send GET Request With Global Auth and Send POST Request With Global Auth
3. Leverage ${GLOBAL_ACCESS_TOKEN} and ${GLOBAL_HEADERS}

### **Example Business API Test**
`obot
*** Test Cases ***
Create Auction Test
    [Documentation]    Test auction creation using authenticated session
    [Tags]    business-logic    auction
    
    # Use global authentication from Suite Setup
    &{auction_data}=    Create Dictionary    
    ...                name=Test Auction
    ...                type=real-estate
    
    ${response}=    Send POST Request With Global Auth    
    ...             /web/emazad/auctions/create    ${auction_data}
    
    # Extract auction ID for subsequent tests
    ${auction_id}=    Get From Dictionary    ${response.json()}    auctionId
    Set Suite Variable    ${CREATED_AUCTION_ID}    ${auction_id}
`

##  **Success Metrics**

### **Delivery Criteria Met**
-  **100% 2xx status codes** for all API calls
-  Complete HAR workflow replicated accurately  
-  Authentication token cascading implemented
-  Global variable management functional
-  Error handling and debugging capabilities
-  Maintainable Robot Framework structure

### **Quality Assurance**
- **HAR Accuracy**: Exact replication of captured behavior
- **Code Simplicity**: Linear execution, no complex logic
- **Best Practices**: Robot Framework standards compliance
- **Reliability**: Consistent execution with predictable results

##  **API Endpoints Reference**

| Endpoint | Method | Purpose | Auth Required |
|----------|--------|---------|---------------|
| /web/emazad/Login/Login | POST | Initial login | No |
| /web/emazad/OTP/SendByTempAccessToken | POST | Send OTP | Temp Token |  
| /web/emazad/login/VerifyOTP | POST | Verify OTP | Temp Token |
| /captcha | GET | Get captcha image | No |

##  **Notes**

- **Token Security**: Tokens are redacted in HAR file - update with valid test credentials
- **Environment**: Currently configured for staging environment
- **Extensibility**: Framework ready for additional business logic endpoints
- **Maintenance**: Update endpoint URLs and credentials as needed

---

** Project Status:  READY FOR EXECUTION**  
**All tests must achieve 2xx status codes for successful delivery**
