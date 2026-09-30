*** Settings ***
Documentation    E2E Test Suite: Create and Publish Individual Real Estate Auction
...              Complete workflow from login to auction publication
Library          Browser
Resource         ../resources/pages/login_page.robot
Resource         ../resources/pages/otp_verification_page.robot
Resource         ../resources/pages/dashboard_page.robot
Resource         ../resources/pages/auctions_list_page.robot
Resource         ../resources/pages/auction_basic_info_page.robot
Resource         ../resources/pages/auction_asset_details_page.robot
Resource         ../resources/pages/auction_attachments_page.robot
Resource         ../resources/pages/auction_location_page.robot
Resource         ../resources/pages/auction_timing_page.robot
Resource         ../resources/pages/auction_financial_page.robot
Resource         ../resources/pages/auction_agent_info_page.robot
Resource         ../resources/pages/auction_additional_info_page.robot
Resource         ../resources/pages/auction_summary_page.robot
Variables        ../data/config.yml
Suite Setup      Setup Browser For E2E Test
Suite Teardown   Close Browser

*** Variables ***
# Test Data - Auction Basic Info
${AUCTION_NAME}                  فيلا سكنية فاخرة
${PROPERTY_TYPE}                 فيلا
${PROPERTY_PURPOSE}              سكني

# Test Data - Asset Details
${PROPERTY_AREA}                 500
${DEED_NUMBER}                   123456789/7/8
${ASSET_DESCRIPTION}             فيلا سكنية فاخرة تقع في حي راقي بمدينة الرياض، تتميز بموقع استراتيجي ممتاز

# Test Data - Location
${REGION}                        الرياض
${CITY}                          الرياض
${DISTRICT}                      حي النرجس
${STREET_WIDTH}                  20
${FACADE_DIRECTION}              شمالية
${BOUNDARY_NORTH}                شارع عام 15 متر
${BOUNDARY_NORTH_LENGTH}         25 متر
${BOUNDARY_SOUTH}                شارع فرعي 10 متر
${BOUNDARY_SOUTH_LENGTH}         25 متر
${BOUNDARY_EAST}                 فيلا سكنية
${BOUNDARY_EAST_LENGTH}          20 متر
${BOUNDARY_WEST}                 فيلا سكنية
${BOUNDARY_WEST_LENGTH}          20 متر

# Test Data - Timing
${START_TIME}                    10:00
${END_TIME}                      14:00
${START_DAY}                     20
${START_MONTH}                   12
${START_YEAR}                    2025
${END_DAY}                       20
${END_MONTH}                     12
${END_YEAR}                      2025

# Test Data - Financial
${ESTIMATED_PRICE}               2000000
${DEPOSIT_AMOUNT}                100000
${OPENING_PRICE}                 1800000
${MIN_BID_INCREMENT}             10000
${VAT_METHOD}                    إجمالي مبلغ المزاد

# Test Data - Custom Fields
${CUSTOM_FIELD_1_NAME}           عدد الغرف
${CUSTOM_FIELD_1_VALUE}          5 غرف
${CUSTOM_FIELD_2_NAME}           عدد دورات المياه
${CUSTOM_FIELD_2_VALUE}          4 دورات

# Test Resources
${TEST_IMAGE_PATH}               C:\\Users\\SKOROG~1\\AppData\\Local\\Temp\\test_asset_main.jpg

