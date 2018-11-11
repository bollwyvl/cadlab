*** Settings ***
Documentation     Try out some browsers with cadlab Notebooks
Test Template     Can cadlab make a Robot Notebook?
Library           SeleniumLibrary
Resource          ../../resources/Launch.robot
Resource          ../../resources/Shell.robot
Resource          ../../resources/Notebook.robot

*** Test Cases ***
Chrome
    headlesschrome

Firefox
    headlessfirefox

*** Keywords ***
Can cadlab make a Robot Notebook?
    [Arguments]    ${browser}
    [Documentation]    Try a basic Robot Notebook
    Set Tags    browser:${browser}
    ${prefix} =    Set Variable    robot_${browser}_
    Open cadlab    ${browser}
    Launch a new    Robot Framework    Notebook
    Capture Page Screenshot    ${prefix}_01_notebook.png
    Add and Run Cell    | *Test Case* |${\n}| Hello |${\n}| | Log | Hello World
    Capture Page Screenshot    ${prefix}_02_execute.png
    Wait Until Kernel Is Idle
    Capture Page Screenshot    ${prefix}_03_execute_result.png
    The Robot Popup Should Contain    ${prefix}    Log    1 passed, 0 failed
    The Robot Popup Should Contain    ${prefix}    Report    All tests passed
    Execute JupyterLab Command    Save Notebook
    Capture Page Screenshot    ${prefix}_09_save.png

The Robot Popup Should Contain
    [Arguments]    ${prefix}    ${document}    ${msg}
    [Documentation]    With an open Robot Notebook, take a look at the log or report
    Click Link    ${document}
    Sleep    1s
    Select Window    Jupyter ${document}
    Page Should Contain    ${msg}
    Capture Page Screenshot    ${prefix}_10_${document.lower()}.png
    Close Window
    Select Window    JupyterLab
