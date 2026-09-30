*** Settings ***
Documentation    Page object for auction additional information form (Form 8)
Library          Browser

*** Variables ***
# Custom Fields Section
${ADD_NEW_FIELD_BUTTON}             css=button[type="button"]
${FIELD_NAME_INPUT}                 css=input[type="text"]
${FIELD_VALUE_INPUT}                xpath=(//input[@type="text"])[2]
${CONFIRM_SAVE_BUTTON}              css=button[type="submit"]
${ADDED_FIELDS_SECTION}             css=.added-fields-section

# Field Actions (Edit/Delete)
${FIELD_EDIT_BUTTON}                css=img[alt*="edit"]
${FIELD_DELETE_BUTTON}              css=img[alt*="trash"]

# Navigation Buttons
${PREVIOUS_BUTTON}                  css=button[class*="previous"]
${NEXT_BUTTON}                      css=button[class*="next"]

*** Keywords ***
Wait For Additional Info Form
    [Documentation]    Wait for the additional information form to be visible
    Wait For Elements State    text="معلومات إضافية"    visible    timeout=10s

Add Custom Field
    [Documentation]    Add a custom field with name and value
    [Arguments]    ${field_name}    ${field_value}
    Click    ${ADD_NEW_FIELD_BUTTON}
    Wait For Elements State    ${FIELD_NAME_INPUT}    visible    timeout=5s
    Fill Text    ${FIELD_NAME_INPUT}    ${field_name}
    Fill Text    ${FIELD_VALUE_INPUT}    ${field_value}
    Click    ${CONFIRM_SAVE_BUTTON}
    Wait For Elements State    ${CONFIRM_SAVE_BUTTON}    hidden    timeout=5s

Add Multiple Custom Fields
    [Documentation]    Add multiple custom fields
    [Arguments]    @{fields}
    # fields should be a list of dictionaries with 'name' and 'value' keys
    FOR    ${field}    IN    @{fields}
        Add Custom Field    ${field}[name]    ${field}[value]
    END

Verify Field Added
    [Documentation]    Verify that a custom field was added successfully
    [Arguments]    ${field_name}    ${field_value}
    ${field_text}=    Set Variable    ${field_name}: ${field_value}
    Wait For Elements State    text="${field_text}"    visible    timeout=5s

Edit Custom Field
    [Documentation]    Edit an existing custom field
    [Arguments]    ${old_name}    ${new_name}    ${new_value}
    # Click edit button for the field with the given name
    Click    css=img[alt*="edit"]
    Wait For Elements State    ${FIELD_NAME_INPUT}    visible    timeout=5s
    Fill Text    ${FIELD_NAME_INPUT}    ${new_name}
    Fill Text    ${FIELD_VALUE_INPUT}    ${new_value}
    Click    ${CONFIRM_SAVE_BUTTON}
    Wait For Elements State    ${CONFIRM_SAVE_BUTTON}    hidden    timeout=5s

Delete Custom Field
    [Documentation]    Delete a custom field
    [Arguments]    ${field_name}
    Click    css=img[alt*="trash"]
    # Wait for confirmation dialog if present
    Sleep    1s

Click Next To Summary
    [Documentation]    Click the Next button to proceed to summary page
    Click    ${NEXT_BUTTON}
    Wait For Elements State    text="الملخص"    visible    timeout=10s

Click Previous
    [Documentation]    Click the Previous button to go back
    Click    ${PREVIOUS_BUTTON}
