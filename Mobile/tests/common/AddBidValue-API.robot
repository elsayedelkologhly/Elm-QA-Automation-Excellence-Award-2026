*** Settings ***
Library           RequestsLibrary
Library           Collections
Resource         ../../../Keyword/API-Keywords.robot
Suite Setup     Load API Json From File    login.json
*** Variables ***
${ENDPOINT}       /api/services/app/mobile/AddBidValue
${DATA_VALID}     {  auctionId=12345  bidValue=10000  }
${DATA_INVALID}   {  auctionId=12345  bidValue=-10000  }
*** Test Cases ***
login as bider
    Get TokenAuth    1023254699    1234@Qwe

Add bid value with valid data
    ${responsebody}    POST API     ${ENDPOINT}         ${DATA_VALID}   200
    dictionary should contain key    ${responsebody}    result
    dictionary should contain key    ${responsebody}    targetUrl
    dictionary should contain key    ${responsebody}    success
    dictionary should contain key    ${responsebody}    error
    dictionary should contain key    ${responsebody}    unAuthorizedRequest

