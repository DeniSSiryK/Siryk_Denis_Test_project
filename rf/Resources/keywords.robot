*** Settings ***
Library    JSONLibrary
Library    os
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}     https://restful-booker.herokuapp.com
${AUTHORIZATION}     /auth
${CREATE_BOOKING}    /booking

*** Keywords ***
Authorization
    create session    test_session      ${BASE_URL}
    ${REQUEST_BODY}     load json from file    Resources/AUTHORIZATION.json
    ${HEADER}       load json from file    Resources/headers.json
    ${RESPONSE}     post on session     test_session    ${AUTHORIZATION}     json=${REQUEST_BODY}    headers=${HEADER}
    ${TOKEN}    get value from json    ${RESPONSE.json()}   $.token
    set test variable    ${TOKEN}

    ${STATUS_CODE}  convert to string    ${RESPONSE.status_code}
    should be equal    ${STATUS_CODE}   200

Create booking
    ${REQUEST_BODY}     load json from file    Resources/CREATE_BOOKING.json
    ${HEADER}       load json from file    Resources/headers.json
    ${RESPONSE}     post on session     test_session    ${CREATE_BOOKING}     json=${REQUEST_BODY}    headers=${HEADER}
    ${BOOKING_ID}   get value from json    ${RESPONSE.json()}   $.bookingid
    ${BOOKING_ID_STR}   convert to string    ${BOOKING_ID}[0]
    set test variable    ${BOOKING_ID_STR}
    ${DEPOSIT_PAID}  get value from json    ${RESPONSE.json()}   $.booking.depositpaid
    should be true    ${DEPOSIT_PAID}[0]

Check if booking is created
    ${RESPONSE}     get on session    test_session      ${CREATE_BOOKING}/${BOOKING_ID_STR}
    ${FIRSTNAME}    get value from json    ${RESPONSE.json()}   $.firstname
    should be equal    ${FIRSTNAME}[0]      Jim

Delete bokking
    ${TOKEN_VALUE}  get from list    ${TOKEN}   0
    ${TOKEN_HEADER}     create dictionary   content-type    application/json    Cookie=token=${TOKEN_VALUE}
    ${RESPONSE}     delete on session    test_session    ${CREATE_BOOKING}/${BOOKING_ID_STR}     headers=${TOKEN_HEADER}
    ${STATUS_CODE}  convert to string    ${RESPONSE.status_code}
    should be equal    ${STATUS_CODE}   201

Check if booking is deleted
    ${RESPONSE}     get on session    test_session      ${CREATE_BOOKING}/${BOOKING_ID_STR}     expected_status=any
    ${STATUS_CODE}    convert to string    ${RESPONSE.status_code}
    should be equal    ${STATUS_CODE}      404