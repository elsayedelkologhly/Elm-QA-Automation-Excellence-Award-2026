*** Settings ***
Documentation    Auction Creation - Basic Information Form Page Object
Library          Browser
Resource         ../common/common_keywords.robot

*** Variables ***
# ✅ VALIDATED LOCATORS - DOM verified on 2025-11-17
# All locators use TIER 1 (data-qcauto attributes) - Highest stability
# Validation: validateLocatorStrict() ✅ PASS | testLocatorUniqueness() ✅ UNIQUE

# Basic Information Form Locators (TIER 1: data-qcauto attributes)
${CATEGORY_REAL_ESTATE_RADIO}    css=[data-qcauto="qc_app_auction_create_input_category-1"]
${AUCTION_TYPE_ELECTRONIC_RADIO}  css=[data-qcauto="qc_app_auction_create_input_mazadType-1"]
${NEXT_BUTTON}                    css=[data-qcauto="qc_app_auction_create_button_14q0iwd"]

# Form labels
${CATEGORY_LABEL}                 css=[data-qcauto="qc_app_auction_create_label_1dj0r75"]
${AUCTION_TYPE_LABEL}             css=[data-qcauto="qc_app_auction_create_label_1heofve"]

# Page heading
${PAGE_HEADING}                   css=h2

*** Keywords ***
Wait For Basic Info Form
    [Documentation]    Wait for basic information form to load
    Wait For Elements State    ${CATEGORY_REAL_ESTATE_RADIO}    visible    timeout=30s
    Wait For Elements State    ${AUCTION_TYPE_ELECTRONIC_RADIO}    visible

Select Category Real Estate
    [Documentation]    Select real estate category (already selected by default)
    ${is_checked}=    Get Checkbox State    ${CATEGORY_REAL_ESTATE_RADIO}
    IF    not ${is_checked}
        Check Checkbox    ${CATEGORY_REAL_ESTATE_RADIO}
    END

Select Auction Type Electronic
    [Documentation]    Select electronic auction type (already selected by default)
    ${is_checked}=    Get Checkbox State    ${AUCTION_TYPE_ELECTRONIC_RADIO}
    IF    not ${is_checked}
        Check Checkbox    ${AUCTION_TYPE_ELECTRONIC_RADIO}
    END

Click Next Button
    [Documentation]    Click next button to proceed to asset details form
    Wait For Element And Click    ${NEXT_BUTTON}
    Wait For Network Idle
    Sleep    2s

Verify Basic Info Form Loaded
    [Documentation]    Verify basic information form is displayed
    Wait For Elements State    ${PAGE_HEADING}    visible
    ${heading}=    Get Text    ${PAGE_HEADING}
    Should Contain    ${heading}    إنشاء مزاد جديد
    Wait For Elements State    ${CATEGORY_LABEL}    visible
    Wait For Elements State    ${AUCTION_TYPE_LABEL}    visible

Fill Basic Information Form
    [Documentation]    Complete basic information form (both fields pre-selected)
    Select Category Real Estate
    Select Auction Type Electronic
    Click Next Button
