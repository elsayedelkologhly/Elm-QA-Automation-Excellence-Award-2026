*** Settings ***
Library     robot.libraries.DateTime
Library      Collections
Library    AppiumLibrary
Variables  ../../../Resources/Project_Configration/Test_Configration.yaml



*** Variables ***
${waitingtime}    30s
${REMOTE_URL}                 http://127.0.0.1:4723/wd/hub
${PLATFORM_NAME}              Android
#${UDID}                       R52N91EXAAH
#${UDID}                        RZCWB0ER5TT
${UDID}                        emulator-5554
#${deviceName}                 SM-T875
${deviceName}                 sdk_gphone64_x86_64
${APP_PACKAGE}                sa.thiqah.emazad
${APP_ACTIVITY}               .app.intro.view.activity.ConfigActivity
${app}                        ${CURDIR}/../../../Resources/Project_Configration/emazad.apk

*** Keywords ***
Start Android Application
    [Arguments]    ${automationName}=UiAutomator2  ${platformVersion}=14
    Open Application    ${REMOTE_URL}   automationName=${automationName}    deviceName=${deviceName}    platformVersion=${platformVersion}    platformName=${PLATFORM_NAME}      appPackage=${APP_PACKAGE}    appActivity=${APP_ACTIVITY}    udid=${UDID}   autoGrantPermissions=true 
    Wait Activity    ${APP_ACTIVITY}     timeout=10
End Application
    Close Application
press next button
    click    //*[@text='التالي']
press back button
    click    //*[@text='السابق']
enter OTP
    [Arguments]    ${OTP}
    Input     pvOtpInput    ${OTP}
    Wait Until Page Does Not Contain Element   background   ${waitingtime}
click
    [Arguments]    ${element}        
    Wait Until Element Is Visible    ${element}    ${waitingtime}
    Click Element    ${element}  
    capture page screenshot
Input
    [Arguments]    ${element}    ${text}       
    Wait Until Element Is Visible    ${element}    ${waitingtime}
    Input Text    ${element}    ${text}
verfiy backend error message
    [Arguments]    ${message}
    Page Should Contain Text   ${message}
   
verfiy Content of Element
    [Arguments]    ${element}    ${expected}
    Wait Until Page Contains Element    ${element}
    ${actual}=    Get Text    ${element}
    Should Be Equal As Strings    ${actual}    ${expected}