*** Test Cases ***
TC001_E2E_Create_And_Publish_Real_Estate_Auction
    [Documentation]    Complete E2E test case to create and publish a real estate auction
    ...                This test covers all 9 forms of the auction creation workflow:
    ...                Form 1: Basic Information (Category and Type)
    ...                Form 2: Asset Details (Name, Type, Area, Deed, Description)
    ...                Form 3: Attachments (Main Image Upload)
    ...                Form 4: Location Details (Region, City, District, Boundaries)
    ...                Form 5: Auction Timing (Start/End Times and Dates)
    ...                Form 6: Financial Information (Prices, Deposit, VAT)
    ...                Form 7: Agent Information (Review Pre-filled Data)
    ...                Form 8: Additional Information (Custom Fields)
    ...                Form 9: Summary and Publish (Review and Confirm)
    [Tags]    e2e    auction_creation    real_estate    smoke    critical
    
    # ============================================================================
    # STEP 1: LOGIN
    # ============================================================================
    Log    STEP 1: Logging in to the system    console=True
    Open Login Page
    Enter Username    ${USERNAME}
    Enter Password    ${PASSWORD}
    Enter Captcha    ${CAPTCHA_CODE}
    Click Sign In Button
    
    # ============================================================================
    # STEP 2: OTP VERIFICATION
    # ============================================================================
    Log    STEP 2: Verifying OTP    console=True
    Wait For OTP Page
    Enter OTP Code    ${OTP_CODE}
    Click Submit OTP
    
    # ============================================================================
    # STEP 3: NAVIGATE TO DASHBOARD
    # ============================================================================
    Log    STEP 3: Verifying dashboard access    console=True
    Verify Dashboard Loaded
    Verify User Logged In
    
    # ============================================================================
    # STEP 4: NAVIGATE TO AUCTIONS MANAGEMENT
    # ============================================================================
    Log    STEP 4: Navigating to auctions management    console=True
    Navigate To Auctions
    Wait For Auctions Page
    
    # ============================================================================
    # STEP 5: START AUCTION CREATION
    # ============================================================================
    Log    STEP 5: Starting new auction creation    console=True
    Click Create New Auction
    
    # ============================================================================
    # STEP 6: FORM 1 - BASIC INFORMATION
    # ============================================================================
    Log    STEP 6: Filling Form 1 - Basic Information    console=True
    Wait For Basic Info Form
    Select Category Real Estate
    Select Auction Type Electronic
    auction_basic_info_page.Click Next Button
    
    # ============================================================================
    # STEP 7: FORM 2 - ASSET DETAILS
    # ============================================================================
    Log    STEP 7: Filling Form 2 - Asset Details    console=True
    Wait For Asset Details Form
    Fill Asset Name    ${AUCTION_NAME}
    Select Property Type    ${PROPERTY_TYPE}
    Select Purpose    ${PROPERTY_PURPOSE}
    Select Opportunity Sale
    Fill Area    ${PROPERTY_AREA}
    Fill Deed Number    ${DEED_NUMBER}
    # Skip description field if not visible
    Click Next To Attachments
    
    # ============================================================================
    # STEP 8: FORM 3 - ATTACHMENTS
    # ============================================================================
    Log    STEP 8: Filling Form 3 - Attachments (Main Image)    console=True
    Wait For Attachments Form
    Upload Main Asset Image    ${TEST_IMAGE_PATH}
    Click Next
    
    # ============================================================================
    # STEP 9: FORM 4 - LOCATION DETAILS
    # ============================================================================
    Log    STEP 9: Filling Form 4 - Location Details    console=True
    Wait For Location Form
    Fill Location Details
    ...    region=${REGION}
    ...    city=${CITY}
    ...    district=${DISTRICT}
    ...    street_width=${STREET_WIDTH}
    ...    facade=${FACADE_DIRECTION}
    Fill Boundaries
    ...    north=${BOUNDARY_NORTH}
    ...    north_length=${BOUNDARY_NORTH_LENGTH}
    ...    south=${BOUNDARY_SOUTH}
    ...    south_length=${BOUNDARY_SOUTH_LENGTH}
    ...    east=${BOUNDARY_EAST}
    ...    east_length=${BOUNDARY_EAST_LENGTH}
    ...    west=${BOUNDARY_WEST}
    ...    west_length=${BOUNDARY_WEST_LENGTH}
    Click Next To Timing
    
    # ============================================================================
    # STEP 10: FORM 5 - AUCTION TIMING
    # ============================================================================
    Log    STEP 10: Filling Form 5 - Auction Timing    console=True
    Wait For Timing Form
    Fill Auction Start Time    ${START_TIME}
    Fill Auction End Time    ${END_TIME}
    Select Start Date    ${START_DAY}    ${START_MONTH}    ${START_YEAR}
    Select End Date      ${END_DAY}      ${END_MONTH}      ${END_YEAR}
    Click Next To Financial
    
    # ============================================================================
    # STEP 11: FORM 6 - FINANCIAL INFORMATION
    # ============================================================================
    Log    STEP 11: Filling Form 6 - Financial Information    console=True
    Wait For Financial Form
    Fill Financial Information
    ...    estimated_price=${ESTIMATED_PRICE}
    ...    deposit=${DEPOSIT_AMOUNT}
    ...    opening_price=${OPENING_PRICE}
    ...    min_bid=${MIN_BID_INCREMENT}
    Select VAT Calculation Method    ${VAT_METHOD}
    Verify Auto Calculated Values
    ...    price_per_meter=3,600
    ...    commission=45,000
    ...    vat=6,750
    Click Next To Agent Info
    
    # ============================================================================
    # STEP 12: FORM 7 - AGENT INFORMATION
    # ============================================================================
    Log    STEP 12: Reviewing Form 7 - Agent Information    console=True
    Wait For Agent Info Form
    Toggle Show Agent Info    off
    Click Next To Additional Info
    
    # ============================================================================
    # STEP 13: FORM 8 - ADDITIONAL INFORMATION
    # ============================================================================
    Log    STEP 13: Filling Form 8 - Additional Information    console=True
    Wait For Additional Info Form
    Add Custom Field    ${CUSTOM_FIELD_1_NAME}    ${CUSTOM_FIELD_1_VALUE}
    Verify Field Added    ${CUSTOM_FIELD_1_NAME}    ${CUSTOM_FIELD_1_VALUE}
    Add Custom Field    ${CUSTOM_FIELD_2_NAME}    ${CUSTOM_FIELD_2_VALUE}
    Verify Field Added    ${CUSTOM_FIELD_2_NAME}    ${CUSTOM_FIELD_2_VALUE}
    Click Next To Summary
    
    # ============================================================================
    # STEP 14: FORM 9 - SUMMARY AND PUBLISH
    # ============================================================================
    Log    STEP 14: Reviewing Form 9 - Summary and Publishing    console=True
    Wait For Summary Page
    Complete Publish Workflow
    
    # ============================================================================
    # STEP 15: VERIFY AUCTION PUBLISHED
    # ============================================================================
    Log    STEP 15: Verifying auction published successfully    console=True
    Verify Auction Published    ${AUCTION_NAME}
    Log    ✅ E2E Test Completed Successfully - Auction Published!    console=True

*** Keywords ***
Setup Browser For E2E Test
    [Documentation]    Initialize browser with appropriate settings for E2E testing
    Log    Initializing browser for E2E auction creation test    console=True
    New Browser    chromium    headless=False
    New Context  
    New Page    ${BASE_URL}
    Set Browser Timeout    30s
    Log    Browser initialized successfully    console=True
