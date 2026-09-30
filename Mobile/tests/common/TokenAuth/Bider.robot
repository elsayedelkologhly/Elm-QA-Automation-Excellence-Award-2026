*** Settings ***
Library           RequestsLibrary
Library    Collections
Resource    ../../../../Resources/Keyword/API-Keywords/API-Keywords.robot
Suite Setup     Load API Json From File    login.json
*** Variables ***
#${login DATA_VALID}  { otpCode= 0000   userNameOrEmailAddress= 2375173941    password= 123123qwe    referenceNumber= ''}
${ENDPOINT}       /api/TokenAuth/VerifyMobileOtp

*** Test Cases ***
Should Return Success On Valid Input
    ${responsebody}    POST API     /api/TokenAuth/VerifyMobileOtp        ${body}    200  
    Dictionary Should Contain Key    ${responsebody}    accessToken
    dictionary should contain key    ${responsebody}    refreshToken
    ${accessToken} =    Get Value From Json    ${responsebody}    accessToken   
