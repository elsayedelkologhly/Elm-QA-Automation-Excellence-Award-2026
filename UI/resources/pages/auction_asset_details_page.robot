*** Settings ***
Documentation    Auction Creation - Asset Details Form Page Object
Library          Browser
Resource         ../common/common_keywords.robot

*** Variables ***
# ✅ VALIDATED LOCATORS - DOM verified on 2025-11-17
# All locators use TIER 1 (data-qcauto attributes) - Highest stability

# Asset Details Form Locators (TIER 1: data-qcauto attributes)
${ASSET_NAME_INPUT}              css=[data-qcauto="qc_app_auction_create_input_13oqhjt"]
${PROPERTY_TYPE_DROPDOWN}        xpath=(//ng-multiselect-dropdown[@id='multi-select-default'])[1]
${PURPOSE_DROPDOWN}              xpath=(//ng-multiselect-dropdown[@id='multi-select-default'])[2]
${OPPORTUNITY_SALE_RADIO}        css=[data-qcauto="qc_app_auction_create_input_mazadOpportunity-1"]
${OPPORTUNITY_RENT_RADIO}        css=[data-qcauto="qc_app_auction_create_input_mazadOpportunity-2"]
${AREA_INPUT}                    css=[data-qcauto="qc_app_auction_create_input_19lugpx"]
${DEED_NUMBER_INPUT}             css=[data-qcauto="qc_app_auction_create_input_1l11awv"]
${DESCRIPTION_TEXTAREA}          css=[data-qcauto="qc_app_auction_create_textarea_1y23b1d"]
${NEXT_BUTTON}                   css=[data-qcauto="qc_app_auction_create_button_14q0iwd"]
${PREVIOUS_BUTTON}               css=button[class*="previous"]

*** Keywords ***
Wait For Asset Details Form
    [Documentation]    Wait for asset details form to load
    Wait For Elements State    ${ASSET_NAME_INPUT}    visible    timeout=30s

Fill Asset Name
    [Documentation]    Enter asset name
    [Arguments]    ${asset_name}
    Wait For Element And Fill    ${ASSET_NAME_INPUT}    ${asset_name}

Select Property Type
    [Documentation]    Select property type from dropdown (e.g., فيلا, شقة, etc.)
    [Arguments]    ${property_type}
    Click    ${PROPERTY_TYPE_DROPDOWN}
    Sleep    2s
    # Press down arrow and enter to select first item
    Keyboard Key    press    ArrowDown
    Sleep    0.5s
    Keyboard Key    press    Enter
    Sleep    1s

Select Purpose
    [Documentation]    Select purpose from dropdown (e.g., سكني, تجاري, etc.)
    [Arguments]    ${purpose}
    Click    ${PURPOSE_DROPDOWN}
    Sleep    2s
    # Press down arrow and enter to select first item
    Keyboard Key    press    ArrowDown
    Sleep    0.5s
    Keyboard Key    press    Enter
    Sleep    1s

Select Opportunity Sale
    [Documentation]    Select sale opportunity (default selection)
    Check Checkbox    ${OPPORTUNITY_SALE_RADIO}

Fill Area
    [Documentation]    Enter property area in square meters
    [Arguments]    ${area}
    Wait For Element And Fill    ${AREA_INPUT}    ${area}

Fill Deed Number
    [Documentation]    Enter deed number
    [Arguments]    ${deed_number}
    Wait For Element And Fill    ${DEED_NUMBER_INPUT}    ${deed_number}

Fill Description
    [Documentation]    Enter asset description
    [Arguments]    ${description}
    Wait For Element And Fill    ${DESCRIPTION_TEXTAREA}    ${description}

Click Next To Attachments
    [Documentation]    Click next button to proceed to attachments form
    Wait For Element And Click    ${NEXT_BUTTON}
    Wait For Network Idle
    Sleep    2s

Fill Asset Description
    [Documentation]    Enter asset description
    [Arguments]    ${description}
    # Scroll to textarea if not visible
    Browser.Scroll To Element    ${DESCRIPTION_TEXTAREA}
    Sleep    1s
    Wait For Element And Fill    ${DESCRIPTION_TEXTAREA}    ${description}

Click Next Button
    [Documentation]    Click next to proceed to attachments form
    Wait For Element And Click    ${NEXT_BUTTON}
    Wait For Network Idle
    Sleep    2s

Fill Asset Details Form
    [Documentation]    Complete entire asset details form
    [Arguments]    ${asset_name}    ${property_type}    ${purpose}    ${area}    ${deed_number}    ${description}
    Fill Asset Name    ${asset_name}
    Select Property Type    ${property_type}
    Select Purpose    ${purpose}
    Select Opportunity Sale
    Fill Area    ${area}
    Fill Deed Number    ${deed_number}
    Fill Asset Description    ${description}
    Click Next Button
