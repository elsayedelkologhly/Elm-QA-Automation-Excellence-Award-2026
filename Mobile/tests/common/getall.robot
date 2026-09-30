*** Settings ***
Library           RequestsLibrary
Library           BuiltIn
Library           Collections
Library           JSONLibrary
Resource         ../../../Resources/Keyword/API-Keywords/API-Keywords.robot
Suite Setup     Load API Json From File    getall.json
*** Variables ***

${ENDPOINT}       /api/services/app/mobile/auctions/getall
${causeOrAuctionName}    عقار جديد    

*** Test Cases ***
Should Return Success On Valid Input getall auctions
    
    ${responsebody}    POST API    ${ENDPOINT}        ${body}    200
    dictionary should contain key    ${responsebody}    auctions

should Return Success On search valid 
    ${body0}   Update Value To Json   ${body}    $.causeOrAuctionName   ${causeOrAuctionName}
    ${responsebody}    POST API    ${ENDPOINT}     ${body0}   200
    dictionary should contain key    ${responsebody}    auctions
should Return Success On getall active auctions 
    ${body0}   Update Value To Json   ${body}    $.causeAuctionStatusId  1
    ${responsebody}    POST API    ${ENDPOINT}     ${body0}   200
    dictionary should contain key    ${responsebody}    auctions
should Return Success On getall coming auctions 
    ${body0}   Update Value To Json   ${body}    $.causeAuctionStatusId  2
    ${responsebody}    POST API    ${ENDPOINT}     ${body0}   200
    dictionary should contain key    ${responsebody}    auctions

should Return Success On getall finished auctions 
    ${body0}   Update Value To Json   ${body}    $.causeAuctionStatusId  3
    ${responsebody}    POST API    ${ENDPOINT}     ${body0}   200
    dictionary should contain key    ${responsebody}    auctions

Should Return Success On empty Input
    ${empty}        create dictionary 
     ${responsebody}    POST API    ${ENDPOINT}     ${empty}    400
      #should be equal as strings    ${response_body['errors']['']}   A non-empty request body is required.   
