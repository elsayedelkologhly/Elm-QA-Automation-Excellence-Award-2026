*** Settings ***
Documentation    Dashboard Page Object - Main application page
Library          Browser
Variables        ../../data/config.yml
Resource         ../common/common_keywords.robot

*** Variables ***
# ✅ VALIDATED LOCATORS - Corrected on 2025-11-17
# Dashboard elements after successful login

# Main Navigation (TIER 3: Unique stable class - fixed non-unique 'main' selector)
${DASHBOARD_CONTAINER}      css=.main-content
${USER_DROPDOWN}            css=button[aria-label="Dropdown menu"]
${LOGO}                     css=img[alt="logo"]
${LOGOUT_LINK}              css=img[alt="log-out"]

# Success notification
${SUCCESS_ALERT}            css=[role="alert"]
${SUCCESS_MESSAGE}          css=[role="alert"] h3
${CLOSE_NOTIFICATION}       css=button[aria-label="Close notification"]

# Main menu - TIER 1/3: Using data-qcauto or unique structural selectors
# Note: Using proper tier priority for menu navigation
${AUCTIONS_MENU}            css=a[href*="/auction"]
${GROUPS_MENU}              css=a[href*="auction-group"]

*** Keywords ***
Verify Dashboard Loaded
    [Documentation]    Verify dashboard page loaded successfully
    Wait For Elements State    ${DASHBOARD_CONTAINER}    visible    timeout=30s
    ${url}=    Get Url
    Should Contain    ${url}    /app

Verify Login Success Message
    [Documentation]    Verify login success notification
    Wait For Elements State    ${SUCCESS_ALERT}    visible    timeout=10s
    ${message}=    Get Text    ${SUCCESS_MESSAGE}
    Should Contain    ${message}    تسجيل الدخول

Close Success Notification
    [Documentation]    Close the success notification banner
    Wait For Element And Click    ${CLOSE_NOTIFICATION}

Click User Dropdown
    [Documentation]    Open user account dropdown menu
    Wait For Element And Click    ${USER_DROPDOWN}

Navigate To Auctions
    [Documentation]    Navigate to auctions management page directly via URL
    Go To    https://salesagent-staging.emazad.sa/app/auction/list
    Sleep    2s

Navigate To Groups
    [Documentation]    Navigate to groups page directly via URL
    Go To    https://salesagent-staging.emazad.sa/app/auction-group/list

Verify User Logged In
    [Documentation]    Verify user is logged in by checking user dropdown
    Wait For Elements State    ${USER_DROPDOWN}    visible    timeout=10s
