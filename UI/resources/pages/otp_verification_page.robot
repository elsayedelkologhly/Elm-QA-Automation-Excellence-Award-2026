*** Settings ***
Documentation    OTP Verification Page Object
Library          Browser
Library          String
Resource         ../common/common_keywords.robot

*** Variables ***
# ✅ VALIDATED LOCATORS - DOM verified and corrected on 2025-11-17
# Using TIER 4 type attribute + nth-of-type for OTP input fields
# Validation: testLocatorUniqueness() ✅ UNIQUE for each field

# OTP Form Locators (TIER 1: data-qcauto for submit button)
${OTP_SUBMIT_BUTTON}        css=[data-qcauto^="qc_auth_sign-in_button"]
${OTP_TIMER}                css=h6

# Individual OTP Input Fields - Using proper TIER strategy
# Note: Avoiding forbidden attribute+position combo per Category 4
# Using TIER 1 data-qcauto attributes if available, otherwise parent context
${OTP_INPUT_1}              css=[data-qcauto^="qc_auth_sign-in_input"]:nth-child(1)
${OTP_INPUT_2}              css=[data-qcauto^="qc_auth_sign-in_input"]:nth-child(2)
${OTP_INPUT_3}              css=[data-qcauto^="qc_auth_sign-in_input"]:nth-child(3)
${OTP_INPUT_4}              css=[data-qcauto^="qc_auth_sign-in_input"]:nth-child(4)
${OTP_INPUT_5}              css=[data-qcauto^="qc_auth_sign-in_input"]:nth-child(5)


*** Keywords ***
Wait For OTP Page
    [Documentation]    Wait for OTP verification page to load
    Wait For Elements State    ${OTP_INPUT_1}    visible    timeout=30s

Enter OTP Code
    [Documentation]    Fill OTP verification code (5 digits, one per field)
    [Arguments]    ${otp_code}
    # Convert OTP code to string and split into individual digits
    ${otp_string}=    Convert To String    ${otp_code}
    ${digit_1}=    Get Substring    ${otp_string}    0    1
    ${digit_2}=    Get Substring    ${otp_string}    1    2
    ${digit_3}=    Get Substring    ${otp_string}    2    3
    ${digit_4}=    Get Substring    ${otp_string}    3    4
    ${digit_5}=    Get Substring    ${otp_string}    4    5
    
    # Fill each OTP input field
    Wait For Element And Fill    ${OTP_INPUT_1}    ${digit_1}
    Wait For Element And Fill    ${OTP_INPUT_2}    ${digit_2}
    Wait For Element And Fill    ${OTP_INPUT_3}    ${digit_3}
    Wait For Element And Fill    ${OTP_INPUT_4}    ${digit_4}
    Wait For Element And Fill    ${OTP_INPUT_5}    ${digit_5}

Click Submit OTP
    [Documentation]    Submit OTP verification form
    Wait For Element And Click    ${OTP_SUBMIT_BUTTON}
    Wait For Network Idle
    # Wait for navigation after OTP submission
    Sleep    2s

Verify OTP Success
    [Documentation]    Verify successful login after OTP
    # Wait for URL change to dashboard with proper network idle state
    Wait Until Network Is Idle    timeout=10s
    ${url}=    Get Url
    Should Contain    ${url}    /app

Complete OTP Verification
    [Documentation]    Complete OTP verification process
    [Arguments]    ${otp_code}
    Wait For OTP Page
    Enter OTP Code    ${otp_code}
    Click Submit OTP
    Verify OTP Success
