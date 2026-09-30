*** Settings ***
Documentation    Page object for auction timing form (Form 5)
Library          Browser
Library          String

*** Variables ***
# Time Inputs
${START_TIME_INPUT}                 xpath=(//input[@type='text'])[1]
${END_TIME_INPUT}                   xpath=(//input[@type='text'])[2]

# Date Pickers
${START_DATE_INPUT}                 xpath=(//input[@type='text'])[3]
${END_DATE_INPUT}                   xpath=(//input[@type='text'])[4]

# Time Picker Buttons
${HOUR_BUTTON_PREFIX}               xpath=//button[@class='mdc-button'][position()=
${MINUTE_BUTTON_PREFIX}             xpath=//button[@class='mdc-button'][position()=
${AM_BUTTON}                        xpath=(//button[@class='mdc-button'])[1]
${PM_BUTTON}                        xpath=(//button[@class='mdc-button'])[2]

# Date Picker Elements
${MONTH_DROPDOWN}                   css=select.mat-calendar-period-button
${YEAR_DROPDOWN}                    css=button.mat-calendar-period-button
${DATE_CELL_PREFIX}                 xpath=//button[@class='mat-calendar-body-cell'][position()=

# Navigation Buttons
${PREVIOUS_BUTTON}                  css=button[class*="previous"]
${NEXT_BUTTON}                      css=button[class*="next"]

*** Keywords ***
Wait For Timing Form
    [Documentation]    Wait for the timing form to be visible
    Wait For Elements State    text="توقيت المزاد"    visible    timeout=10s

Fill Auction Start Time
    [Documentation]    Fill the auction start time (HH:MM format)
    [Arguments]    ${time}
    # Time format: "10:00" for 10:00 AM or "14:00" for 2:00 PM
    ${hour}=    Get Substring    ${time}    0    2
    ${minute}=    Get Substring    ${time}    3    5
    ${hour_int}=    Convert To Integer    ${hour}
    
    # Click start time input to open picker
    Click    ${START_TIME_INPUT}
    Sleep    1s
    
    # Determine AM/PM
    IF    ${hour_int} >= 12
        ${display_hour}=    Evaluate    ${hour_int} if ${hour_int} == 12 else ${hour_int} - 12
        Click    ${PM_BUTTON}
    ELSE
        ${display_hour}=    Set Variable    ${hour_int}
        Click    ${AM_BUTTON}
    END
    
    # Select hour
    ${hour_button}=    Set Variable    ${HOUR_BUTTON_PREFIX}${display_hour}']
    Click    ${hour_button}
    
    # Select minute
    ${minute_button}=    Set Variable    ${MINUTE_BUTTON_PREFIX}${minute}']
    Click    ${minute_button}
    
    Wait For Elements State    ${START_TIME_INPUT}    stable    timeout=2s

Fill Auction End Time
    [Documentation]    Fill the auction end time (HH:MM format)
    [Arguments]    ${time}
    ${hour}=    Get Substring    ${time}    0    2
    ${minute}=    Get Substring    ${time}    3    5
    ${hour_int}=    Convert To Integer    ${hour}
    
    # Click end time input to open picker
    Click    ${END_TIME_INPUT}
    Sleep    1s
    
    # Determine AM/PM
    IF    ${hour_int} >= 12
        ${display_hour}=    Evaluate    ${hour_int} if ${hour_int} == 12 else ${hour_int} - 12
        Click    ${PM_BUTTON}
    ELSE
        ${display_hour}=    Set Variable    ${hour_int}
        Click    ${AM_BUTTON}
    END
    
    # Select hour
    ${hour_button}=    Set Variable    ${HOUR_BUTTON_PREFIX}${display_hour}']
    Click    ${hour_button}
    
    # Select minute
    ${minute_button}=    Set Variable    ${MINUTE_BUTTON_PREFIX}${minute}']
    Click    ${minute_button}
    
    Wait For Elements State    ${END_TIME_INPUT}    stable    timeout=2s

Select Start Date
    [Documentation]    Select the auction start date
    [Arguments]    ${day}    ${month}    ${year}
    Click    ${START_DATE_INPUT}
    Sleep    1s
    
    # Select year (if needed)
    Click    ${YEAR_DROPDOWN}
    Sleep    0.5s
    Click    css=button.mat-calendar-body-cell
    
    # Select month
    ${month_int}=    Convert To Integer    ${month}
    Evaluate Javascript    () => { document.querySelector('select.mat-calendar-period-button').value = '${month_int}'; document.querySelector('select.mat-calendar-period-button').dispatchEvent(new Event('change')); }
    Sleep    0.5s
    
    # Select day
    Click    css=button.mat-calendar-body-cell
    Wait For Elements State    ${START_DATE_INPUT}    stable    timeout=2s

Select End Date
    [Documentation]    Select the auction end date
    [Arguments]    ${day}    ${month}    ${year}
    Click    ${END_DATE_INPUT}
    Sleep    1s
    
    # Select year (if needed)
    Click    ${YEAR_DROPDOWN}
    Sleep    0.5s
    Click    css=button.mat-calendar-body-cell
    
    # Select month
    ${month_int}=    Convert To Integer    ${month}
    Evaluate JavaScript    None    document.querySelector('select.mat-calendar-period-button').value = '${month_int}'; document.querySelector('select.mat-calendar-period-button').dispatchEvent(new Event('change'));
    Sleep    0.5s
    
    # Select day
    ${date_cell}=    Set Variable    ${DATE_CELL_PREFIX}${day}']
    Click    ${date_cell}
    Wait For Elements State    ${END_DATE_INPUT}    stable    timeout=2s

Fill Complete Timing
    [Documentation]    Fill all timing fields at once
    [Arguments]    ${start_time}    ${end_time}    ${start_day}    ${start_month}    ${start_year}    ${end_day}    ${end_month}    ${end_year}
    Fill Auction Start Time    ${start_time}
    Fill Auction End Time    ${end_time}
    Select Start Date    ${start_day}    ${start_month}    ${start_year}
    Select End Date    ${end_day}    ${end_month}    ${end_year}

Click Next To Financial
    [Documentation]    Click the Next button to proceed to financial form
    Click    ${NEXT_BUTTON}
    Wait For Elements State    text="المعلومات المالية"    visible    timeout=10s

Click Previous
    [Documentation]    Click the Previous button to go back
    Click    ${PREVIOUS_BUTTON}
