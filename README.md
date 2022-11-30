
#

## Install

    docker-compose up -d

## Connection to db

   psql -Upostgres

## Use


### First example

    curl http://localhost:3000/todos

Response:

    [
        {
            "id": 1,
            "done": true,
            "task": "finish tutorial 0",
            "due": null
        },
        {
            "id": 2,
            "done": false,
            "task": "pat self on back",
            "due": null
        }
    ]


### Horizontal Filtering (Rows)

Only tasks done = true

    http://localhost:3000/todos?done=is.true

Only id  = 2

    http://localhost:3000/todos?id=eq.2


### Vertical Filtering (Columns)

GET /todos?select=id,task HTTP/1.1

    http://localhost:3000/todos?select=id,task


## Authentication

1. Create jwt_secret
2. Create jwt_token with data and jwt_secret (with jwt.io for example)

       {
           "role": "todo_user"
       }

3. Copy token (for example):

       eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.7PBkzQsZE5b9W7HrItWvlsdrQjYMLyknHDaQbuFpehA


4. Request

        export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.7PBkzQsZE5b9W7HrItWvlsdrQjYMLyknHDaQbuFpehA"
    
        curl http://localhost:3000/todos -X POST \
        -H "Authorization: Bearer $TOKEN"   \
        -H "Content-Type: application/json" \
        -d '{"task": "learn how to auth"}'

5. (Optional) With Expiration

   - role : The database role under which to execute SQL for API request
   - exp : Expiration timestamp for token, expressed in “Unix epoch time”

         {
          "role": "todo_user",
          "exp": 123456789
         }

   To find epoch from postgreSQL

       select extract(epoch from now() + '5 minutes'::interval) :: integer;


## Credits

https://postgrest.org/en/stable/tutorials/tut0.html

https://blog.frankel.ch/poor-man-api/

https://github.com/ajavageek/poor-man-api