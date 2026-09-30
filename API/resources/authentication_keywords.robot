*** Settings ***
Documentation    Authentication and token management keywords based on HAR analysis
Library          RequestsLibrary
Library          Collections

*** Keywords ***
Extract And Store Global Authentication
    [Documentation]     CRITICAL: Complete E-Mazad authentication flow with 2xx validation
    Log    Starting E-Mazad authentication flow based on HAR analysis
    
    # Step 1: Initial login to get temp access token
    ${temp_token}=    Perform Initial Login
    
    # Step 2: Send OTP using temp token  
    Send OTP Using Temp Token    ${temp_token}
    
    # Step 3: Verify OTP to get final access token
    Verify OTP And Extract Final Token    ${temp_token}
    
    # Step 4: Setup global headers for all subsequent requests
    Setup Global Headers For API Calls
    
    Log     E-Mazad authentication flow completed successfully

Perform Initial Login
    [Documentation]    🚨 MANDATORY: Execute initial login and extract temp token - ONLY 2xx
    Log    Executing initial login to get temporary access token
    
    # Prepare captcha data structure based on HAR analysis
    &{captcha_data}=    Create Dictionary    
    ...                isInternalLoging=${False}
    ...                captcha=${TEST_CAPTCHA}
    ...                captchaToken=test-token-123
    
    # Prepare login payload based on HAR data structure
    &{login_payload}=    Create Dictionary    
    ...                  ${USERNAME_FIELD}=${USERNAME}
    ...                  ${PASSWORD_FIELD}=${PASSWORD}
    ...                  returnUrl=${None}
    ...                  captchaData=${captcha_data}
    
    # Execute login API call
    ${login_response}=    POST On Session    main_session    ${LOGIN_ENDPOINT}    
    ...                   json=${login_payload}    headers=${DEFAULT_HEADERS}    expected_status=200
    
    # 🔥 CRITICAL: Validate 2xx status code - NO EXCEPTIONS
    Should Be Equal As Numbers    ${login_response.status_code}    200
    Should Not Be Empty    ${login_response.json()}
    
    # Extract temp access token from response (based on HAR structure: result.tempAccessToken)
    ${temp_token}=    Get From Dictionary    ${login_response.json()}[result]    ${TEMP_TOKEN_FIELD}
    Set Suite Variable    ${GLOBAL_TEMP_ACCESS_TOKEN}    ${temp_token}
    
    # Validate token extraction
    Should Not Be Empty    ${temp_token}
    Log    ✅ Temporary access token extracted successfully: ${temp_token[:20]}...
    
    [Return]    ${temp_token}

Send OTP Using Temp Token
    [Arguments]    ${temp_token}
    [Documentation]    🚨 MANDATORY: Send OTP using temp token - ONLY 2xx status codes
    Log    Sending OTP using temporary access token
    
    # Prepare OTP send payload (based on HAR: tempAccessToken, emailAddress, phoneNumber)
    &{otp_payload}=    Create Dictionary    
    ...               tempAccessToken=${temp_token}
    ...               emailAddress=${None}
    ...               phoneNumber=${None}
    
    # Execute OTP send API call (no Authorization header needed for this endpoint)
    ${otp_response}=    POST On Session    main_session    ${OTP_SEND_ENDPOINT}    
    ...                 json=${otp_payload}    headers=${DEFAULT_HEADERS}    expected_status=200
    
    # 🔥 CRITICAL: Validate 2xx status code - NO EXCEPTIONS
    Should Be Equal As Numbers    ${otp_response.status_code}    200
    Should Not Be Empty    ${otp_response.json()}
    
    # Validate OTP send success
    ${success}=    Get From Dictionary    ${otp_response.json()}    success
    Should Be True    ${success}
    Log    ✅ OTP sent successfully

Verify OTP And Extract Final Token
    [Arguments]    ${temp_token}
    [Documentation]    🚨 MANDATORY: Verify OTP and extract final access token - ONLY 2xx
    Log    Verifying OTP to get final access token
    
    # Prepare OTP verification payload (based on HAR: otpCode, userNameOrEmailAddress, password)
    &{verify_payload}=    Create Dictionary    
    ...                  otpCode=${TEST_OTP}
    ...                  ${USERNAME_FIELD}=${USERNAME}
    ...                  ${PASSWORD_FIELD}=${PASSWORD}
    
    # Execute OTP verification API call (no Authorization header needed)
    ${verify_response}=    POST On Session    main_session    ${OTP_VERIFY_ENDPOINT}    
    ...                    json=${verify_payload}    headers=${DEFAULT_HEADERS}    expected_status=200
    
    # 🔥 CRITICAL: Validate 2xx status code - NO EXCEPTIONS
    Should Be Equal As Numbers    ${verify_response.status_code}    200
    Should Not Be Empty    ${verify_response.json()}
    
    # Extract final access token (based on HAR response structure: result.accessToken)
    ${access_token}=    Get From Dictionary    ${verify_response.json()}[result]    ${ACCESS_TOKEN_FIELD}
    Set Suite Variable    ${GLOBAL_ACCESS_TOKEN}    ${access_token}
    
    # Extract user info (based on HAR response structure: result.userInfo)
    ${user_info}=    Get From Dictionary    ${verify_response.json()}[result]    userInfo
    ${user_id}=      Get From Dictionary    ${user_info}    nationalId
    Set Suite Variable    ${GLOBAL_USER_ID}    ${user_id}
    
    # Extract session cookie if present (optional)
    ${response_headers}=    Set Variable    ${verify_response.headers}
    ${has_cookie}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${response_headers}    Set-Cookie
    Run Keyword If    ${has_cookie}
    ...              Set Suite Variable    ${GLOBAL_SESSION_COOKIE}    ${response_headers}[Set-Cookie]
    ...    ELSE
    ...              Set Suite Variable    ${GLOBAL_SESSION_COOKIE}    ${EMPTY}
    
    Log    ✅ Final access token and user data extracted successfully
    Log    User ID: ${user_id}
    Log    Access Token: ${access_token[:20]}...

Setup Global Headers For API Calls
    [Documentation]    Setup global headers dictionary for all subsequent API calls
    Log    Setting up global headers with final access token
    
    # Create global headers based on successful authentication
    &{global_headers}=    Create Dictionary    
    ...                  Content-Type=application/json
    ...                  Accept=application/json
    ...                  Authorization=Bearer ${GLOBAL_ACCESS_TOKEN}
    Set Suite Variable    ${GLOBAL_HEADERS}    ${global_headers}
    
    Log     Global headers configured for authenticated API calls

Validate ONLY 2xx Status Code - NO EXCEPTIONS
    [Arguments]    ${response}    ${expected_status}=200
    [Documentation]     CRITICAL: Validate ONLY 2xx status codes - FAIL all others
    
    #  IRONCLAD STATUS CODE VALIDATION
    Should Be Equal As Numbers    ${response.status_code}    ${expected_status}
    Should Be True    ${response.status_code} >= 200    FAILURE: Status code ${response.status_code} is not 2xx
    Should Be True    ${response.status_code} <= 299    FAILURE: Status code ${response.status_code} is not 2xx
    
    #  EXPLICIT REJECTION OF ERROR CODES
    Should Not Be True    ${response.status_code} >= 400    CRITICAL FAILURE: 4xx/5xx status code ${response.status_code} detected - TEST MUST FAIL
    
    Log     SUCCESS: API returned valid 2xx status code: ${response.status_code}
