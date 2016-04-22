*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        keywords.robot
Resource        resource.robot
Suite Setup     Test Suite Setup
Suite Teardown  Test Suite Teardown


*** Variables ***
${mode}         single
@{used_roles}   tender_owner  provider  viewer


*** Test Cases ***

Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість знайти тендер
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Завантажити дані про тендер
  Можливість знайти тендер по ідентифікатору

Можливість задати питання на тендер
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Дочекатись синхронізації з майданчиком  ${provider}
  Можливість задати питання на тендер


Можливість відповісти на запитання на тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Setup]  Дочекатись синхронізації з майданчиком  ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання

Можливість задати питання до лоту
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ...      lots
  [Setup]  Дочекатись синхронізації з майданчиком    ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість задати питання до лоту


Можливість відповісти на запитання до лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість відповісти на запитання


*** Keywords ***
Можливість знайти тендер по ідентифікатору
  :FOR  ${username}  IN  ${tender_owner}  ${provider}  ${viewer}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

Можливість задати питання на тендер
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Run As  ${provider}  Задати питання  ${TENDER['TENDER_UAID']}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
  Set To Dictionary  ${USERS.users['${provider}']}  question_data=${question_data}

Можливість відповісти на запитання
  ${answer}=  Підготовка даних для відповіді на запитання
  ${answer_resp}=  Run As  ${tender_owner}
  ...      Відповісти на питання  ${TENDER['TENDER_UAID']}
  ...      ${USERS.users['${provider}']['question_data']['question_resp']}  ${answer}
  ...      question_id=${USERS.users['${provider}'].question_data.question_id}
  ${now}=  Get Current TZdate
  ${answer.data.date}=  Set variable  ${now}
  ${answer_data}=  Create Dictionary  answer=${answer}  answer_resp=${answer_resp}
  Set To Dictionary  ${USERS.users['${provider}']}  answer_data=${answer_data}

Можливість задати питання до лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].tender_data.data.lots[0]}
  ${question}=  Підготовка даних для запитання
  ${question_resp}=  Run As   ${provider}   Задати питання до лоту  ${TENDER['TENDER_UAID']}  ${lot_id}  ${question}
  ${now}=  Get Current TZdate
  ${question.data.date}=  Set variable  ${now}
  ${question_id}=  get_id_from_object  ${question.data}
  ${question_data}=  Create Dictionary  question=${question}  question_resp=${question_resp}  question_id=${question_id}
  ${question_data}=  munch_dict  arg=${question_data}
