*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         OperatingSystem
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        keywords.robot
Resource        resource.robot
Suite Setup     TestSuiteSetup
Suite Teardown  Close all browsers

*** Variables ***
${mode}         multi
${tender_id}    0

${role}         viewer
${broker}       Quinta

*** Test Cases ***
Пошук тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ${file}=  Get File  op_robot_tests/tests_files/tender_owner.json
  ${tender}=  jsonloads   ${file}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender['INIT_DATA']}
  ${TENDER}=  Create Dictionary
  Set Global Variable  ${TENDER}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${tender['TENDER_UAID']}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${tender['LAST_MODIFICATION_DATE']}

Можливість редагувати багатопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   description     description

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}   Додати предмети закупівлі    ${TENDER['TENDER_UAID']}   3

Можливість видалити позиції закупівлі тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}   Відняти предмети закупівлі   ${TENDER['TENDER_UAID']}   2
