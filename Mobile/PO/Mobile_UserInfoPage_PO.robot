*** Settings ***
Resource    ../Keywords/MobileCommonKeyword.robot
Library    AppiumLibrary
***Variables***
${waitingtime}    30s
*** Keywords ***
verfiy retrived FullName
    [Arguments]    ${FullName}
    verfiy Content of Element   tvFullNameLabel       الاسم بالكامل
    verfiy Content of Element   tvFullNameValue       ${FullName}

verfiy retrived Email
    [Arguments]    ${email}
    verfiy Content of Element   tvEmailLabel      البريد الإلكترونى
    verfiy Content of Element   tvEmailValue       ${email}
verfiy retrived IdentityNumber
    [Arguments]    ${IdentityNumber}
    verfiy Content of Element   tvIdentityNumberLabel    رقم الهوية
    verfiy Content of Element   tvNationalIDValue       ${IdentityNumber}
verfiy retrived Mobile
    [Arguments]    ${mobile}
    verfiy Content of Element   tvMobileNumberLabel     رقم الجوال
    verfiy Content of Element   tvMobileNumberValue       ${mobile}

verfiy retrived BirthDate
    [Arguments]    ${BirthDate}
    verfiy Content of Element   tvBirthDateLabel     تاريخ الميلاد
    verfiy Content of Element   tvBirthDateValue       ${BirthDate}