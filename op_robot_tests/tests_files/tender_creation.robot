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
${mode}         without_lots
@{used_roles}   tender_owner  viewer


*** Test Cases ***
Можливість оголосити тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість оголосити тендер


Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість знайти тендер
  ...      viewer  tender_owner
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  Можливість знайти тендер по ідентифікатору


Можливість додати тендерну документацію
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість додати документацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати тендерну документацію


Можливість додати документацію до лоту
  [Tags]    ${USERS.users['${tender_owner}'].broker}: Можливість додати документацію
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість додати документацію до лоту


Можливість добавити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість добавити предмет закупівлі в тендер
  Run Keyword IF  '${mode}'=='with_lots'  Можливість добавити предмет закупівлі в лот

Можливість видалити предмет закупівлі
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість видалити предмет закупівлі з тендера
  Run Keyword IF  '${mode}'=='with_lots'  Можливість видалити предмет закупівлі з лоту

Можливість створення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Setup]  Дочекатись синхронізації з майданчиком    ${tender_owner}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість створення лоту

Можливість видалення лоту
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      lots
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість видалення лоту


*** Keywords ***
#### Tender
Можливість оголосити тендер
  ${tender_data}=  Підготовка даних для створення тендера
  ${adapted_data}=  Адаптувати дані для оголошення тендера  ${tender_owner}  ${tender_data}
  ${TENDER_UAID}=  Run As  ${tender_owner}  Створити тендер  ${adapted_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data=${adapted_data}
  Set To Dictionary  ${TENDER}  TENDER_UAID=${TENDER_UAID}
  Log  ${TENDER}

Можливість знайти тендер по ідентифікатору
  :FOR  ${username}  IN  ${tender_owner}  ${viewer}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

Можливість додати тендерну документацію
  ${filepath}=  create_fake_doc
  ${doc_upload_reply}=  Run As  ${tender_owner}  Завантажити документ  ${filepath}  ${TENDER['TENDER_UAID']}
  ${file_upload_process_data} =  Create Dictionary  filepath=${filepath}  doc_upload_reply=${doc_upload_reply}
  Log  ${file_upload_process_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  file_upload_process_data=${file_upload_process_data}
  Log  ${USERS.users['${tender_owner}']}

Можливість добавити предмет закупівлі в тендер
  ${item}=  Підготовка даних для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі    ${TENDER['TENDER_UAID']}   ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}

Можливість видалити предмет закупівлі з тендера
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}


#### Lots
Можливість додати документацію до лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  ${filepath}=   create_fake_doc
  Run As   ${tender_owner}   Завантажити документ в лот  ${filepath}   ${TENDER['TENDER_UAID']}  ${lot_id}

Можливість добавити предмет закупівлі в лот
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  ${item}=  Підготовка даних для створення предмету закупівлі
  Run As   ${tender_owner}   Додати предмет закупівлі в лот    ${TENDER['TENDER_UAID']}  ${lot_id}   ${item}
  ${item_id}=  get_id_from_object  ${item}
  ${item_data}=  Create Dictionary  item=${item}  item_id=${item_id}
  ${item_data}=  munch_dict  arg=${item_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  item_data=${item_data}

Можливість видалити предмет закупівлі з лоту
  ${lot_id}=  get_id_from_object  ${USERS.users['${tender_owner}'].initial_data.data.lots[0]}
  Run As  ${tender_owner}  Видалити предмет закупівлі  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].item_data.item_id}  ${lot_id}

Можливість створення лоту
  ${lot}=  Підготовка даних для створення лоту
  ${lot_resp}=  Run As   ${tender_owner}  Створити лот  ${TENDER['TENDER_UAID']}  ${lot}
  ${lot_id}=  get_id_from_object  ${lot.data}
  ${lot_data}=  Create Dictionary  lot=${lot}  lot_resp=${lot_resp}  lot_id=${lot_id}
  ${lot_data}=  munch_dict  arg=${lot_data}
  Set To Dictionary  ${USERS.users['${tender_owner}']}  lot_data=${lot_data}
  log  ${lot_resp}

Можливість видалення лоту
  Run As  ${tender_owner}  Видалити лот  ${TENDER['TENDER_UAID']}  ${USERS.users['${tender_owner}'].lot_data.lot_id}