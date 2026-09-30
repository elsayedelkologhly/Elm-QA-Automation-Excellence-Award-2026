*** Settings ***
Documentation    Page object for auction agent information form (Form 7)
Library          Browser

*** Variables ***
# Agent Information Display
${AGENT_INFO_SECTION}               css=.agent-info-section
${AGENT_LOGO_IMAGE}                 css=img[src*="storage.googleapis.com"]
${AGENT_NAME_DISPLAY}               xpath=(//span[@class="info-value"])[1]
${COMMERCIAL_REGISTER_DISPLAY}      xpath=(//span[@class="info-value"])[2]
${LICENSE_NUMBER_DISPLAY}           xpath=(//span[@class="info-value"])[3]

# Toggle Switch
${SHOW_AGENT_INFO_TOGGLE}           css=input[type="checkbox"]
${TOGGLE_LABEL}                     css=label[class*="toggle"]

# Navigation Buttons
${PREVIOUS_BUTTON}                  css=button[class*="previous"]
${NEXT_BUTTON}                      css=button[class*="next"]

*** Keywords ***
Wait For Agent Info Form
    [Documentation]    Wait for the agent information form to be visible
    Wait For Elements State    ${AGENT_INFO_SECTION}    visible    timeout=10s

Verify Agent Logo Displayed
    [Documentation]    Verify that the agent logo is displayed
    Wait For Elements State    ${AGENT_LOGO_IMAGE}    visible    timeout=5s

Get Agent Name
    [Documentation]    Get the displayed agent name
    ${name}=    Get Text    ${AGENT_NAME_DISPLAY}
    RETURN    ${name}

Get Commercial Register Number
    [Documentation]    Get the commercial register number
    ${number}=    Get Text    ${COMMERCIAL_REGISTER_DISPLAY}
    RETURN    ${number}

Get License Number
    [Documentation]    Get the license number
    ${number}=    Get Text    ${LICENSE_NUMBER_DISPLAY}
    RETURN    ${number}

Toggle Show Agent Info
    [Documentation]    Toggle the "Show agent info to buyers" switch
    [Arguments]    ${state}=on
    ${is_checked}=    Get Checkbox State    ${SHOW_AGENT_INFO_TOGGLE}
    
    IF    '${state}' == 'on'
        IF    '${is_checked}' == 'unchecked'
            Click    ${SHOW_AGENT_INFO_TOGGLE}
        END
    ELSE IF    '${state}' == 'off'
        IF    '${is_checked}' == 'checked'
            Click    ${SHOW_AGENT_INFO_TOGGLE}
        END
    END
    
    Sleep    0.5s

Verify Agent Information
    [Documentation]    Verify all agent information fields are populated
    ${name}=    Get Agent Name
    ${register}=    Get Commercial Register Number
    ${license}=    Get License Number
    
    Should Not Be Empty    ${name}
    Should Not Be Empty    ${register}
    Should Not Be Empty    ${license}

Review Agent Information
    [Documentation]    Review pre-filled agent information (no input required)
    Wait For Agent Info Form
    Verify Agent Logo Displayed
    Verify Agent Information
    Log    Agent information reviewed successfully    console=True

Click Next To Additional Info
    [Documentation]    Click the Next button to proceed to additional info form
    Click    ${NEXT_BUTTON}
    Wait For Elements State    text="معلومات إضافية"    visible    timeout=10s

Click Previous
    [Documentation]    Click the Previous button to go back
    Click    ${PREVIOUS_BUTTON}
