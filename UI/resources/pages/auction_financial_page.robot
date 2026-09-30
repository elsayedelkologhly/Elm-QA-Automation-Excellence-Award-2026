*** Settings ***
Documentation    Page object for auction financial information form (Form 6)
Library          Browser

*** Variables ***
# Financial Input Fields
${ESTIMATED_PRICE_INPUT}            css=input[placeholder*="السعر التقديري"]
${DEPOSIT_AMOUNT_INPUT}             css=input[placeholder*="مبلغ التأمين"]
${OPENING_PRICE_INPUT}              css=input[placeholder*="سعر الافتتاح"]
${MIN_BID_INCREMENT_INPUT}          css=input[placeholder*="الحد الأدنى"]

# VAT Calculation Method Dropdown
${VAT_METHOD_DROPDOWN}              css=select[class*="vat-method"]

# Auto-Calculated Display Fields
${PRICE_PER_METER_DISPLAY}          xpath=(//span[@class="calculated-value"])[1]
${COMMISSION_DISPLAY}               xpath=(//span[@class="calculated-value"])[2]
${VAT_DISPLAY}                      xpath=(//span[@class="calculated-value"])[3]
${TOTAL_DISPLAY}                    xpath=(//span[@class="calculated-value"])[4]

# Navigation Buttons
${PREVIOUS_BUTTON}                  css=button[class*="previous"]
${NEXT_BUTTON}                      css=button[class*="next"]

*** Keywords ***
Wait For Financial Form
    [Documentation]    Wait for the financial information form to be visible
    Wait For Elements State    text="المعلومات المالية"    visible    timeout=10s

Fill Estimated Price
    [Documentation]    Fill the estimated price of the asset
    [Arguments]    ${price}
    Fill Text    ${ESTIMATED_PRICE_INPUT}    ${price}
    # Wait for auto-calculation
    Sleep    1s

Fill Deposit Amount
    [Documentation]    Fill the deposit/insurance amount
    [Arguments]    ${deposit}
    Fill Text    ${DEPOSIT_AMOUNT_INPUT}    ${deposit}

Fill Opening Price
    [Documentation]    Fill the auction opening/starting price
    [Arguments]    ${opening_price}
    Fill Text    ${OPENING_PRICE_INPUT}    ${opening_price}
    # Wait for auto-calculation
    Sleep    1s

Fill Minimum Bid Increment
    [Documentation]    Fill the minimum bid increment amount
    [Arguments]    ${min_bid}
    Fill Text    ${MIN_BID_INCREMENT_INPUT}    ${min_bid}

Select VAT Calculation Method
    [Documentation]    Select VAT calculation method from dropdown
    [Arguments]    ${method}
    Click    ${VAT_METHOD_DROPDOWN}
    Sleep    1s
    Click    css=option[class*="dropdown-item"]
    Wait For Elements State    ${VAT_METHOD_DROPDOWN}    stable    timeout=2s
    # Wait for recalculation
    Sleep    1s

Fill Financial Information
    [Documentation]    Fill all financial information fields
    [Arguments]    ${estimated_price}    ${deposit}    ${opening_price}    ${min_bid}
    Fill Estimated Price    ${estimated_price}
    Fill Deposit Amount    ${deposit}
    Fill Opening Price    ${opening_price}
    Fill Minimum Bid Increment    ${min_bid}

Get Price Per Meter
    [Documentation]    Get the auto-calculated price per meter value
    ${value}=    Get Text    ${PRICE_PER_METER_DISPLAY}
    RETURN    ${value}

Get Commission Amount
    [Documentation]    Get the auto-calculated commission amount
    ${value}=    Get Text    ${COMMISSION_DISPLAY}
    RETURN    ${value}

Get VAT Amount
    [Documentation]    Get the auto-calculated VAT amount
    ${value}=    Get Text    ${VAT_DISPLAY}
    RETURN    ${value}

Get Total Amount
    [Documentation]    Get the total amount including all charges
    ${value}=    Get Text    ${TOTAL_DISPLAY}
    RETURN    ${value}

Verify Auto Calculated Values
    [Documentation]    Verify the auto-calculated financial values
    [Arguments]    ${price_per_meter}    ${commission}    ${vat}
    ${actual_ppm}=    Get Price Per Meter
    ${actual_commission}=    Get Commission Amount
    ${actual_vat}=    Get VAT Amount
    
    Should Contain    ${actual_ppm}    ${price_per_meter}
    Should Contain    ${actual_commission}    ${commission}
    Should Contain    ${actual_vat}    ${vat}

Click Next To Agent Info
    [Documentation]    Click the Next button to proceed to agent info form
    Click    ${NEXT_BUTTON}
    Wait For Elements State    text="معلومات الوكيل"    visible    timeout=10s

Click Previous
    [Documentation]    Click the Previous button to go back
    Click    ${PREVIOUS_BUTTON}
