*** Settings ***
Documentation    Simple example
Resource    Resources/keywords.robot

*** Test Cases ***
E2e scenario
    Authorization

    Create booking

    Check if booking is created

    Delete bokking

    Check if booking is deleted