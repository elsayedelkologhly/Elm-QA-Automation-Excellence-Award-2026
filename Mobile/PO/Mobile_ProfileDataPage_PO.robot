*** Settings ***
Resource    ../../Keyword/MobileKeywords/MobileCommonKeyword.robot
Library    AppiumLibrary
***Variables***
${waitingtime}    30s
*** Keywords ***
go To UserInfo Page
    click    tvUserInfo
    Element Should Be Visible    tvFullNameLabel
press delete account button
     click    TVDeleteAccount
press confirm delete account button
    click    buttonDelete
    Wait Until Element Is Visible    btnLogin    ${waitingtime}
