*** Settings ***
Documentation    Core API interaction keywords for E-Mazad platform
Library          RequestsLibrary
Library          Collections

*** Keywords ***
Setup API Test Suite
    [Documentation]     CRITICAL: Initialize API test suite with E-Mazad authentication
    Log    Starting E-Mazad API Test Suite Setup
    
    # Create main session for E-Mazad services
    Create Session    main_session    ${BASE_URL}    verify=${SSL_VERIFY}
    
    # Create captcha session for captcha service
    Create Session    captcha_session    ${CAPTCHA_BASE_URL}    verify=${SSL_VERIFY}
    
    # Execute complete E-Mazad authentication flow
    Extract And Store Global Authentication
    
    Log     E-Mazad API Test Suite Setup Complete - Authentication Successful

Teardown API Test Suite
    [Documentation]    Clean up API test suite sessions
    Delete All Sessions
    Log     E-Mazad API Test Suite Teardown Complete

Send GET Request With Global Auth
    [Arguments]    ${endpoint}    ${additional_headers}=${EMPTY}
    [Documentation]    Send authenticated GET request using global E-Mazad headers
    
    ${final_headers}=    Copy Dictionary    ${GLOBAL_HEADERS}
    Run Keyword If    '${additional_headers}' != '${EMPTY}'
    ...              Set To Dictionary    ${final_headers}    &{additional_headers}
    
    ${response}=    GET On Session    main_session    ${endpoint}    headers=${final_headers}    expected_status=200
    Validate ONLY 2xx Status Code - NO EXCEPTIONS    ${response}
    [Return]    ${response}

Send POST Request With Global Auth
    [Arguments]    ${endpoint}    ${json_data}    ${additional_headers}=${EMPTY}
    [Documentation]    Send authenticated POST request using global E-Mazad headers
    
    ${final_headers}=    Copy Dictionary    ${GLOBAL_HEADERS}
    Run Keyword If    '${additional_headers}' != '${EMPTY}'
    ...              Set To Dictionary    ${final_headers}    &{additional_headers}
    
    # Use expected_status=any to capture the actual response
    ${response}=    POST On Session    main_session    ${endpoint}    json=${json_data}    headers=${final_headers}    expected_status=any
    
    # Log the response details for debugging
    Log    🔍 Response Status: ${response.status_code}
    Log    🔍 Response Body: ${response.text}
    Log    🔍 Request URL: ${response.url}
    
    # Then validate - this will fail if not 2xx, but we'll see the details
    Validate ONLY 2xx Status Code - NO EXCEPTIONS    ${response}
    [Return]    ${response}

Get Captcha Image
    [Documentation]    🚨 MANDATORY: Get captcha image - ONLY 2xx status codes
    Log    Retrieving captcha image from captcha service
    
    ${captcha_response}=    GET On Session    captcha_session    ${CAPTCHA_ENDPOINT}    expected_status=200
    
    # 🔥 CRITICAL: Validate 2xx status code - NO EXCEPTIONS  
    Should Be Equal As Numbers    ${captcha_response.status_code}    200
    
    # The captcha endpoint returns JSON with base64 image data (based on HAR analysis)
    ${json_data}=    Set Variable    ${captcha_response.json()}
    Dictionary Should Contain Key    ${json_data}    img
    Dictionary Should Contain Key    ${json_data}    token
    
    ${captcha_token}=    Get From Dictionary    ${json_data}    token
    ${captcha_image}=    Get From Dictionary    ${json_data}    img
    
    Log    ✅ Captcha image and token retrieved successfully
    Log    Captcha Token: ${captcha_token}
    Log    Image data length: ${captcha_image.__len__()}
    
    [Return]    ${captcha_response}

