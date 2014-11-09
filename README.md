cfk_finder
==========

Below is an overview of many different objects/tables, what they'll need to be able to do and not do etc.

Tutors
---
- Tutors will signup as a user of type "tutor"
- Tutors will provide full contact information, name, date of birth, police check (?), and subjects for which they are available to teach. They will also indicate the number of students they are willing to teach at a time.
  - Once providing information the tutor may then start creating "Tutor Event" objects. 
  - Tutor events will indicate name, dates and times, description, type of event, materials needed etc.
- Event objects will be available for users of type "customer" to sign up
- When a customer signs up a booking is made
- When a customer pays for the session, 2% of the transaction goes to CFK
- When the customer books the session, all other users will be unable to view the information for the session. It will be marked as "booked"
- The tutor will be able to see contact info for the customer, as well as children info.
- The tutor will have reviews and ratings available. Once a customer books the tutor and attends a session, the customer will be able to submit a 1 to 5 star review and leave feedback
  - Feedback will be automatically scanned for inappropriate language and rejected to an admin if it contains coarse or inappropriate langauge
- A tutor may make as many events as desired, as long as they do not overlap
- A tutor will require a "Stripe" account so that funds may be transferred to the tutor.

#### Data
- Tutors have many bookings
- Tutors have many Event events
- Tutors have many Tutor events
- Tutors have feedback and ratings
- Tutors have many subjects
- Tutors have one address

| column        | type         |
|---------------|--------------|
| id            | PK (int)     |
| first_name    | varchar(255) |
| last_name     | varchar(255) |
| email         | varchar(255) |
| date_of_birth | date         |
| police_check  | image*       |
| max_students  | integer      |
| address_id    | FK           |
| info_for_auth |              |

 *Image will be started on Amazon, this is actually a link

___

Customers
---
- Customers will sign up as a user of type "customer"
- When signing up, children information (name, gender, date of birth) will be requested
- Customers will be able to save credit card info (?) for ease of use.
- These customers will be linked to Stripe customers, which will make saving Credit Info easier
- Customer will have a feedback and review as well (?). Same rules as tutor apply.
- Customers may sign one or more children up to a tutor event or an event event.
- A customer may contact a tutor outside of the booking.

#### Data
- Customers have many children
- Customers have one address **(?)**
- Customers have feedback and ratings
- Customers have many bookings

| column        | type         |
|---------------|--------------|
| id            | PK (int)     |
| first_name    | varchar(255) |
| last_name     | varchar(255) |
| email         | varchar(255) |
| stripe_id     | FK*          |
| address_id    | FK           |
| info_for_auth |              |

*Stripe_id will allow us to link to stripe for credit card charges. May have to include more information for stripe (i.e. last 4 digits on CC).

___

Children
---
 - Children have a name, gender, date of birth

#### Data
- Children has one customer (parent/guardian)
- Children have many bookings

| column     | type         |
|------------|--------------|
| id         | PK (int)     |
| first_name | varchar(255) |
| last_name  | varchar(255) |
| gender     | varchar(255) |
| parent_id  | FK           |

___

Events
---
- Similarly to tutor, "tutor" users may also create "Event events"
- Event events are sessions that can handle a classroom size number of children
- Registration (booking) will be handled through the system and customers or non-customers will be able to register their children. Customers will be fast tracked through the process, while customers will need to register through a full customer signup (they will be registered and signed up at the same time).
- Event events will indicate name, dates and times, description, type of event, materials needed, spots available etc.
- Createable by Tutors and Admins, modifiable by the tutor that made it or an admin

#### Data
- Events have many bookings
- Events have many dates
- Events have many images

| column           | type                                  |
|------------------|---------------------------------------|
| id               | PK (int)                              |
| name             | varchar(255)                          |
| description      | TEXT                                  |
| spots_available  | integer, default = 3                  |
| type_of_event    | varchar(255)                          |
| type             | varchar(255) [ tutor or event event ] |
| materials_needed | TEXT                                  |

___

Booking
---
- A booking is a link between "customer", "event", "tutor", "child"
- It is simply a join table

#### Data
- Booking has one child, one tutor, one event, one customer

| column      | type     |
|-------------|----------|
| id          | PK (int) |
| customer_id | FK       |
| child_id    | FK       |
| tutor_id    | FK       |
| event_id    | FK       |

___

Admin
---
 - Admins are super users designated by other admins
 - They are able to view all information for all customers and tutors
 - They must be able to adminstrate the feedback and reviews (delete / modify), no one else should be able to delete. Customers may modify their own. Tutors may modify their own.
 - Admins should be able to modify any events

#### Data
| column        | type         |
|---------------|--------------|
| id            | PK (int)     |
| first_name    | varchar(255) |
| last_name     | varchar(255) |
| email         | varchar(255) |
| info_for_auth |              |

___
 
Feedback and Reviews
---
 - Feedback and reviews exist as a text entry and a star rating (out of 5).
 - Increments for star rating by 0.5
 - Is a one directional review, although the subject of the review may respond
 - All feedback and reviews are checked for coarse or inappropriate language.
 - Createable by anyone, modifiable by the ones who created it or admins.
 - Customer -> Tutor, Tutor -> Customer
 
#### Data
| column      | type                          |
|-------------|-------------------------------|
| id          | PK (int)                      |
| tutor_id    | FK                            |
| customer_id | FK                            |
| type        | varchar(255) [cust or tutor ] |
| description | TEXT                          |
| rating      | DECIMAL(10,2

___

Other Tables
---

### Subjects
| column      | type         |
|-------------|--------------|
| id          | PK (int)     |
| subject     | varchar(255) |
| description | TEXT         |

### Dates
| column     | type     |
|------------|----------|
| id         | PK (int) |
| start_time | datetime |
| end_time   | datetime |
| event_id   | FK       |

### Images
| column     | type     |
|------------|----------|
| id         | PK (int) |
| image      | image*   |
| event_id   | FK       |

 *Image will be started on Amazon, this is actually a link
 
 ### Address
| column     | type         |
|------------|--------------|
| id         | PK (int)     |
| address1   | varchar(255) |
| address2   | varchar(255) |
| City       | varchar(255) |
| State      | varchar(255) |
| Country    | varchar(255) |
| PostalCode | varchar(255) |
