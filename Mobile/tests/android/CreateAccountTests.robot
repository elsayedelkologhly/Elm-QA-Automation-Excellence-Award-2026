*** Settings ***
Documentation    Suite login test cases
Library    AppiumLibrary
Resource    ../../Keywords/MobileCommonKeyword.robot
Resource    ../../PO/Mobile_MainPage_PO.robot
Resource     ../../PO/Mobile_LoginPage_PO.robot
Resource     ../../PO/Mobile_ProfilePage_PO.robot
Resource     ../../PO/Mobile_ProfileDataPage_PO.robot
Resource     ../../PO/Mobile_CreateAccountPage_PO.robot
Suite Setup  Start Android Application
Test Teardown     capture page screenshot
Suite Teardown     End Application

*** Variables ***
${loginidentity}    1234560000
${loginpassword}    1234@Qwe
${BOD}    1446/5/4
${email}    automation_appium@test.sa
${mobile}    55239281294    

*** Test Cases ***

Register As Individual
    [Documentation]          Register As Individual
    [Tags]                 Register As Individual
    Press Skip Welcome screens
    GO TO user Profile
    GO TO Login Page
    go to Create Accont page
    select Register As Individual
    press next button
    Enter Register Identity    ${loginidentity}
    select Hijri date
    Enter Date Of Birth    ${BOD}
    press next button
    enter OTP    123456
    enter Register Email    ${email}
    Enter Register Mobile Number    ${mobile}
    Enter Register Password    ${loginpassword}
    press Register Button
    enter OTP    12345
    verfiy complate Individual register

sigSign Out
    [Documentation]         Sign Out
    [Tags]                  Sign Out
    GO TO user Profile  
    press Sign Out
    confirm Sign Out

login with valid credentials 
    [Documentation]         login with valid credentials
    [Tags]                  login
    GO TO Login Page
    ENTER Login Identity    ${loginidentity}
    ENTER login password    ${loginpassword}
    Click Login Button
    enter OTP    123456
    verfiy loginidentity    محمد
    approve terms and conditions

 delete Account  
    [Documentation]         delete Account 
    [Tags]                  delete
     GO TO user Profile  
    go To My Profile data page
    press delete account button
    press confirm delete account button