Execute API Call With Strict 2xx Validation
    [Arguments]    ${method}    ${session}    ${endpoint}    ${json_data}=${EMPTY}    ${headers}=${GLOBAL_HEADERS}
    [Documentation]     Execute API call with mandatory 2xx validation - NO EXCEPTIONS
    
    # Execute API call based on method
    IF    '${method}' == 'GET'
        ${response}=    GET On Session    ${session}    ${endpoint}    headers=${headers}    expected_status=200
    ELSE IF    '${method}' == 'POST'
        ${response}=    POST On Session    ${session}    ${endpoint}    json=${json_data}    headers=${headers}    expected_status=200
    ELSE IF    '${method}' == 'PUT'
        ${response}=    PUT On Session    ${session}    ${endpoint}    json=${json_data}    headers=${headers}    expected_status=200
    ELSE IF    '${method}' == 'DELETE'
        ${response}=    DELETE On Session    ${session}    ${endpoint}    headers=${headers}    expected_status=200
    ELSE
        Fail    Unsupported HTTP method: ${method}
    END
    
    #  MANDATORY 2xx VALIDATION
    Validate ONLY 2xx Status Code - NO EXCEPTIONS    ${response}
    
    [Return]    ${response}

Debug API Request Failure
    [Arguments]    ${response}    ${expected_endpoint}
    [Documentation]    Comprehensive debugging for failed API requests
    
    Log    ==============================================
    Log     API REQUEST FAILURE ANALYSIS
    Log    ==============================================
    Log    Expected Endpoint: ${expected_endpoint}
    Log    Response Status: ${response.status_code}
    Log    Response Headers: ${response.headers}
    Log    Response Body: ${response.text}
    Log    Request URL: ${response.request.url}
    Log    Request Headers: ${response.request.headers}
    Log    Request Body: ${response.request.body}
    Log    ==============================================
    
    # Check common E-Mazad failure patterns
    IF    ${response.status_code} == 401
        Log     AUTHENTICATION FAILURE - Check tokens/headers
        Log    Current Access Token: ${GLOBAL_ACCESS_TOKEN[:20]}...
    ELSE IF    ${response.status_code} == 403
        Log     AUTHORIZATION FAILURE - Check permissions/scope
    ELSE IF    ${response.status_code} == 404
        Log     ENDPOINT NOT FOUND - Check URL/path
    ELSE IF    ${response.status_code} == 400
        Log     BAD REQUEST - Check payload format/required fields
    END

Validate And Extract Response Data
    [Arguments]    ${response}    @{required_fields}
    [Documentation]    Validate response and extract required fields with 2xx guarantee
    
    # First validate response success
    Validate ONLY 2xx Status Code - NO EXCEPTIONS    ${response}
    
    # Then validate JSON structure
    ${json_data}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json_data}
    
    # Validate required fields exist
    FOR    ${field}    IN    @{required_fields}
        Dictionary Should Contain Key    ${json_data}    ${field}
        Should Not Be Empty    ${json_data}[${field}]
        Log     Validated field: ${field} = ${json_data}[${field}]
    END
    
    [Return]    ${json_data}

Validate ONLY 2xx Status Code - NO EXCEPTIONS
    [Arguments]    ${response}    ${expected_status}=200
    [Documentation]    🚨 CRITICAL: Validate ONLY 2xx status codes - FAIL all others
    
    # 🔥 IRONCLAD STATUS CODE VALIDATION
    Should Be Equal As Numbers    ${response.status_code}    ${expected_status}
    Should Be True    ${response.status_code} >= 200    FAILURE: Status code ${response.status_code} is not 2xx
    Should Be True    ${response.status_code} <= 299    FAILURE: Status code ${response.status_code} is not 2xx
    
    # 🚫 EXPLICIT REJECTION OF ERROR CODES
    Should Not Be True    ${response.status_code} >= 400    CRITICAL FAILURE: 4xx/5xx status code ${response.status_code} detected - TEST MUST FAIL
    
    Log    ✅ SUCCESS: API returned valid 2xx status code: ${response.status_code}

