*** Settings ***
Library    AppiumLibrary
Resource   ../common/KeywordsFile.robot
Test Setup  Open app
Test Teardown   Close app

*** Test Cases ***
Test Wiki app
    click on text button
    enter text 1
    validate result 1

*** Keywords ***
Open app
    Open Application    http://127.0.0.1:4723/wd/hub  
    ...  automationName=XCUITest
    ...  platformName=ios  
    ...  platformVersion=16.0 
    ...  app=apps/BStackSampleApp.ipa
    IMPLICIT WAIT    5
