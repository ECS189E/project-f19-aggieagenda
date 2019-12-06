# Group 19 Final Project

Trello board: https://trello.com/b/XqyKj05g/final-project

Link to the project folder: https://github.com/ECS189E/project-f19-helloworld/tree/master/MyCalendar

## Team Member:

Yubing Yan(github handler:yyan1998)

Zhiwei Zhang (github handler:jthn46)

Youyuan Xing (github handler:yxingx)

# Project title: Aggie-genda

A canlendar agenda app for users to add/delete event and use countdown timer to focus, and, especially for UC Davis student users, load the assignments from canvas.

# Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

# Prerequisites
You will need the following pod to run the program\
 pod 'Firebase/Core'\
 pod 'Firebase/Analytics'\
 pod 'Firebase/Auth'\
 pod 'OAuthSwift', '~> 2.0.0'\
 pod 'Firebase/Firestore'\
 pod 'Firebase/Database'
 
 # Program flow:
 User would be able to register through email, the app will pop up a Canvas page if user used UC-Davis email. So the user would be able to access their assignment using canvas token and get the due date back to the app. The Canvas page will not show up if user used non-UCD email.
 
 After sucessfully login, user can also add their own events on Calendar. In addition, the app also provides count down timer if user clicked on the event, so the user can set up the timer themself and count it down.
 
 # Contribution:
 
 Yubing Yan: Api.swift, classes.swift, LoginViewController.swift, CalendarViewController.swift, EventTableViewController,EventViewController.swift, PopupEventViewController.swift,UIButtonExtension.swift
 
 Zhiwei Zhang: Api.swift, classes.swift, LoginViewController.swift, CalendarViewController.swift, EventTableViewController,EventViewController.swift
 
 Youyuan Xing: LoginViewController.swift, CanvasViewController.swift,CanvasTableViewCell.swift
 
 Specifically:
 
 Yubing Yan: Handle Firebase email authentication, make API call to canvas and parse response, design/adjust UI views, switch between sign up and sign in, handle add event feature & load into event list, detail of each event, create count-down timer
 
 Zhiwei Zhang: Handle Firestore, make API call to canvas and parse response, create event cell display, delete/refresh event, activity indicator, auto layout
 
 Youyuan Xing: Handle user sign up, check whether user has UCD email, create get token guide, get&pass user token, redirect to a pop-up Canvas webpage, sign out feature
