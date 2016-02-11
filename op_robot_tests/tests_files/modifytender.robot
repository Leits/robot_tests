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
Отримання даних про тендер з артефакту
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ${tender_info}=  get_tender_info_from_artifact  op_robot_tests/tests_files/tender_owner.json
  Log  ${tender_info}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_info['INIT_DATA']}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  access_token  ${tender_info['TOKEN']}
  ${TENDER}=  Create Dictionary
  Set Global Variable  ${TENDER}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${tender_info['TENDER_UAID']}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${tender_info['LAST_MODIFICATION_DATE']}
  Log  ${TENDER}

Пошук тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Можливість редагувати багатопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер    ${TENDER['TENDER_UAID']}   description     description

Можливість додати позицію закупівлі в тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  Викликати для учасника   ${tender_owner}   Додати предмети закупівлі    ${TENDER['TENDER_UAID']}   3

Можливість видалити позиції закупівлі тендера
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ${tender1}=   Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  Log  ${tender1}
  Викликати для учасника   ${tender_owner}   Відняти предмети закупівлі   ${TENDER['TENDER_UAID']}   2
