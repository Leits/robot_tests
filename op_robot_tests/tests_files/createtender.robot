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

${role}         viewer
${broker}       Quinta

${question_id}  0

*** Test Cases ***
Можливість cтворити однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера),
  ${tender_data}=  Підготовка початкових даних
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  Log  ${TENDER}

Пошук тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Створити артефакт
  [Tags]   ${USERS.users['${viewer}'].broker}: Створення артефакту
  [Documentation]   Створення артефакту з унікальними данними (owner_token, tender_init_data, uid)
  Set To Dictionary  ${TENDER}   TOKEN   ${USERS.users['${tender_owner}'].access_token}
  Set To Dictionary  ${TENDER}   INIT_DATA   ${USERS.users['${tender_owner}'].initial_data}
  ${json}=   dumps   ${TENDER}
  Create File   op_robot_tests/tests_files/tender_owner.json   ${json}