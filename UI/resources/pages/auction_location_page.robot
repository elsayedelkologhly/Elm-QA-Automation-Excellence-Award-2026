*** Settings ***
Documentation    Page object for auction location details form (Form 4)
Library          Browser

*** Variables ***
# Location Form Elements
${REGION_DROPDOWN}                  css=select[class*="region"]
${CITY_DROPDOWN}                    css=select[class*="city"]
${DISTRICT_INPUT}                   css=input[type="text"]
${STREET_WIDTH_INPUT}               css=input[type="number"]
${FACADE_INPUT}                     xpath=(//input[@type="text"])[2]

# Google Maps Section
${GOOGLE_MAPS_LINK_INPUT}           css=input[type="url"]
${GO_TO_LOCATION_BUTTON}            css=button[class*="location"]

# Boundaries Section
${BOUNDARY_NORTH_INPUT}             xpath=(//input[@type="text"])[3]
${BOUNDARY_NORTH_LENGTH_INPUT}      xpath=(//input[@type="number"])[1]
${BOUNDARY_SOUTH_INPUT}             xpath=(//input[@type="text"])[4]
${BOUNDARY_SOUTH_LENGTH_INPUT}      xpath=(//input[@type="number"])[2]
${BOUNDARY_EAST_INPUT}              xpath=(//input[@type="text"])[5]
${BOUNDARY_EAST_LENGTH_INPUT}       xpath=(//input[@type="number"])[3]
${BOUNDARY_WEST_INPUT}              xpath=(//input[@type="text"])[6]
${BOUNDARY_WEST_LENGTH_INPUT}       xpath=(//input[@type="number"])[4]

# Navigation Buttons
${PREVIOUS_BUTTON}                  css=button[class*="previous"]
${NEXT_BUTTON}                      css=button[class*="next"]

*** Keywords ***
Wait For Location Form
    [Documentation]    Wait for the location form to be visible
    Wait For Elements State    text="موقع الاصل المعروض في المزاد"    visible    timeout=10s

Select Region
    [Documentation]    Select region from dropdown
    [Arguments]    ${region}
    Click    ${REGION_DROPDOWN}
    Sleep    1s
    Click    css=option[class*="dropdown-item"]
    Wait For Elements State    ${REGION_DROPDOWN}    stable    timeout=2s

Select City
    [Documentation]    Select city from dropdown
    [Arguments]    ${city}
    Click    ${CITY_DROPDOWN}
    Sleep    1s
    Click    css=option[class*="dropdown-item"]
    Wait For Elements State    ${CITY_DROPDOWN}    stable    timeout=2s

Fill District
    [Documentation]    Fill district/neighborhood name
    [Arguments]    ${district}
    Fill Text    ${DISTRICT_INPUT}    ${district}

Fill Street Width
    [Documentation]    Fill street width in meters
    [Arguments]    ${width}
    Fill Text    ${STREET_WIDTH_INPUT}    ${width}

Fill Facade Direction
    [Documentation]    Fill facade direction
    [Arguments]    ${facade}
    Fill Text    ${FACADE_INPUT}    ${facade}

Fill Google Maps Link
    [Documentation]    Fill Google Maps location link (optional)
    [Arguments]    ${maps_link}
    Fill Text    ${GOOGLE_MAPS_LINK_INPUT}    ${maps_link}

Fill Boundary
    [Documentation]    Fill a specific boundary and its length
    [Arguments]    ${direction}    ${description}    ${length}
    IF    '${direction}' == 'north'
        Fill Text    ${BOUNDARY_NORTH_INPUT}    ${description}
        Fill Text    ${BOUNDARY_NORTH_LENGTH_INPUT}    ${length}
    ELSE IF    '${direction}' == 'south'
        Fill Text    ${BOUNDARY_SOUTH_INPUT}    ${description}
        Fill Text    ${BOUNDARY_SOUTH_LENGTH_INPUT}    ${length}
    ELSE IF    '${direction}' == 'east'
        Fill Text    ${BOUNDARY_EAST_INPUT}    ${description}
        Fill Text    ${BOUNDARY_EAST_LENGTH_INPUT}    ${length}
    ELSE IF    '${direction}' == 'west'
        Fill Text    ${BOUNDARY_WEST_INPUT}    ${description}
        Fill Text    ${BOUNDARY_WEST_LENGTH_INPUT}    ${length}
    END

Fill Boundaries
    [Documentation]    Fill all four boundaries with descriptions and lengths
    [Arguments]    ${north}    ${north_length}    ${south}    ${south_length}    ${east}    ${east_length}    ${west}    ${west_length}
    Fill Text    ${BOUNDARY_NORTH_INPUT}    ${north}
    Fill Text    ${BOUNDARY_NORTH_LENGTH_INPUT}    ${north_length}
    Fill Text    ${BOUNDARY_SOUTH_INPUT}    ${south}
    Fill Text    ${BOUNDARY_SOUTH_LENGTH_INPUT}    ${south_length}
    Fill Text    ${BOUNDARY_EAST_INPUT}    ${east}
    Fill Text    ${BOUNDARY_EAST_LENGTH_INPUT}    ${east_length}
    Fill Text    ${BOUNDARY_WEST_INPUT}    ${west}
    Fill Text    ${BOUNDARY_WEST_LENGTH_INPUT}    ${west_length}

Fill Location Details
    [Documentation]    Fill all basic location details
    [Arguments]    ${region}    ${city}    ${district}    ${street_width}    ${facade}
    Select Region    ${region}
    Select City    ${city}
    Fill District    ${district}
    Fill Street Width    ${street_width}
    Fill Facade Direction    ${facade}

Click Next To Timing
    [Documentation]    Click the Next button to proceed to timing form
    Click    ${NEXT_BUTTON}
    Wait For Elements State    text="توقيت المزاد"    visible    timeout=10s

Click Previous
    [Documentation]    Click the Previous button to go back
    Click    ${PREVIOUS_BUTTON}
