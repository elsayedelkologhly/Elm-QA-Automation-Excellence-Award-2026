*** Settings ***
Resource    ../../Keyword/MobileKeywords/MobileCommonKeyword.robot
Library    AppiumLibrary

*** Keywords ***
Press Skip Welcome screens
        click  btSkip 
GO TO user Profile  
    click   userProfileContainerFragment
    
GO TO Login Page
    click    btnLogin

