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

Відображення опису позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  description

Відображення дати доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити дату предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryDate.endDate

Відображення координат широти доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryLocation.latitude

Відображення координат довготи доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryLocation.longitude

Відображення назви нас. пункту доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.countryName

Відображення пошт. коду доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.postalCode

Відображення регіону доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.region

Відображення locality адреси доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.locality

Відображення вулиці доставки позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  deliveryAddress.streetAddress

Відображення схеми класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  classification.scheme

Відображення ідентифікатора класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  classification.id

Відображення опису класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  classification.description

Відображення схеми додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  additionalClassifications[0].scheme

Відображення ідентифікатора додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  additionalClassifications[0].id

Відображення опису додаткової класифікації позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  additionalClassifications[0].description

Відображення назви одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  unit.name

Відображення коду одиниці позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  unit.code

Відображення кількості позицій закупівлі багатопредметного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення полів предметів багатопредметного тендера
  Звірити поля предметів закупівлі багатопредметного тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  quantity
