*** Settings ***
Documentation     Check the basics of Robot Lab
Test Template     Does cadlab Load?
Library           SeleniumLibrary
Resource          ../../resources/Shell.robot

*** Test Cases ***
Chrome
    headlesschrome

Firefox
    headlessfirefox

*** Keywords ***
Does cadlab Load?
    [Arguments]    ${browser}
    [Documentation]    Does the Lab launcher show up with a Robot Framework entry?
    Set Tags    browser:${browser}
    Open cadlab    ${browser}
    Page Should Contain    Robot Framework
    Capture Page Screenshot    ${browser}_smoke__00_smoke_test.png
