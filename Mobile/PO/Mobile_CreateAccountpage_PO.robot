*** Settings ***
Resource    ../Keywords/MobileCommonKeyword.robot
Library    AppiumLibrary
***Variables***
${waitingtime}    30s
*** Keywords ***
select Register As Individual
    click    tvRegisterAsIndividual
select Register As Company
    click    tvRegisterAsCompany
Enter Register Identity
    [Arguments]    ${text}
    Input    etRegisterIdentity    ${text}
Enter Date Of Birth 
    [Arguments]    ${text}
    #Input    etFstDateOfBirth    ${text}
    click    etFstDateOfBirth
    click    //*[@index='6']
    click    mdtp_ok
select Hijri date
    click    rbFstHijriOption
select Gregorian date
    click    rbFstGeorgianOption
enter Register Email
    [Arguments]    ${text}
    Input    etUserEmailAddress    ${text}
Enter Register Mobile Number
    [Arguments]    ${text}
    Input  etUserPhoneNumber    ${text}
Enter Register Password
    [Arguments]    ${text}
    Input    etLoginPass   ${text}

press Register Button
    click   btnCreateAccount
verfiy complate Individual register
    Wait Until Element Is Visible     tvUserName    ${waitingtime}
    Element Should Be Visible    btVerifyEmail
    Element Should Be Visible    ivMyProfile
    Element Should Be Visible    tvSignOut
