*** Settings ***
Documentation    Common Keywords - Reusable across all test suites
Library          Browser
Library          DateTime

*** Variables ***
${DEFAULT_TIMEOUT}    30s
${NETWORK_TIMEOUT}    60s

*** Keywords ***
Setup Test Suite
    [Documentation]    Initialize browser for test suite
    New Browser    chromium    headless=false
    New Context    
      
Setup Test Case
    [Documentation]    Create new context and page for each test
     New Page       https://salesagent-staging.emazad.sa/auth/sign-in
  
Cleanup Test Case
    [Documentation]    Close context after test
    Close Context

Cleanup Test Suite
    [Documentation]    Close browser after all tests
    Close Browser

Navigate To URL
    [Documentation]    Generic URL navigation with network idle wait
    [Arguments]    ${url}
    Go To    ${url}
    Browser.Wait Until Network Is Idle    timeout=3s

Wait For Network Idle
    [Documentation]    Wait for network to settle
    Browser.Wait Until Network Is Idle    timeout=10s

Scroll To Element
    [Documentation]    Scroll element into view
    [Arguments]    ${locator}
    Scroll To Element    ${locator}
    Sleep    0.5s

Take Screenshot On Failure
    [Documentation]    Capture screenshot with timestamp
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Take Screenshot    failure_${timestamp}

Wait For Element And Click
    [Documentation]    Wait for element to be visible and clickable, then click
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait For Elements State    ${locator}    visible    timeout=${timeout}
    Wait For Elements State    ${locator}    enabled    timeout=${timeout}
    Click    ${locator}

Wait For Element And Fill
    [Documentation]    Wait for input element and fill with text
    [Arguments]    ${locator}    ${text}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait For Elements State    ${locator}    visible    timeout=${timeout}
    Wait For Elements State    ${locator}    enabled    timeout=${timeout}
    Fill Text    ${locator}    ${text}
