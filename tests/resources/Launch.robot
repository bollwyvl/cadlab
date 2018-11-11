*** Settings ***
Documentation     Work with the cadlab server
Library           OperatingSystem
Library           Process
Library           String

*** Variables ***
${LAB LOG}        ${OUTPUT DIR}${/}01_lab.log
${LAB HOST}       http://127.0.0.1
${LAB PORT}       18888

*** Keywords ***
Launch cadlab Server
    [Documentation]    Try to start the cadlab server
    Should Not Be Empty    ${PLATFORM}    msg=Needs a detected platform/OS
    Should Not Be Empty    ${cadlab DIR}    msg=Needs a cadlab installation
    Should Not Be Empty    ${ACTIVATE}    msg=Needs an activate-able environment
    Initialize cadlab Settings
    Create Directory    ${LAB HOME}
    Start Process    ${ACTIVATE} && ${LAB COMMAND}    stdout=${LAB LOG}    stderr=STDOUT    shell=True

Initialize cadlab Settings
    [Documentation]    Configure runtime settings for cadlab
    ${token} =    Generate Random String    length=64
    Set Global Variable    ${LAB TOKEN}    ${token}
    Set Global Variable    ${LAB URL}    ${LAB HOST}:${LAB PORT}/lab?token=${token}
    Set Global Variable    ${LAB HOME}    ${OUTPUT_DIR}${/}notebooks
    Set Global Variable    ${LAB COMMAND}    cadlab --no-browser --debug --NotebookApp.token=${token} --port=${LAB PORT} --notebook-dir="${LAB HOME}"

Clean the cadlab notebook folder
    [Documentation]    Clean out the cadlab notebook folder (might be a bad idea)
    Remove Directory    ${LAB HOME}    recursive=True
    Wait Until Removed    ${LAB HOME}
    Create Directory    ${LAB HOME}
