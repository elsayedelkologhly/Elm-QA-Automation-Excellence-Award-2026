*** Settings ***
Documentation    E-Mazad Sales Agent - Test Suite
...              Automated tests for login and group creation functionality
Library          Browser
Variables        ../data/config.yml
Resource         ../resources/common/common_keywords.robot
Resource         ../resources/pages/login_page.robot
Resource         ../resources/pages/otp_verification_page.robot
Resource         ../resources/pages/dashboard_page.robot
Resource         ../resources/pages/groups_page.robot
Resource         ../resources/pages/group_creation_page.robot
Resource         ../resources/pages/group_details_page.robot

Suite Setup      Setup Test Suite
Test Setup       Setup Test Case

*** Test Cases ***
TC_001_Login_With_Valid_Credentials
    [Documentation]    Test successful login flow with valid credentials
    ...                Steps:
    ...                1. Navigate to login page
    ...                2. Fill username, password, and captcha
    ...                3. Click Sign In button
    ...                4. Enter OTP code
    ...                5. Verify successful login to dashboard
    [Tags]    smoke    login    positive
    
    # Step 1: Navigate to login page
    Open Login Page
    # Step 2: Fill login form
    Enter Username    ${USERNAME}
    Enter Password    ${PASSWORD}
    Enter Captcha    ${CAPTCHA}
    
    # Step 3: Submit login form
    Click Sign In Button
    
    # Step 4: Complete OTP verification
    Complete OTP Verification    ${OTP_CODE}
    
    # Step 5: Verify successful login
    Verify Dashboard Loaded
    Verify Login Success Message

TC_002_Create_New_Group_By_Agent
    [Documentation]    Test Case 2: Create New Group by Agent
    ...                URL: https://salesagent-staging.emazad.sa/groups
    ...                Steps:
    ...                1. Navigate to login page and login
    ...                2. Navigate to Groups page via menu
    ...                3. Click "إنشاء مجموعة جديدة" button
    ...                4. Fill group basic information (Form-001)
    ...                5. Upload group image
    ...                6. Click "Create Group" button
    ...                7. Verify success message (Message-001)
    [Tags]    smoke    groups    create_group    positive
    
    # Step 1: Login
    Open Login Page
    Enter Username    ${USERNAME}
    Enter Password    ${PASSWORD}
    Enter Captcha    ${CAPTCHA}
    Click Sign In Button
    Wait For OTP Page
    Enter OTP Code    ${OTP_CODE}
    Click Submit OTP
    Verify Dashboard Loaded
    
    # Step 2: Navigate to Groups page
    Navigate To Groups
    Wait For Groups Page
    
    # Step 3: Click Create New Group
    Click Create New Group
    Wait For Group Creation Form
    
    # Step 4-5: Fill Form-001 (Group Name + Image)
    Enter Group Name    ${GROUP_NAME}
    Upload Group Image    ${GROUP_IMAGE_PATH}
    
    # Step 6: Submit form
    Click Create Group Button
    
    # Step 7: Verify success message (Message-001)
    Verify Success Message    تم إنشاء المجموعة بنجاح!    تمت إضافة المجموعة، يمكنك اضافة الأصول الان.
    Verify Group Details Page Loaded
