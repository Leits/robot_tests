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
${question_id}  0

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

Подати цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  ${tender_data}=  Get Variable Value  ${USERS.users['${tender_owner}'].tender_data}
  Дочекатись дати початку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${biddingresponse0}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set Global Variable   ${biddingresponse0}
  log  ${biddingresponse0}

Можливість скасувати цінову пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість скасувати цінову пропозицію
  ${biddingresponse_0}=  Викликати для учасника   ${provider}   Скасувати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${biddingresponse0}

Подати повторно цінову пропозицію першим учасником
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${resp}=  Викликати для учасника   ${provider}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   resp   ${resp}
  log  ${resp}
  log  ${USERS.users['${provider}'].bidresponses}

Можливість змінити повторну цінову пропозицію до 50000
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data.value}  amount   50000
  Log   ${USERS.users['${provider}'].bidresponses['resp'].data.value}
  ${fixbidto50000resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidto50000resp   ${fixbidto50000resp}
  log  ${fixbidto50000resp}

Можливість змінити повторну цінову пропозицію до 10
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість змінити цінову пропозицію
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses['resp'].data.value}  amount   10
  Log   ${USERS.users['${provider}'].bidresponses['fixbidto50000resp'].data.value}
  ${fixbidto10resp}=  Викликати для учасника   ${provider}   Змінити цінову пропозицію   ${TENDER['TENDER_UAID']}   ${USERS.users['${provider}'].bidresponses['resp']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   fixbidto10resp   ${fixbidto10resp}
  log  ${fixbidto10resp}

Завантажити документ першим учасником в повторну пропозицію
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника   ${provider}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_upload   ${bid_doc_upload}

Порівняти документ
  [Tags]   ${USERS.users['${provider}'].broker}: Порівняти документ
  ${url}=      Get Variable Value   ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.url}
  ${doc}  ${flnnm}=   Викликати для учасника   ${provider}  Отримати документ   ${TENDER['TENDER_UAID']}  ${url}
  ${flpth}=  Get Variable Value   ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.title}
  ${flcntnt} =  get file contents  ${flpth}
  log  ${flcntnt}
  log  ${flpth}
  log  ${doc}
  log  ${flnnm}

  Should Be Equal  ${flcntnt}   ${doc}
  Should Be Equal  ${flpth}   ${flnnm}

Можливість змінити документацію цінової пропозиції
  [Tags]   ${USERS.users['${provider}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider}'].broker}
  ${filepath}=   create_fake_doc
  ${bidid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['resp'].data.id}
  ${docid}=  Get Variable Value  ${USERS.users['${provider}'].bidresponses['bid_doc_upload']['upload_response'].data.id}
  ${bid_doc_modified}=  Викликати для учасника   ${provider}   Змінити документ в ставці  ${filepath}  ${bidid}  ${docid}
  Set To Dictionary  ${USERS.users['${provider}'].bidresponses}   bid_doc_modified   ${bid_doc_modified}

Подати цінову пропозицію другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість подати цінову пропозицію
  Дочекатись дати початку прийому пропозицій
  ${bid}=  test bid data
  Log  ${bid}
  ${bidresponses}=  Create Dictionary
  ${resp}=  Викликати для учасника   ${provider1}   Подати цінову пропозицію   ${TENDER['TENDER_UAID']}   ${bid}
  Set To Dictionary  ${bidresponses}                 resp  ${resp}
  Set To Dictionary  ${USERS.users['${provider1}']}   bidresponses  ${bidresponses}
  log  ${resp}
  log  ${USERS.users['${provider1}'].bidresponses}

Неможливість побачити цінові пропозиції учасників під час прийому пропозицій
  [Tags]   ${USERS.users['${viewer}'].broker}: Можливість подати цінову пропозицію
  ${bids}=  Викликати для учасника  ${viewer}  Отримати інформацію із тендера  bids
  ${bool}=  Convert To Boolean  ${bids}
  Should Be Equal  ${bool}  ${False}

Завантажити документ другим учасником
  [Tags]   ${USERS.users['${provider1}'].broker}: Можливість прийняти пропозицію переможця
  log   ${USERS.users['${provider1}'].broker}
  ${filepath}=   create_fake_doc
  ${bid_doc_upload}=  Викликати для учасника   ${provider1}   Завантажити документ в ставку  ${filepath}   ${TENDER['TENDER_UAID']}
  Set To Dictionary  ${USERS.users['${provider1}'].bidresponses}   bid_doc_upload   ${bid_doc_upload}
