## Milestone 1

### What is our App? Why should it exist?

In general, we are creating a calendar App following a minimalism style with main features of events/tasks reminder and notebook. Although there are many calendar/planner apps in the market, most of them are too complicated to use and not clear enough. Thus, we aimed at directly displaying the list of plans/notes on each day of the caledar when user clicks in. When thinking about the incentives of using a calendar, we feel that people mostly want to know what important events or tasks they 
will have on a day. For add-on features, people might also want to write diaries to record their life in a day and easily look 
back whenever they feel like to.

### Design of our App:

See the mockup from the link: https://github.com/ECS189E/project-f19-helloworld/blob/master/Mockup%20Version1.pdf

### List of third party libraries: 

LocalAuthentication (Possibly consider adding FaceID and Touch ID)

LAcontext

### Server support for app:

Firebase for email verification

### List of ViewController will be implemented:

LoginViewController: containing two options for users to choose. "Sign In" for existed users and "New User" for new user to sign up.

SignInViewController: User inputs email there and got the password verified to enter the home view.

SignUpViewController: User inputs emial address and sets password. An verification email will be sent to the mailbox for the user to verify. Once verified, proceed to the home view.

CalendarViewController: Upper half contains a full calendar that can be clicked on each day. Lower half contains the list of events/tasks and notebook (diary) for one day. An "Add" button on the upper right corner.

AddEventViewController: Allow users to add new events or tasks for reminder.

WriteNoteViewController: Allow users to either write a diary for the day or sent a letter to a day in the future.

Planning to use Segue to Navigate between different View Controllers.

### List of week long tasks and timeline:

Nov.15: Finalize the UI (As a group).

Nov.18: Login View Controller (Youyuan), SignIn View Controller (Zhiwei), Sign Up View Controller (Yubing).

Nov.20: Calendar View Controller (As a group).

Nov.25: AddEvent View Controller (Youyuan, Zhiwei) WriteNoteViewController (Yubing).


### Test plan:

Planing to ask friends in class to test program after finish each viewController since each part of the viewController has different functionality. By given them a satisfaction scale to try to meet the needs of the users for UI design and functionality. 

Potential questions for users: 

1. How easy was it to signup and sign in?
2. How easy was it to add a new event?
3. Does the screen look clear enough to display important information?
