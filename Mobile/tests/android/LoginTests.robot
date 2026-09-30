
*** Settings ***
Documentation    Suite login test cases
Library    AppiumLibrary
Resource    ../../Resources/PO/MobilePO/Mobile_MainPage_PO.robot
Resource    ../../Resources/PO/MobilePO/Mobile_LoginPage_PO.robot
Resource    ../../Resources/Keyword/MobileKeywords/MobileCommonKeyword.robot
Suite Setup  Start Android Application
Test Teardown     Capture Page Screenshot
Suite Teardown     End Application

*** Variables ***
${loginidentity}    1023254699
${loginpassword}    1234@Qwe

*** Test Cases ***
login with misssing all fields
    [Documentation]         login with misssing all fields 
    [Tags]                  login
    Press Skip Welcome screens
    GO TO user Profile
    GO TO Login Page
    verfiy login buton not enabled
login with missing password
    [Documentation]         login with missing password
    [Tags]                  login
    ENTER Login Identity    ${loginidentity}
    Click Login Button
    verfiy backend error message   عفوا، يجب ان يكون طول كلمة المرور 8 خانات على الأقل وتحتوي على رقم ورمز وحرف كبير و حرف صغير واحد على الأقل

login with missing identity
    [Documentation]         login with missing identity
    [Tags]                  login
    ENTER Login Identity    ${EMPTY}
    ENTER login password    ${loginpassword}
    Click Login Button

login with invalid identity
    [Documentation]         login with invalid identity
    [Tags]                  login
    ENTER Login Identity    523456
    ENTER login password    ${loginpassword}
    Click Login Button

login with invalid credentials
    [Documentation]         login with invalid credentials
    [Tags]                  login
    ENTER Login Identity    1234567590
    ENTER login password    1234111
    Click Login Button
login with valid credentials
    [Documentation]         login with valid credentials
    [Tags]                  login
    ENTER Login Identity    ${loginidentity}
    ENTER login password    ${loginpassword}
    Click Login Button
