**hotel_app**
----------
The hotel allows booking up to 6 months in advance for room reservations and needs an easy way for the user to book room if a 
 particular category of room is available for a given date range.
Version
 - Ruby 2.3.0
 - Rails 4.2.5
 
**Database creation**

    rake db:migrate
**Database initialization**

    rake db:seed
**Run the test case**

    rake test
**Run application**

    rails server
    
**Access API for availability of rooms**
----------
1 Create user
 
    rake hotel_app:create_user[first_name,email,password]
    
    
E.g :- rake hotel_app:create_user[abc,abc@example.com,123456]

2 Get user token 

    rake hotel_app:get_user_token[email]

E.g rake hotel_app:get_user_token[abc@example.com]

3 Access API

URL :- POST http://0.0.0.0:3000/api/available_rooms

params require

- user_token  :- 9sMCoa-aT_nf9-ihtF-P  

- check_in    :- 2016-08-25 

- check_out   :- 2016-08-28

- room_type   :- Deluxe Rooms

- user_email  :- abc@example.com

E.g URL:- POST http://0.0.0.0:3000/api/available_rooms?user_token=9sMCoa-aT_nf9-ihtF-P&check_in=2016-08-25&check_out=2016-08-28&room_type=Deluxe+Rooms&user_email=abc@example.com

