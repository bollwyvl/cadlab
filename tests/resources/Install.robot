*** Settings ***
Documentation     Install cadlab
Library           OperatingSystem
Library           Process
Library           SeleniumLibrary

*** Variables ***
${INSTALLER VERSION}    0.7.0
${INSTALLER DIR}    ${OUTPUT DIR}${/}..${/}..${/}constructor
${INSTALL LOG}    ${OUTPUT DIR}${/}00_installer.log

*** Keywords ***
Clean up the cadlab installation
    [Documentation]    Clean out the installed cadlab
    Close All Browsers
    Remove Directory    ${cadlab DIR}    recursive=True
    Terminate All Processes
    Sleep    5s
    Terminate All Processes    kill=True

Run the cadlab installer
    [Documentation]    Detect and tag the platform, then run the appropriate installer
    ${path} =    Evaluate    __import__("tempfile").mkdtemp("cadlab")
    ${platform} =    Evaluate    __import__("sys").platform
    Set Tags    os:${platform}
    Set Global Variable    ${PLATFORM}    ${platform}
    Set Global Variable    ${cadlab DIR}    ${path}
    ${result} =    Run Keyword If    "${platform}" == "linux"    Run the cadlab Linux installer
    ...    ELSE IF    "${platform}" == "win32"    Run the cadlab Windows Installer
    ...    ELSE IF    "${platform}" == "darwin"    Run the cadlab OSX Installer
    ...    ELSE    Fatal Error    Can't install on platform ${platform}!
    Should Be Equal as Integers    ${result.rc}    0    msg=Couldn't complete installer, see ${INSTALL LOG}
    File Should Exist    ${ACTIVATE SCRIPT}    msg=Activation script ${ACTIVATE SCRIPT} was not created

Run the cadlab Linux installer
    [Documentation]    Install cadlab on Linux
    ${result} =    Run Process    bash    ${INSTALLER DIR}${/}cadlab-${INSTALLER VERSION}-Linux-x86_64.sh    -fbp    ${cadlab DIR}    stdout=${INSTALL LOG}
    ...    stderr=STDOUT
    Set Global Variable    ${ACTIVATE SCRIPT}    ${cadlab DIR}${/}bin${/}activate
    Set Global Variable    ${ACTIVATE}    set -eux && . "${ACTIVATE SCRIPT}" "${cadlab DIR}"
    [Return]    ${result}

Run the cadlab OSX installer
    [Documentation]    Install cadlab on OSX
    ${result} =    Run Process    bash    ${INSTALLER DIR}${/}cadlab-${INSTALLER VERSION}-MacOSX-x86_64.sh    -fbp    ${cadlab DIR}    stdout=${INSTALL LOG}
    ...    stderr=STDOUT
    Set Global Variable    ${ACTIVATE SCRIPT}    ${cadlab DIR}${/}bin${/}activate
    Set Global Variable    ${ACTIVATE}    set -eux && . "${ACTIVATE SCRIPT}" "${cadlab DIR}"
    [Return]    ${result}

Run the cadlab Windows installer
    [Documentation]    Install cadlab on Windows
    ${installer} =    Set Variable    ${INSTALLER DIR}${/}cadlab-${INSTALLER VERSION}-Windows-x86_64.exe
    ${args} =    Set Variable    /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=${cadlab DIR}
    ${result} =    Run Process    ${installer} ${args}    stdout=${INSTALL LOG}    stderr=STDOUT    shell=True
    Set Global Variable    ${ACTIVATE SCRIPT}    ${cadlab DIR}${/}Scripts${/}activate.bat
    Set Global Variable    ${ACTIVATE}    "${ACTIVATE SCRIPT}" "${cadlab DIR}"
    [Return]    ${result}
