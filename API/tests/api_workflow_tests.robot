*** Settings ***
Documentation    Complete E-Mazad API workflow tests based on HAR file analysis
Library          RequestsLibrary
Library          Collections
Resource         ../resources/api_keywords.robot
Resource         ../resources/authentication_keywords.robot  
Resource         ../variables/api_config.robot
Resource         ../variables/global_variables.robot
Suite Setup      Setup API Test Suite  
Suite Teardown   Teardown API Test Suite
Test Tags        api    emazad    har-based

*** Test Cases ***
Complete E-Mazad Authentication Flow Test
    [Documentation]     CRITICAL: Test complete authentication workflow from HAR - ONLY 2xx
    [Tags]    authentication    smoke    critical
    
    # Authentication is already handled in Suite Setup, verify it worked
    Validate Global Authentication Is Active
    
    # Test captcha retrieval as standalone operation
    Test Captcha Image Retrieval
    
    Log     Complete E-Mazad authentication workflow validated successfully
E-Mazad Business API Workflow Test
    [Documentation]    🚨 MANDATORY: Test complete business API workflow - auction management
    [Tags]    business    auction    workflow    integration
    
    # Step 1: Get reference data for auction creation
    ${asset_types}=    Get Asset Types Reference Data
    ${auction_types}=  Get Auction Types Reference Data  
    ${regions}=        Get Auction Regions Reference Data
    
    # Step 2: List existing auctions
    ${auction_list}=   Get Auction List
    
    # Step 3: Create new auction with asset
    ${new_auction}=    Create Auction With Asset    ${asset_types}    ${auction_types}    ${regions}
    
    # Step 4: Verify auction creation and list drafts
    ${draft_list}=     Get Draft Auction List
    
    Log    ✅ Complete E-Mazad business API workflow completed successfully
E-Mazad API Authentication Token Cascading Test
    [Documentation]    Test parameter cascading between authentication steps
    [Tags]    authentication    cascading    integration
    
    # Verify all tokens and user data are available from Suite Setup
    Validate Authentication Token Cascade
    
    # Test that global headers work for authenticated requests
    Test Global Headers Functionality
    
    Log     E-Mazad authentication token cascading validated

*** Keywords ***
Validate Global Authentication Is Active
    [Documentation]    Verify authentication completed successfully with all tokens
    
    # Validate temp token was extracted
    Should Not Be Empty    ${GLOBAL_TEMP_ACCESS_TOKEN}
    Log     Temp Access Token: ${GLOBAL_TEMP_ACCESS_TOKEN[:20]}...
    
    # Validate final access token was extracted
    Should Not Be Empty    ${GLOBAL_ACCESS_TOKEN}  
    Log     Final Access Token: ${GLOBAL_ACCESS_TOKEN[:20]}...
    
    # Validate user ID was extracted
    Should Not Be Empty    ${GLOBAL_USER_ID}
    Should Be True    ${GLOBAL_USER_ID} > 0
    Log     User ID: ${GLOBAL_USER_ID}
    
    # Validate global headers are configured
    Should Not Be Empty    ${GLOBAL_HEADERS}
    Dictionary Should Contain Key    ${GLOBAL_HEADERS}    Authorization
    Should Contain    ${GLOBAL_HEADERS}[Authorization]    Bearer
    Log     Global headers configured with Bearer token

Test Captcha Image Retrieval
    [Documentation]     MANDATORY: Test captcha image retrieval - ONLY 2xx
    
    ${captcha_response}=    Get Captcha Image
    
    # Validate captcha response - it returns JSON with base64 image data
    Should Be Equal As Numbers    ${captcha_response.status_code}    200
    Should Be Equal    ${captcha_response.headers}[Content-Type]    application/json; charset=utf-8
    
    # Validate JSON structure
    ${captcha_data}=    Set Variable    ${captcha_response.json()}
    Dictionary Should Contain Key    ${captcha_data}    img
    Dictionary Should Contain Key    ${captcha_data}    token
    Should Not Be Empty    ${captcha_data}[img]
    Should Not Be Empty    ${captcha_data}[token]
    
    Log    ✅ Captcha image and token retrieved successfully