Create Auction With Asset
    [Documentation]    Create new auction with asset using EXACT HAR payload structure
    [Arguments]    ${asset_name}    ${description}
    
    # ⚠️ CRITICAL: Asset name must be 15 characters or less per API validation
    ${short_asset_name}=    Set Variable    ${asset_name[:14]}
    
    # Build auction payload matching EXACT HAR structure  
    ${main_info}=    Create Dictionary
    ...    globalAssetTypeId=3
    ...    typeId=1
    ...    causeId=${None}
    ...    globalAssetTypeName=أخرى
    ...    typeName=مزاد الكتروني
    
    ${asset_details}=    Create Dictionary
    ...    assetName=${short_asset_name}
    ...    description=${description}
    
    ${realestate_details}=    Create Dictionary
    ...    auctionRegionId=2
    ...    auctionCityId=227
    ...    district=11
    ...    googleMapUrl=${EMPTY}
    ...    auctionRegionName=الجوف
    ...    auctionCityName=طبرجل
    
    ${timing}=    Create Dictionary
    ...    startDate=1/21/2026
    ...    startTime=01:00:00
    ...    endDate=1/21/2026
    ...    endTime=01:00:00
    
    ${financial_info}=    Create Dictionary
    ...    calculateVatMethod=1
    ...    estimatedPrice=11
    ...    solvency=11
    ...    startBidPrice=11
    ...    minimumBidPrice=10
    
    ${sales_agent_details}=    Create Dictionary
    ...    phoneNumber=541111113
    ...    whatsAppNumber=541111113
    
    # ⚠️ CRITICAL: Use EXACT master image from working HAR request
    ${master_image}=    Create Dictionary
    ...    url=https://storage.googleapis.com/gcp-mazad-preprod/a98d39ed-d4da-40eb-884f-66793a886bb0
    ...    fileId=a98d39ed-d4da-40eb-884f-66793a886bb0
    ...    name=6760135001_58b1c5c5f0_b.jpg
    ...    size=${102614}
    
    ${attachments}=    Create Dictionary
    ...    masterImage=${master_image}
    ...    additionalImages=@{EMPTY}
    ...    brochure=${None}
    ...    assetVideoUrl=${EMPTY}
    ...    assetVideoFile=${None}
    
    # Combine all sections into final payload (note: mainInfo not basic_info)
    ${auction_payload}=    Create Dictionary
    ...    mainInfo=${main_info}
    ...    assetDetails=${asset_details}
    ...    realestateDetails=${realestate_details}
    ...    timing=${timing}
    ...    financialInfo=${financial_info}
    ...    salesAgentDetails=${sales_agent_details}
    ...    attachments=${attachments}
    ...    additionalData=@{EMPTY}
    
    Log    📝 Asset name shortened to: ${short_asset_name} (${short_asset_name.__len__()} chars)
    Log    📝 Created auction payload: ${auction_payload}
    
    # Execute auction creation API call
    ${response}=    Send POST Request With Global Auth    ${CREATE_AUCTION_ENDPOINT}    ${auction_payload}
    
    # Debug the response if it's not successful
    Run Keyword If    ${response.status_code} != 200    Debug API Request Failure    ${response}    ${CREATE_AUCTION_ENDPOINT}
    
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

Get Auction List With Pagination
    [Documentation]    Get list of auctions with proper response structure parsing
    [Arguments]    ${take_count}=10    ${skip_count}=0
    
    # Build pagination payload
    ${pagination_payload}=    Create Dictionary
    ...    take=${take_count}
    ...    skip=${skip_count}
    ...    filter=${EMPTY}
    ...    sortBy=${EMPTY}
    ...    ascending=${True}
    
    # Execute API call
    ${response}=    Send POST Request With Global Auth    ${GET_AUCTION_LIST_ENDPOINT}    ${pagination_payload}
    ${auction_data}=    Validate And Extract Response Data    ${response}    result
    
    # Parse the nested result structure: result.totalCount and result.items
    ${total_count}=    Get From Dictionary    ${auction_data}[result]    totalCount
    ${items}=    Get From Dictionary    ${auction_data}[result]    items
    
    Log    ✅ Retrieved auction list: ${total_count} total auctions, ${items.__len__()} in this page
    
    # Store for potential use in other tests
    Set Suite Variable    ${AUCTION_LIST_TOTAL}    ${total_count}
    Set Suite Variable    ${AUCTION_LIST_ITEMS}    ${items}
    
    [Return]    ${auction_data}
