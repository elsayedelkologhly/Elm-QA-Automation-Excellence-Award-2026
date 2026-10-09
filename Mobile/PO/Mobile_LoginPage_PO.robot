*** Settings ***
Resource    ../Keywords/MobileCommonKeyword.robot
Library    AppiumLibrary
***Variables***
${waitingtime}    30s
*** Keywords ***
ENTER Login Identity
    [Arguments]    ${LoginIdentity}
    Input   etLoginIdentity    ${LoginIdentity}
ENTER login password
    [Arguments]    ${LoginPass}
    Input     etLoginPass    ${LoginPass}
Click Login Button
    click    btLogin
verfiy login buton not enabled
    Element Should Be Disabled    btLogin

verfiy loginidentity
    [Arguments]    ${loginidentity}
   verfiy Content of Element    tvUserName    ${loginidentity}

 show password_field
    click    text_input_end_icon
go TO forgot password page
    click   tvLoginForgotPass
    Element Should Be Visible    tvForgetPasswordTitle
go to Create Accont page
    click   tvLoginCreateAcc

approve terms and conditions
    click    //*[@id='tvTermsConditionsAccept']
    Wait Until Page Does Not Contain Element   background   ${waitingtime}

