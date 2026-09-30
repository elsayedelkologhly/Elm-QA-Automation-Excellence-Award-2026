*** Settings ***
Documentation    Page object for auction summary and publish form (Form 9)
Library          Browser

*** Variables ***
# Summary Page Elements
${SUMMARY_HEADING}                      css=.summary-heading
${PREVIEW_AS_VISITOR_BUTTON}            css=button[class*="preview"]

# Summary Accordion Sections
${BASIC_INFO_ACCORDION}                 xpath=(//button[@class='accordion-button'])[1]
${ASSET_DETAILS_ACCORDION}              xpath=(//button[@class='accordion-button'])[2]
${ATTACHMENTS_ACCORDION}                xpath=(//button[@class='accordion-button'])[3]
${LOCATION_ACCORDION}                   xpath=(//button[@class='accordion-button'])[4]
${TIMING_ACCORDION}                     xpath=(//button[@class='accordion-button'])[5]
${FINANCIAL_INFO_ACCORDION}             xpath=(//button[@class='accordion-button'])[6]
${AGENT_INFO_ACCORDION}                 xpath=(//button[@class='accordion-button'])[7]
${ADDITIONAL_INFO_ACCORDION}            xpath=(//button[@class='accordion-button'])[8]

# Action Buttons
${PREVIOUS_BUTTON}                      css=button[class*="previous"]
${SAVE_AUCTION_BUTTON}                  css=button[class*="save"]

# Publish Confirmation Dialog
${PUBLISH_CONFIRMATION_DIALOG}          css=.confirmation-dialog
${PUBLISH_NOW_BUTTON}                   css=button[class*="publish"]
${CLOSE_DIALOG_BUTTON}                  css=button[aria-label="Close modal"]

# Success/Error Dialogs
${SUCCESS_DIALOG}                       css=.success-dialog
${ERROR_DIALOG}                         css=.error-dialog
${OK_BUTTON}                            css=button[class*="confirm"]

# Disclaimer Message
${DISCLAIMER_TEXT}                      css=.disclaimer-text

*** Keywords ***
Wait For Summary Page
    [Documentation]    Wait for the summary page to be visible
    Wait For Elements State    ${SUMMARY_HEADING}    visible    timeout=10s
    Wait For Elements State    ${SAVE_AUCTION_BUTTON}    visible    timeout=10s

Expand Accordion Section
    [Documentation]    Expand a specific accordion section to view details
    [Arguments]    ${section_name}
    # Note: Use position-based selector instead of text-based
    Click    css=button.accordion-button
    Wait For Elements State    css=button.accordion-button    stable    timeout=2s

Expand All Accordion Sections
    [Documentation]    Expand all accordion sections to view all details
    Expand Accordion Section    المعلومات الأساسية
    Expand Accordion Section    تفاصيل الأصل
    Expand Accordion Section    المرفقات
    Expand Accordion Section    تفاصيل الموقع
    Expand Accordion Section    توقيتات المزاد
    Expand Accordion Section    المعلومات المالية
    Expand Accordion Section    معلومات الوكيل
    Expand Accordion Section    معلومات إضافية

Click Preview As Visitor
    [Documentation]    Click the preview as visitor button
    Click    ${PREVIEW_AS_VISITOR_BUTTON}
    # Wait for preview page to open (may open in new tab)
    Sleep    2s

Verify Summary Data
    [Documentation]    Verify specific data in the summary (after expanding accordion)
    [Arguments]    ${field_label}    ${expected_value}
    Expand All Accordion Sections
    ${element}=    Get Element    text="${field_label}"
    Wait For Elements State    text="${expected_value}"    visible    timeout=5s

Save And Publish Auction
    [Documentation]    Save and publish the auction
    Click    ${SAVE_AUCTION_BUTTON}
    Wait For Elements State    ${PUBLISH_CONFIRMATION_DIALOG}    visible    timeout=10s
    Wait For Elements State    ${PUBLISH_NOW_BUTTON}    visible    timeout=5s

Confirm Publish
    [Documentation]    Confirm the auction publication
    Click    ${PUBLISH_NOW_BUTTON}
    Wait For Elements State    ${PUBLISH_NOW_BUTTON}    hidden    timeout=10s

Handle Publish Success
    [Documentation]    Handle the success dialog after publishing
    Wait For Elements State    ${SUCCESS_DIALOG}    visible    timeout=15s
    Wait For Elements State    ${OK_BUTTON}    visible    timeout=5s
    Click    ${OK_BUTTON}
    # Wait for redirect to auctions list
    Wait For Elements State    text="المزادات"    visible    timeout=10s

Handle Publish Error
    [Documentation]    Handle the error dialog if publish fails
    Wait For Elements State    ${ERROR_DIALOG}    visible    timeout=10s
    Wait For Elements State    ${OK_BUTTON}    visible    timeout=5s
    Click    ${OK_BUTTON}

Complete Publish Workflow
    [Documentation]    Complete the entire publish workflow (save, confirm, handle success)
    Save And Publish Auction
    Confirm Publish
    Handle Publish Success

Verify Auction Published
    [Documentation]    Verify auction was published successfully
    [Arguments]    ${auction_name}
    # Should be on auctions list page after publish
    Wait For Elements State    text="المزادات"    visible    timeout=10s
    Wait For Elements State    text="${auction_name}"    visible    timeout=10s

Click Previous
    [Documentation]    Click the Previous button to go back
    Click    ${PREVIOUS_BUTTON}