Validate Authentication Token Cascade  
    [Documentation]    Verify token cascade from temp  final access token
    
    # Verify the cascade sequence happened correctly
    Log    Validating authentication token cascade sequence...
    
    # Check temp token format and length
    ${temp_token_length}=    Get Length    ${GLOBAL_TEMP_ACCESS_TOKEN}
    Should Be True    ${temp_token_length} > 50    Temp token seems too short
    
    # Check final token format and length  
    ${final_token_length}=    Get Length    ${GLOBAL_ACCESS_TOKEN}
    Should Be True    ${final_token_length} > 50    Final token seems too short
    
    # Verify tokens are different (temp vs final)
    Should Not Be Equal    ${GLOBAL_TEMP_ACCESS_TOKEN}    ${GLOBAL_ACCESS_TOKEN}
    
    Log     Authentication token cascade validated successfully

Test Global Headers Functionality
    [Documentation]    Test that global headers work for authenticated requests
    
    # Verify headers structure
    Dictionary Should Contain Key    ${GLOBAL_HEADERS}    Content-Type
    Dictionary Should Contain Key    ${GLOBAL_HEADERS}    Accept  
    Dictionary Should Contain Key    ${GLOBAL_HEADERS}    Authorization
    
    # Verify header values
    Should Be Equal    ${GLOBAL_HEADERS}[Content-Type]    application/json
    Should Be Equal    ${GLOBAL_HEADERS}[Accept]    application/json
    Should Contain     ${GLOBAL_HEADERS}[Authorization]    Bearer ${GLOBAL_ACCESS_TOKEN}
    
    Log     Global headers functionality validated
# Business API Workflow Keywords
Get Asset Types Reference Data
    [Documentation]    🚨 Get asset types reference data - ONLY 2xx
    Log    Getting asset types reference data...
    
    ${response}=    Send GET Request With Global Auth    ${ASSET_TYPES_ENDPOINT}
    ${asset_types}=    Validate And Extract Response Data    ${response}    result
    
    Log    ✅ Asset types retrieved: ${asset_types}[result].__len__() types
    [Return]    ${asset_types}[result]

Get Auction Types Reference Data
    [Documentation]    🚨 Get auction types reference data - ONLY 2xx
    Log    Getting auction types reference data...
    
    ${response}=    Send GET Request With Global Auth    ${AUCTION_TYPES_ENDPOINT}
    ${auction_types}=    Validate And Extract Response Data    ${response}    result
    
    Log    ✅ Auction types retrieved: ${auction_types}[result].__len__() types
    [Return]    ${auction_types}[result]

Get Auction Regions Reference Data  
    [Documentation]    🚨 Get auction regions reference data - ONLY 2xx
    Log    Getting auction regions reference data...
    
    ${response}=    Send GET Request With Global Auth    ${AUCTION_REGIONS_ENDPOINT}
    ${regions}=    Validate And Extract Response Data    ${response}    result
    
    Log    ✅ Auction regions retrieved: ${regions}[result].__len__() regions
    [Return]    ${regions}[result]

Get Auction List
    [Documentation]    🚨 Get paginated auction list - ONLY 2xx
    Log    Getting auction list (page 1)...
    
    # Prepare pagination payload based on HAR analysis
    &{pagination_payload}=    Create Dictionary    pageNumber=1
    
    ${response}=    Send POST Request With Global Auth    ${AUCTION_LIST_ENDPOINT}    ${pagination_payload}
    ${auction_data}=    Validate And Extract Response Data    ${response}    result
    
    # The response has result.totalCount and result.items structure
    ${total_count}=    Get From Dictionary    ${auction_data}[result]    totalCount
    ${items}=         Get From Dictionary    ${auction_data}[result]    items
    
    Log    ✅ Auction list retrieved: ${total_count} total auctions, ${items.__len__() } items in this page
    [Return]    ${auction_data}[result]

