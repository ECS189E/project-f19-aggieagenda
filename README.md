# Group 19 Final Project
Trello board: https://trello.com/b/XqyKj05g/final-project

## Team Member:

Yubing Yan(github handler:yyan1998)

Zhiwei Zhang (github handler:jthn46)

Youyuan Xing (github handler:yxingx)

# Project title: aggieCalendar
A calendar that will allow user to get their assignment due using UC-Davis Canvas, also would be able to let user to add event and using count down timer.

# Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

# Prerequisites
You will need the following pod to run the program
 pod 'Firebase/Core'
 pod 'Firebase/Analytics'
 pod 'Firebase/Auth'
 pod 'OAuthSwift', '~> 2.0.0'
 pod 'Firebase/Firestore'
 pod 'Firebase/Database'
 
 # Program flow:
 User would be able to register through email, the app will pop up a Canvas page if user used UC-Davis email. So the user would be able to access their assignment using canvas token and get the due date back to the app. The Canvas page will not show up if user used non-UCD email.
 
 After sucessfully login, user can also add their own events on Calendar. In addition, the app also provides count down timer if user clicked on the event, so the user can set up the timer themself and count it down.
 
