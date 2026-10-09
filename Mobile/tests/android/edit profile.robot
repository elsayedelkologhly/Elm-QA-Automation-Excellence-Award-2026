*** Settings ***
Documentation    Suite login test cases
Library    AppiumLibrary
Resource    ../../PO/Mobile_MainPage_PO.robot
Resource    ../../PO/Mobile_LoginPage_PO.robot
Resource    ../../PO/Mobile_ProfilePage_PO.robot
Resource    ../../PO/Mobile_ProfileDataPage_PO.robot
Resource    ../../PO/Mobile_UserInfoPage_PO.robot
Resource    ../../Keywords/MobileCommonKeyword.robot
Suite Setup  Start Android Application
Suite Teardown     End Application

*** Variables ***
${loginidentity}    1023254699
${loginpassword}    1234@Qwe

*** Test Cases ***
login with valid credentials
    [Documentation]         login with valid credentials
    [Tags]                  login
    Press Skip Welcome screens
    GO TO user Profile
    GO TO Login Page
    ENTER Login Identity    ${loginidentity}
    ENTER login password    ${loginpassword}
    Click Login Button
    enter OTP    123456
    verfiy loginidentity    محمد
verfiy personal user data  
    [Documentation]         personal user data  
    [Tags]                  personal user data  
    GO TO user Profile 
    go To My Profile Data Page
    go To UserInfo Page
    verfiy retrived FullName    محمد محمد محمد محمد
    verfiy retrived Email    mm1m11@mss.com
    verfiy retrived IdentityNumber    1023254699    
    verfiy retrived Mobile    5125 672 01
    verfiy retrived BirthDate    ٠٢ يونيو ١٩٧٧
      
