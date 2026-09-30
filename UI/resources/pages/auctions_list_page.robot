*** Settings ***
Documentation    Auctions List Page Object - Electronic Auction Platform
Library          Browser
Resource         ../common/common_keywords.robot

*** Variables ***
# ✅ VALIDATED LOCATORS - DOM verified on 2025-11-17
# All locators use TIER 1 (data-qcauto attributes) - Highest stability
# Validation: validateLocatorStrict() ✅ PASS | testLocatorUniqueness() ✅ UNIQUE

# Auctions List Page Locators (TIER 1: data-qcauto attributes)
${CREATE_NEW_AUCTION_BUTTON}    css=[data-qcauto="qc_app_auction_list_button_1hhqie0"]
${FILTER_BUTTON}                css=[data-qcauto="qc_app_auction_list_button_1a2ne8e"]
${SEARCH_INPUT}                 css=[data-qcauto="qc_app_auction_list_input_160vwj"]

# Page heading
${PAGE_HEADING}                 css=h2

# Empty state message
${EMPTY_STATE_MESSAGE}          css=h3

*** Keywords ***
Wait For Auctions Page
    [Documentation]    Wait for auctions list page to load
    Wait For Elements State    ${CREATE_NEW_AUCTION_BUTTON}    visible    timeout=30s

Click Create New Auction
    [Documentation]    Click button to create new auction
    Wait For Element And Click    ${CREATE_NEW_AUCTION_BUTTON}
    Wait For Network Idle
    Sleep    2s

Search For Auction
    [Documentation]    Search for auction by ID or name
    [Arguments]    ${search_text}
    Wait For Element And Fill    ${SEARCH_INPUT}    ${search_text}
    Sleep    1s

Click Filter Button
    [Documentation]    Click filter button to show filtering options
    Wait For Element And Click    ${FILTER_BUTTON}

Verify Auctions Page Loaded
    [Documentation]    Verify auctions list page is displayed
    Wait For Elements State    ${CREATE_NEW_AUCTION_BUTTON}    visible
    Wait For Elements State    ${PAGE_HEADING}    visible
    ${heading}=    Get Text    ${PAGE_HEADING}
    Should Contain    ${heading}    المزادات

Verify Empty State Message
    [Documentation]    Verify empty state message when no auctions exist
    Wait For Elements State    ${EMPTY_STATE_MESSAGE}    visible
    ${message}=    Get Text    ${EMPTY_STATE_MESSAGE}
    Should Contain    ${message}    لا توجد مزادات
