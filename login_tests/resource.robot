*** Settings ***
Documentation     A resource file with reusable keywords and variables.
Library           SeleniumLibrary
Library           OperatingSystem
Library           Collections
Library           ../chrome_options.py    # Import the custom options script

*** Variables ***
${SERVER}         0.0.0.0:7272
${BROWSER}        chrome
${DELAY}          0
${VALID_USER}     demo
${VALID_PASSWORD}    mode
${LOGIN_URL}      http://${SERVER}/
${WELCOME_URL}    http://${SERVER}/welcome.html
${ERROR_URL}      http://${SERVER}/error.html
${CHROME_OPTIONS}  --headless;--no-sandbox;--disable-dev-shm-usage

*** Keywords ***
Open Browser To Login Page
    ${chrome_options} =  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method  ${chrome_options}  add_argument  --headless
    Call Method  ${chrome_options}  add_argument  --no-sandbox
    Call Method  ${chrome_options}  add_argument  --disable-dev-shm-usage
    Open Browser    ${LOGIN_URL}    ${BROWSER}  options=${chrome_options}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Login Page Should Be Open

Login Page Should Be Open
    Title Should Be    Login Page

Go To Login Page
    Go To    ${LOGIN_URL}
    Login Page Should Be Open

Input Username
    [Arguments]    ${username}
    Input Text    id=username_field    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    id=password_field    ${password}

Submit Credentials
    Click Button    id=login_button

Welcome Page Should Be Open
    Location Should Be    ${WELCOME_URL}
    Title Should Be    Welcome Page