Get Draft Auction List
    [Documentation]    🚨 Get draft auction list - ONLY 2xx  
    Log    Getting draft auction list...
    
    # Prepare pagination payload
    &{pagination_payload}=    Create Dictionary    pageNumber=1
    
    ${response}=    Send POST Request With Global Auth    ${DRAFT_AUCTION_LIST_ENDPOINT}    ${pagination_payload}
    ${draft_data}=    Validate And Extract Response Data    ${response}    result
    
    Log    ✅ Draft auction list retrieved successfully
    [Return]    ${draft_data}

Create Auction With Asset
    [Arguments]    ${asset_types}    ${auction_types}    ${regions}
    [Documentation]    🚨 CRITICAL: Create auction with asset - ONLY 2xx status codes
    Log    Creating auction with asset based on HAR payload structure...
    
    # Build auction creation payload based on HAR analysis
    &{main_info}=    Create Dictionary
    ...              globalAssetTypeId=3
    ...              typeId=1
    ...              causeId=${None}
    ...              globalAssetTypeName=أخرى
    ...              typeName=مزاد الكتروني
    
    &{asset_details}=    Create Dictionary
    ...                  assetName=Robot Framework Test Asset
    ...                  description=Test asset created by automation
    
    &{realestate_details}=    Create Dictionary
    ...                       auctionRegionId=2
    ...                       auctionCityId=227
    ...                       district=Test District
    ...                       googleMapUrl=${EMPTY}
    ...                       auctionRegionName=Test Region
    ...                       auctionCityName=Test City
    
    &{timing}=    Create Dictionary
    ...           startDate=2/1/2026
    ...           startTime=01:00:00
    ...           endDate=2/1/2026
    ...           endTime=02:00:00
    
    &{financial_info}=    Create Dictionary
    ...                   calculateVatMethod=1
    ...                   estimatedPrice=1000
    ...                   solvency=100
    ...                   startBidPrice=500
    ...                   minimumBidPrice=400
    
    &{sales_agent_details}=    Create Dictionary
    ...                        phoneNumber=541111113
    ...                        whatsAppNumber=541111113
    
    &{attachments}=    Create Dictionary
    ...                masterImage=${None}
    ...                additionalImages=@{EMPTY}
    ...                brochure=${None}
    ...                assetVideoUrl=${EMPTY}
    ...                assetVideoFile=${None}
    
    &{auction_payload}=    Create Dictionary
    ...                    mainInfo=${main_info}
    ...                    assetDetails=${asset_details}
    ...                    realestateDetails=${realestate_details}
    ...                    attachments=${attachments}
    ...                    timing=${timing}
    ...                    financialInfo=${financial_info}
    ...                    salesAgentDetails=${sales_agent_details}
    ...                    additionalData=@{EMPTY}
    
    # Execute auction creation API call
    ${response}=    Send POST Request With Global Auth    ${CREATE_AUCTION_ENDPOINT}    ${auction_payload}
    ${auction_result}=    Validate And Extract Response Data    ${response}    result
    
    # Store created auction data - the API may return different structure
    Log    ✅ Auction creation request submitted successfully
    Log    Response: ${auction_result}[result]
    
    # Extract auction ID if present in response
    ${has_id}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${auction_result}[result]    id
    IF    ${has_id}
        ${auction_id}=    Get From Dictionary    ${auction_result}[result]    id
        Set Suite Variable    ${CREATED_AUCTION_ID}    ${auction_id}
        Log    ✅ Auction created successfully with ID: ${auction_id}
    ELSE
        Log    ✅ Auction creation completed - response structure: ${auction_result}[result]
        Set Suite Variable    ${CREATED_AUCTION_ID}    ${EMPTY}
    END
    
    [Return]    ${auction_result}