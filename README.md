<img src="./readme/title1.svg"/>
<br><br> 

<img src="./readme/title7.svg"/> 

- [Project Philosophy](#project-description)
- [User Types](#user-types)
- [Prototyping](#prototyping)
- [Tech Stack](#tech-stack)
  - [Frontend](#Frontend)
  - [Backend](#Backend)
- [Demo](#Demo)
- [How to Run](#how-to-run)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)


<br><br>

<!-- Project Description -->
<a name="project-description"></a>
<img src="./readme/title2.svg"/> 
> The goal of the InvestorConnect project is to create a comprehensive platform that leverages various technologies to facilitate efficient connections between investors and startups.
<br>


InvestorConnect aims to revolutionize the process of connecting investors with promising startups efficiently. This platform harnesses cutting-edge technology and AI-driven algorithms to streamline the investment experience. By collecting and analyzing critical data from startup and investor profiles, the app facilitates meaningful connections and fosters collaboration in the world of entrepreneurship.


In addition to its core matchmaking functionality, InvestorConnect provides unique features that encourage networking, collaboration, and streamlined communication among users. Users can engage in meaningful conversations through the built-in messaging system, fostering connections and partnerships within the entrepreneurial community. Additionally, the platform allows users to schedule and manage meetings seamlessly, enhancing the efficiency of their interactions and collaboration efforts. 

Finally, the app provides a comprehensive dashboard with analytics to monitor user activity and engagement, allowing admins to make data-driven decisions to improve the platform's performance.

<br>

<!-- User Types -->
<a name="user-types"></a>
<img src="./readme/title8.svg"/>

> InvestorConnect caters to three main user types: investors, startups, and admins. Each user type has a unique set of features and capabilities within the platform. Below, we provide an overview of the core features available to each user type.

1. Investor
2. Startup
3. Admin

<br>

### Investor User Stories

- As an investor, I want to use the swipe feature to quickly browse through startup profiles, optimizing my investment search process.
- As an investor, I want to express my interest in startups, so I can initiate contact and explore collaborations.
- As an investor, I want to receive notifications about matched startups and new investment opportunities.
- As an investor, I want to schedule meetings with startups, syncing them with my calendar for efficient communication.
- As an investor, I want to receive AI-generated recommendations based on my investment preferences, streamlining the matching process.
### Startup User Stories

- As a startup, I want to create an appealing profile, showcasing my venture's potential.
- As a startup, I want to receive notifications when investors express interest in my project.
- As a startup, I want to provide additional information and answer investor inquiries to facilitate the investment process.
- As a startup, I want to schedule meetings with potential investors and sync them with my calendar for efficient coordination.
- As a startup, I want to receive AI-generated recommendations on investors who align with my venture's goals, simplifying the matching process.

### Admin User Stories
- As an admin, I want to access a dashboard with analytics to monitor user activity and engagement.
- As an admin, I want to gather insights into the platform's performance to make data-driven decisions.

<br><br>

<!-- Prototyping -->
<a name="prototyping"></a>
<img src="./readme/title3.svg"/>

> Our design process for InvestorConnect involved creating wireframes and mockups. We iterated on the design to ensure a user-friendly layout and a seamless experience throughout the platform.

### Mockups

| Landing screen                                | Signup screen                             | Login screen                               | Usertype Selection screen                               |
| -------------------------------------------- | ------------------------------------------ | ------------------------------------------ | ----------------------------------------------- |
| ![Landing](/readme/mockups/landing.png)       | ![Signup](/readme/mockups/signup.png)    | ![Login](/readme/mockups/login.png)       | ![Usertype Selection](/readme/mockups/usertype-selection.png) |
| Home screen                                   | Chats Screen                               | Messages Screen                            | Notifications Screen                          |
| ![Home](/readme/mockups/home.png)             | ![Chats](/readme/mockups/chats.png)        | ![Messages](/readme/mockups/messages.png) | ![Notifications](/readme/mockups/notifications.png)   |

<br><br>

<!-- Tech stack -->
<a name="tech-stack" ></a>
<img src="./readme/title4.svg"/>
> The InvestorConnect app relies on a robust technology stack to drive its advanced matchmaking platform. Below, we provide an in-depth breakdown of the core technologies powering this solution, with an emphasis on the unique role of OpenAI in enhancing user experience.

## Mobile App (Frontend)
<a name="Frontend"></a>
- **Flutter:** InvestorConnect's mobile app is developed using Flutter, a versatile and efficient framework for cross-platform mobile application development. It enables a seamless and responsive user interface.
- **Dart:** Dart serves as the programming language for coding the app's frontend, allowing for efficient development and high-performance user interactions.

## Web App (Admin Dashboard)
<a name="Web App"></a>
- **Angular:** The admin dashboard of InvestorConnect is built using Angular, a popular framework for developing dynamic web applications. Angular ensures a responsive and feature-rich admin interface.

## Backend (Server)
<a name="Backend"></a>
- **Laravel:** The backend of InvestorConnect relies on Laravel, a robust PHP framework known for its efficiency in API development. Laravel ensures a stable and scalable server environment.
- **MySQL:** For data storage, InvestorConnect utilizes MySQL, a reliable and structured database solution. It facilitates efficient data management and retrieval.
- **AWS (Amazon Web Services):** InvestorConnect leverages the cloud infrastructure of AWS for server hosting. This choice ensures scalability, reliability, and optimal performance.

## AI-Driven Matchmaking (OpenAI)
<a name="AI-Driven Matchmaking"></a>
- **OpenAI:** InvestorConnect incorporates OpenAI's advanced machine learning capabilities to create a cutting-edge AI algorithm. This algorithm suggests potential matches based on user preferences, offering personalized recommendations for user profiles. Additionally, OpenAI provides tailored advice for each displayed profile, enhancing the matchmaking experience and increasing the likelihood of meaningful connections.
 
## Real-time Communication
<a name="Real-time Communication"></a>
- **Firebase:** Firebase is seamlessly integrated into InvestorConnect to enable real-time push notifications and live messaging capabilities. It enhances user engagement and communication within the platform.
<br><br>

Please note that this is just a summary of the technologies driving InvestorConnect's functionality, and there may be additional technologies and tools used to enhance the platform's performance and user experience.

<br><br> 

<a name="Demo"></a>
<img src="./readme/title5.svg"/>
> InvestorConnect showcases its matchmaking platform through an intuitive user experience. Explore the app's core features below:

### Authentication

Authentication  | Login | Signup |
| --- | --- | --- |
![Authentication](/readme/images/landing_page.png)| ![Login](/readme/gifs/login.gif) | ![Signup](/readme/gifs/signup.gif) |

### Profile Creation

#### Investor Profile Creation

| Step 1 | Step 2 |
| --- | --- |
| ![Investor Profile Creation - Step 1](/readme/gifs/investor_profile_1.gif) | ![Investor Profile Creation - Step 2](/readme/gifs/investor_profile_2.gif) |

#### Startup Profile Creation

| Step 1 | Step 2 | Step 3 |
| --- | --- | --- |
| ![Startup Profile Creation - Step 1](/readme/gifs/startup_profile_1.gif) | ![Startup Profile Creation - Step 2](/readme/gifs/startup_profile_2.gif) | ![Startup Profile Creation - Step 3](/readme/gifs/startup_profile_3.gif) |


### App Screens

#### Home Screen

| Investor Homepage | Startup Homepage |
| --- | --- |
| ![Investor Homepage](/readme/gifs/investor_card_swipe.gif) | ![Startup Homepage](/readme/images/startup-home.png) |

#### Common App Screens

| Chats | Messages | Notifications | Profile |
| --- | --- | --- | --- |
| ![Chats](/readme/images/chats.png) | ![Messages](/readme/gifs/messages.gif) | ![Notifications](/readme/images/notifications.png) | ![Profile](/readme/images/profile-screen.png) |

### Booking Meetings

| Booking Meetings |
| --- |
| ![Booking Meetings](/readme/gifs/meetings.gif) |

### Push Notifications

| Push Notifications |
| --- |
| ![Push Notifications](/readme/images/notification.png) |

### Admin Dashboard

#### Website Screens

| Admin Login | Dashboard |
| --- | --- |
| ![Admin Login](/readme/images/admin-login.png) | ![Admin Dashboard](/readme/images/admin-dashboard.png) |


<br><br>

<!-- How to run -->
<img src="./readme/title6.svg" name="how-to-run"/>

> To set up InvestorConnect locally, follow the steps below:

<a name="prerequisites"></a>

### Prerequisites

- Flutter SDK: Install the Flutter SDK to build and run the mobile application.
- Android Studio: Install Android Studio to run the Flutter app on an emulator or connected device.
- Angular CLI: Install Angular CLI to run the admin dashboard.
- Node.js: Install Node.js for Angular development.
- Laravel: Install Laravel to run the backend server.
- Composer: Install Composer to manage Laravel dependencies.
- MySQL: Install MySQL to set up the database.

<a name="installation"></a>

### Installation

_Below is an example of how you can instruct your audience on installing and setting up your app._

1. Clone the repo

    ```sh
    git clone https://github.com/Omar-Arja/InvestorConnect
    ```

2. Install Laravel dependencies by navigating to the Laravel project directory:

   ```sh
   cd server
   composer install
   ```

3. Set up your Laravel environment and configure the .env file with your database settings.

   Run Laravel migrations to set up the database:

   ```sh
   php artisan migrate --seed
   ```

4. Navigate to the Flutter app directory:

   ```sh
   cd client/app
   ```

5. Install Flutter dependencies and run the Flutter app on your emulator or connected device:

   ```sh
   flutter pub get
   flutter run
   ```

6. Navigate to the Angular project directory:

   ```sh
   cd client/website
   ```

7. Install Angular dependencies and run the Angular app:

   ```sh
   npm install
   ng serve
   ```

Now, you should be able to run **InvestorConnect** locally and explore its features
