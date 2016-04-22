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
@{used_roles}   provider  provider1  viewer


*** Test Cases ***
Можливість знайти тендер по ідентифікатору
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість знайти тендер
  ...      viewer
  ...      ${USERS.users['${viewer}'].broker}
  Завантажити дані про тендер
  Можливість знайти тендер по ідентифікатору

Можливість подати цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Setup]  Дочекатись дати початку прийому пропозицій  ${provider}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Run Keyword IF  '${mode}'=='without_lots'  Можливість подати цінову пропозицію на тендер першим учасником
  Run Keyword IF  '${mode}'=='with_lots'  Можливість подати цінову пропозицію на лоти першим учасником

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ...      provider
  ...      ${USERS.users['${provider}'].broker}
  [Teardown]  Оновити LAST_MODIFICATION_DATE
  Можливість скасувати цінову пропозицію


*** Keywords ***
Можливість знайти тендер по ідентифікатору
  :FOR  ${username}  IN  ${provider}  ${provider1}  ${viewer}
  \  Дочекатись синхронізації з майданчиком  ${username}
  \  Run As  ${username}  Пошук тендера по ідентифікатору  ${TENDER['TENDER_UAID']}

Можливість подати цінову пропозицію на тендер першим учасником
  ${bid}=  Підготувати дані для подання пропозиції
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}  bidresponses=${bidresponses}
  ${resp}=  Run As  ${provider}  Подати цінову пропозицію  ${TENDER['TENDER_UAID']}  ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}  resp=${resp}


Можливість подати цінову пропозицію на лоти першим учасником
  @{lots_ids}=  Отримати ідентифікатори об’єктів  ${provider}  lots
  ${number_of_lots}=  Get Length  ${lots_ids}
  ${bid}=  Підготувати дані для подання пропозиції  ${number_of_lots}
  ${bidresponses}=  Create Dictionary  bid=${bid}
  Set To Dictionary  ${USERS.users['${provider}']}   bidresponses=${bidresponses}
  ${resp}=  Run As  ${provider}  Подати цінову пропозицію на лоти  ${TENDER['TENDER_UAID']}  ${bid}  ${lots_ids}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp=${resp}

Можливість скасувати цінову пропозицію
  ${canceledbidresp}=  Run As   ${provider}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Log  ${canceledbidresp}