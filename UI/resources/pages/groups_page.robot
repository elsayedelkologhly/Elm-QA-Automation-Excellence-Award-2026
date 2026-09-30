*** Settings ***
Documentation    Groups Page - Groups list and management
Library          Browser

*** Variables ***
# ✅ VALIDATED LOCATORS - DOM verified on 2025-11-17
# All locators use TIER 1 (data-qcauto attributes) - Highest stability
# Validation: validateLocatorStrict() ✅ PASS | testLocatorUniqueness() ✅ UNIQUE

# Groups Page Locators (TIER 1: data-qcauto attributes - exact match required for uniqueness)
${CREATE_NEW_GROUP_BUTTON}    css=[data-qcauto="qc_app_auction-group_list_button_142rh85"]
${SEARCH_INPUT}               css=[data-qcauto="qc_app_auction-group_list_input_17grguv"]
${FILTER_BUTTON}              css=[data-qcauto="qc_app_auction-group_list_button_11qec9y"]

*** Keywords ***
Wait For Groups Page
    [Documentation]    Wait for groups list page to load
    Wait For Elements State    ${CREATE_NEW_GROUP_BUTTON}    visible    timeout=30s

Click Create New Group
    [Documentation]    Click on create new group button
    Click    ${CREATE_NEW_GROUP_BUTTON}
    Sleep    2s

Search Group
    [Documentation]    Search for group by ID or name
    [Arguments]    ${search_text}
    Fill Text    ${SEARCH_INPUT}    ${search_text}

Click Filter Button
    [Documentation]    Open filter options
    Click    ${FILTER_BUTTON}

Verify Groups Page Loaded
    [Documentation]    Verify groups page elements are visible
    Wait For Elements State    ${CREATE_NEW_GROUP_BUTTON}    visible
    Wait For Elements State    ${SEARCH_INPUT}    visible
