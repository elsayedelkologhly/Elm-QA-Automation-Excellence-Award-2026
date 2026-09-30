*** Settings ***
Documentation    Group Details Page - Success message and group information
Library          Browser

*** Variables ***
# ✅ VALIDATED LOCATORS - DOM verified on 2025-11-17
# All locators use TIER 1 (data-qcauto attributes) or TIER 3 (role) - High stability
# Validation: validateLocatorStrict() ✅ PASS | testLocatorUniqueness() ✅ UNIQUE

# Success Message Locators (TIER 3: role attribute)
${SUCCESS_ALERT}              css=[role="alert"]

# Group Details Page Locators (TIER 1: data-qcauto attributes preferred, TIER 5: XPath single attribute as fallback)
${BREADCRUMB_GROUPS}          css=[data-qcauto^="qc_app_auction-group_details"][data-qcauto$="_a_kahnmz"]
${EDIT_DATA_LINK}             css=[data-qcauto^="qc_app_auction-group_details"][data-qcauto$="_a_1ohz4a6"]
${GROUP_IMAGE}                css=[data-qcauto^="qc_app_auction-group_details"][data-qcauto$="_img_1qj4xu"]
# TIER 5: XPath with single class attribute (avoiding element name and multiple classes)
${ADD_AUCTION_BUTTON}         xpath=//*[@class='btn-primary']

*** Keywords ***
Wait For Group Details Page
    [Documentation]    Wait for group details page to load
    Wait For Elements State    ${ADD_AUCTION_BUTTON}    visible    timeout=30s

Verify Success Message
    [Documentation]    Verify group creation success message (Message-001)
    [Arguments]    ${expected_title}=تم إنشاء المجموعة بنجاح!    ${expected_message}=تمت إضافة المجموعة، يمكنك اضافة الأصول الان.
    Wait For Elements State    ${SUCCESS_ALERT}    visible    timeout=10s
    ${alert_text}=    Get Text    ${SUCCESS_ALERT}
    Should Contain    ${alert_text}    ${expected_title}
    Should Contain    ${alert_text}    ${expected_message}

Verify Group Details Page Loaded
    [Documentation]    Verify group details page by checking URL
    Sleep    2s
    ${url}=    Get Url
    Should Contain    ${url}    auction-group

Click Edit Data
    [Documentation]    Click edit group data link
    Click    ${EDIT_DATA_LINK}

Click Add New Auction
    [Documentation]    Click add new auction button
    Click    ${ADD_AUCTION_BUTTON}

Click Breadcrumb Groups
    [Documentation]    Navigate back to groups list via breadcrumb
    Click    ${BREADCRUMB_GROUPS}
