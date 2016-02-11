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
${question_id}    0

${role}         viewer
${broker}       Quinta

*** Test Cases ***
Отримання даних про тендер з артефакту
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Підготовка початкових даних
  ${tender_info}=  get_tender_info_from_artifact  op_robot_tests/tests_files/tender_owner.json
  Log  ${tender_info}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_info['INIT_DATA']}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  access_token  ${tender_info['TOKEN']}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${tender_info['TENDER_UAID']}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${tender_info['LAST_MODIFICATION_DATE']}
  Log  ${TENDER}

Пошук тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${tender_owner}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  Викликати для учасника   ${viewer}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Задати питання
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість задати запитання
  Викликати для учасника   ${provider}   Задати питання  ${TENDER['TENDER_UAID']}   ${QUESTIONS[${question_id}]}
  ${now}=  Get Current TZdate
  Set To Dictionary  ${QUESTIONS[${question_id}].data}   date   ${now}

Відображення заголовку анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Оновити сторінку з тендером    ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${QUESTIONS[${question_id}].data.title}  questions[${question_id}].title

Відображення опису анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити поле тендера із значенням  ${viewer}  ${QUESTIONS[${question_id}].data.description}  questions[${question_id}].description

Відображення дати анонімного питання без відповіді
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення анонімного питання без відповідей
  Звірити дату тендера із значенням  ${viewer}  ${QUESTIONS[${question_id}].data.date}  questions[${question_id}].date

Відповісти на запитання
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість відповісти на запитання
  Викликати для учасника   ${tender_owner}   Відповісти на питання    ${TENDER['TENDER_UAID']}  0  ${ANSWERS[0]}
  ${now}=  Get Current TZdate
  Set To Dictionary  ${ANSWERS[${question_id}].data}   date   ${now}

Відображення відповіді на запитання
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення відповіді на запитання
  Дочекатись синхронізації з майданчиком    ${viewer}
  Викликати для учасника   ${viewer}   Оновити сторінку з тендером   ${TENDER['TENDER_UAID']}
  Звірити поле тендера із значенням  ${viewer}  ${ANSWERS[${question_id}].data.answer}  questions[${question_id}].answer