*** Settings ***
Library         op_robot_tests.tests_files.service_keywords
Library         String
Library         Collections
Library         Selenium2Library
Library         DebugLibrary
Resource        keywords.robot
Resource        resource.robot
Suite Setup     TestSuiteSetup
Suite Teardown  Close all browsers

*** Variables ***
${mode}         single

${role}         viewer
${broker}       Quinta


*** Test Cases ***
Можливість оголосити позапороговий однопредметний тендер
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ...      minimal
  [Documentation]   Створення закупівлі замовником, обовязково має повертати UAID закупівлі (номер тендера)
  ${tender_data}=  Підготовка початкових даних
  ${tender_data}=  test_open_eu_tender_data  ${tender_data}   #!!! eu
  ${TENDER_UAID}=  Викликати для учасника  ${tender_owner}  Створити тендер  ${tender_data}
  ${LAST_MODIFICATION_DATE}=  Get Current TZdate
  Set To Dictionary  ${USERS.users['${tender_owner}']}  initial_data  ${tender_data}
  Set To Dictionary  ${TENDER}   TENDER_UAID             ${TENDER_UAID}
  Set To Dictionary  ${TENDER}   LAST_MODIFICATION_DATE  ${LAST_MODIFICATION_DATE}
  Log  ${TENDER}

Пошук позапорогового однопредметного тендера по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Пошук тендера по ідентифікатору
  ...      viewer  tender_owner  provider  provider1
  ...      ${USERS.users['${viewer}'].broker}  ${USERS.users['${tender_owner}'].broker}
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ...      minimal
  ${usernames}=  Create List  ${viewer}  ${tender_owner}  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника  ${username}  Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}

Відображення типу закупівлі оголошеного тендер
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Звірити поле тендера  ${viewer}  ${USERS.users['${tender_owner}'].initial_data}  procurementMethodType

Відображення початку періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  ${usernames}=  Create List  ${viewer}  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.startDate

Відображення закінчення періоду прийому пропозицій оголошеного тендера
  [Tags]   ${USERS.users['${viewer}'].broker}: Відображення основних даних оголошеного тендера
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  ...      minimal
  ${usernames}=  Create List  ${viewer}  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Звірити дату тендера  ${username}  ${USERS.users['${tender_owner}'].initial_data}  tenderPeriod.endDate

Подати цінову пропозицію першим учасником після оголошення тендеру
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію  ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider}'].bidresponses}

Подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Можливість редагувати однопредметний тендер більше ніж за 7 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   description     description

Перевірити на зміну статус пропозицій після редагування інформації про закупівлю
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider  provider1
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ${usernames}=  Create List  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника   ${username}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  \  ${bid}=  Викликати для учасника  ${username}  Отримати пропозицію  ${TENDER['TENDER_UAID']}
  \  Should Be Equal  ${bid.data.status}  invalid
  \  Log  ${bid}


Оновити статус цінової пропозиції першого учасника
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data}  status   pending  #!!!  pending
  Log   ${USERS.users['${provider}'].bidresponses['resp'].data.status}
  ${activestatusresp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   activestatusresp   ${activestatusresp}
  log  ${activestatusresp}

Cкасувати цінову пропозицію другого учасника
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${bid}=  Get Variable Value  ${USERS.users['${provider1}'].bidresponses['resp']}
  ${bidresponses}=  Викликати для учасника   ${provider1}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}

Повторно подати цінову пропозицію другим учасником після першої зміни
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Неможливість редагувати однопредметний тендер менше ніж за 7 днів до завершення періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  ${no_edit_time}=  get_future_date  ${USERS.users['${tender_owner}'].tender_data.data.tenderPeriod.startDate}  12  #!!!  12
  Дочекатись дати  ${no_edit_time}
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  shouldfail  ${TENDER['TENDER_UAID']}   description     description

Можливість редагувати однопредметний тендер після продовження періоду подання пропозицій
  [Tags]   ${USERS.users['${tender_owner}'].broker}: Можливість оголосити тендер
  ...      tender_owner
  ...      ${USERS.users['${tender_owner}'].broker}
  Викликати для учасника   ${tender_owner}  Внести зміни в тендер  ${TENDER['TENDER_UAID']}   description     description


Перевірити на зміну статус пропозицій після редагування інформації про закупівлю після другої зміни
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider  provider1
  ...      ${USERS.users['${provider}'].broker}  ${USERS.users['${provider1}'].broker}
  ${usernames}=  Create List  ${provider}  ${provider1}
  :FOR  ${username}  IN  @{usernames}
  \  Дочекатись синхронізації з майданчиком    ${username}
  \  Викликати для учасника   ${username}   Пошук тендера по ідентифікатору   ${TENDER['TENDER_UAID']}
  \  ${bid}=  Викликати для учасника  ${username}  Отримати пропозицію  ${TENDER['TENDER_UAID']}
  \  Should Be Equal  ${bid.data.status}  invalid
  \  Log  ${bid}


Можливість оновити статус цінової пропозиції першого учасника після другої зміни
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data}  status   pending   #!!!  pending
  Log   ${USERS.users['${provider}'].bidresponses['resp'].data.status}
  ${activestatusresp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   activestatusresp   ${activestatusresp}
  log  ${activestatusresp}


Повторно подати цінову пропозицію другим учасником після другої зміни
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  ...      provider1
  ...      ${USERS.users['${provider1}'].broker}
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}


####
#  Qualification

