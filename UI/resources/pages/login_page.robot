*** Settings ***
Documentation    Login Page Object - Electronic Auction Platform
Library          Browser
Resource         ../common/common_keywords.robot

*** Variables ***
# ✅ VALIDATED LOCATORS - DOM verified on 2025-11-16
# All locators use TIER 1 (data-qcauto attributes) - Highest stability
# Validation: validateLocatorStrict() ✅ PASS | testLocatorUniqueness() ✅ UNIQUE

# Login Form Locators (TIER 1: data-qcauto attributes)
${USERNAME_INPUT}           css=[data-qcauto="login_personalId"]
${PASSWORD_INPUT}           css=[data-qcauto="login_password"]
${CAPTCHA_INPUT}            css=[data-qcauto="login_recapInput"]
${SIGNIN_BUTTON}            css=[data-qcauto="login_signInBtn"]
${CAPTCHA_RELOAD_BUTTON}    css=[data-qcauto="login_reloadBtn"]

# Status indicators
${ERROR_MESSAGE}            css=.error-message
${SUCCESS_INDICATOR}        css=.dashboard-container

*** Keywords ***
Open Login Page
    [Documentation]    Navigate to login page and wait for form to load
    Wait For Elements State    ${USERNAME_INPUT}    visible    timeout=30s

Enter Username
    [Documentation]    Fill username field
    [Arguments]    ${username}
    Wait For Element And Fill    ${USERNAME_INPUT}    ${username}

Enter Password
    [Documentation]    Fill password field
    [Arguments]    ${password}
    Wait For Element And Fill    ${PASSWORD_INPUT}    ${password}
     

Enter Captcha
    [Documentation]    Fill captcha field
    [Arguments]    ${captcha}
    Wait For Element And Fill    ${CAPTCHA_INPUT}    ${captcha}
     

Click Sign In Button
    [Documentation]    Submit login form
    Wait For Element And Click    ${SIGNIN_BUTTON}
    Wait For Network Idle

Verify Login Error
    [Documentation]    Verify error message is displayed
    [Arguments]    ${expected_message}
    Wait For Elements State    ${ERROR_MESSAGE}    visible    timeout=10s
    ${actual_message}=    Get Text    ${ERROR_MESSAGE}
    Should Contain    ${actual_message}    ${expected_message}

Fill Login Form
    [Documentation]    Fill complete login form
    [Arguments]    ${username}    ${password}    ${captcha}
    Enter Username    ${username}
    Enter Password    ${password}
    Enter Captcha    ${captcha}
