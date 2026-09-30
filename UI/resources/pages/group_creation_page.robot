*** Settings ***
Documentation    Group Creation Page - Form-001 for creating new auction group
Library          Browser
Resource         ../common/common_keywords.robot

*** Variables ***
# ✅ VALIDATED LOCATORS - DOM verified on 2025-11-17
# All locators use TIER 1 (data-qcauto attributes) - Highest stability
# Validation: validateLocatorStrict() ✅ PASS | testLocatorUniqueness() ✅ UNIQUE

# Form-001: Group Basic Information Locators (TIER 1: data-qcauto attributes)
${CATEGORY_LABEL}            css=[data-qcauto="qc_app_auction-group_create_label_119565x"]
${CATEGORY_REAL_ESTATE}      css=[data-qcauto="qc_app_auction-group_create_input_category-1"]
${GROUP_NAME_LABEL}          css=[data-qcauto="qc_app_auction-group_create_label_1c7uivf"]
${GROUP_NAME_INPUT}          css=[data-qcauto="qc_app_auction-group_create_input_165cygl"]
${GROUP_IMAGE_LABEL}         css=[data-qcauto="qc_app_auction-group_create_label_9m8mov"]
${CANCEL_BUTTON}             css=[data-qcauto="qc_app_auction-group_create_button_ppnwvy"]
${CREATE_GROUP_BUTTON}       css=[data-qcauto="qc_app_auction-group_create_button_c1aoaf"]

*** Keywords ***
Wait For Group Creation Form
    [Documentation]    Wait for group creation form to load
    Wait For Elements State    ${GROUP_NAME_INPUT}    visible    timeout=30s

Enter Group Name
    [Documentation]    Fill group name field (1-20 chars, Arabic/English, symbols, numbers)
    [Arguments]    ${group_name}
    Wait For Element And Fill    ${GROUP_NAME_INPUT}    ${group_name}

Select Category Real Estate
    [Documentation]    Select real estate category (default selected)
    Wait For Element And Click     ${CATEGORY_REAL_ESTATE}

Upload Group Image
    [Documentation]    Upload group image (png, jpg, jpeg formats, max 800KB)
    [Arguments]    ${image_path}
    ${upload_button}=    Get Element    css=input[type="file"]
    Upload File By Selector    css=input[type="file"]    ${image_path}
    Sleep    2s

Click Create Group Button
    [Documentation]    Submit group creation form
    Wait For Element And Click     ${CREATE_GROUP_BUTTON}

Click Cancel Button
    [Documentation]    Cancel group creation
    Wait For Element And Click     ${CANCEL_BUTTON}

Fill Group Creation Form
    [Documentation]    Complete group creation form with all required data
    [Arguments]    ${group_name}    ${image_path}
    Enter Group Name    ${group_name}
    Upload Group Image    ${image_path}

Verify Group Creation Form Loaded
    [Documentation]    Verify form elements are visible
    Wait For Elements State    ${GROUP_NAME_INPUT}    visible
    Wait For Elements State    ${CREATE_GROUP_BUTTON}    visible
    Wait For Elements State    ${CATEGORY_REAL_ESTATE}    visible
