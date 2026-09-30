*** Settings ***
Resource    ../../Keyword/MobileKeywords/MobileCommonKeyword.robot
Library    AppiumLibrary
***Variables***
${waitingtime}    30s
*** Keywords ***
go To My Profile Data Page
    click    tvMyProfile

press Sign Out
    click    tvSignOut
confirm Sign Out
    click    buttonLogout
    Wait Until Page Does Not Contain Element   background   ${waitingtime}
    Wait Until Element Is Visible    btnLogin    ${waitingtime}
