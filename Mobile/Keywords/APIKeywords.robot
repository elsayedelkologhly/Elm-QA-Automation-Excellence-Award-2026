*** Settings ***
Documentation     Common API keywords for auction tests
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library           String
Library           BuiltIn

*** Keywords ***
Create API Headers
    [Arguments]    ${auth_token}=${EMPTY}
    ${headers}=    Create Dictionary    
    ...    .AspNetCore.Culture=ar
    ...    Abp.TenantId=2184
    ...    Accept=application/json
    ...    Accept-Language=ar
    ...    Cache-Control=no-cache
    ...    Connection=keep-alive
    ...    Content-Type=application/json
    ...    Expires=Sat, 01 Jan 2000 00:00:00 GMT
    ...    Origin=https://admink8s-staging.emazad.sa
    ...    Pragma=no-cache
    ...    Referer=https://admink8s-staging.emazad.sa/
    ...    Sec-Fetch-Dest=empty
    ...    Sec-Fetch-Mode=cors
    ...    Sec-Fetch-Site=same-site
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36
    ...    X-Requested-With=XMLHttpRequest
    ...    sec-ch-ua="Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"
    ...    sec-ch-ua-mobile=?0
    ...    sec-ch-ua-platform="Windows"
    
    # Add authorization token if provided
    Run Keyword If    '${auth_token}' != '${EMPTY}'    Set To Dictionary    ${headers}    Authorization=${auth_token}
    
    [Return]    ${headers}

Send API Request
    [Arguments]    ${session}    ${method}    ${endpoint}    ${headers}    ${data}=${None}
    ${response}=    Run Keyword If    '${method}' == 'POST'
    ...    POST On Session    ${session}    ${endpoint}    headers=${headers}    json=${data}
    ...    ELSE IF    '${method}' == 'GET'
    ...    GET On Session    ${session}    ${endpoint}    headers=${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    [Return]    ${json}

Validate Response Status
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    success
    Should Be Equal    ${response["success"]}    ${TRUE}

Get Standard Login Captcha
    ${captcha_data}=    Create Dictionary
    ...    captcha=12345
    ...    captchaToken=1144616e-6b34-41a1-bd42-a3178bdd5057
    [Return]    ${captcha_data}
    
Create Login Data
    [Arguments]    ${username}    ${password}
    ${captcha_data}=    Get Standard Login Captcha
    ${data}=    Create Dictionary
    ...    userNameOrEmailAddress=${username}
    ...    password=${password}
    ...    rememberClient=${FALSE}
    ...    twoFactorRememberClientToken=${NONE}
    ...    singleSignIn=${FALSE}
    ...    returnUrl=${NONE}
    ...    captchaData=${captcha_data}
    [Return]    ${data}
