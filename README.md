


# API Documentation
**Continuous Integration Status:** [![Build Status](https://travis-ci.com/sebasdeldi/Grape-Sequel-Example.svg?branch=development)](https://travis-ci.com/sebasdeldi/Grape-Sequel-Example)

## Create Movies
Takes the movie info as input, including the different dates in which the movie is going to be presented (see the `presentations` array)

- **URL:** https://movies-reservation.herokuapp.com/api/v1/movies
- **Http Method:** Post
- **Request Body:** 
```json
{
  "name": "Harry Potter",
  "description": "Best movie ever filmed!",
  "image_url": "https://starwars.com",
  "presentations": [
    {
      "date": "2020-05-01" 
    },
    {
      "date": "2020-05-05" 
    }
  ]
}
```
- **Response Status:**  201 if succeeds, 400 if validation fails
- **Response Body:**
```json
{
    "id": 1,
    "name": "Harry Potter",
    "description": "Best movie ever filmed!",
    "image_url": "https://starwars.com",
    "presentations": [
        {
            "id": 1,
            "available_places": 10,
            "date": "2020-05-01",
            "week_day": "friday"
        },
        {
            "id": 2,
            "available_places": 10,
            "date": "2020-05-05",
            "week_day": "tuesday"
        }
    ]
}
```
## List Movies

Lists movies found in the db, if the `week_day` param is sent, it's only going to return movies that have presentations in the selected day including only the presentation that matched the day, if no param is sent returns all the movies.
Valid `week_days` are: `[monday|tuesday|wednesday|thursday|friday|saturday|sunday]`

- **URL:** https://movies-reservation.herokuapp.com/api/v1/movies?week_day=friday
- **Http Method:** Get
- **Response Status:**  200
- **Response Body:**
```json
[
    {
        "id": 1,
        "name": "Harry Potter",
        "description": "Best movie ever filmed!",
        "image_url": "https://starwars.com",
        "presentations": [
            {
                "id": 1,
                "available_places": 10,
                "date": "2020-05-01",
                "week_day": "friday"
            }
        ]
    },
    {
        "id": 2,
        "name": "Lord of the rings",
        "description": "Pretty cool movie!",
        "image_url": "https://lordoftherings.com",
        "presentations": [
            {
                "id": 3,
                "available_places": 10,
                "date": "2020-05-01",
                "week_day": "friday"
            }
        ]
    }
]
```
## Create Reservations
Creates a reservation in a particular `date` for a particular `movie`, the `movie id` is received as a path param and the `date` of the reservation is received in the request body.
Each movie presentation has 10 seats, every time a reservation is created, the amount of available seats is diminished until there are no seats left, making impossible to create a reservation for the presentation. 

- **URL:** https://movies-reservation.herokuapp.com/api/v1/reservations/movie/1
- **Http Method:** Post
- **Request Body:** 
```json
{
  "date": "2020-05-05" 
}
```
- **Response Status:**  201 if succeeds, 400 if validation fails
- **Response Body:**
```json
{
    "id": 1,
    "reservation_code": "1585046268617394",
    "presentation": {
        "id": 2,
        "available_places": 9,
        "date": "2020-05-05",
        "week_day": "tuesday",
        "movie": {
            "id": 1,
            "name": "Harry Potter",
            "description": "Best movie ever filmed!",
            "image_url": "https://starwars.com"
        }
    }
}
```
## List Reservations

Lists reservations found in the db, if the `start_date` and `finish_date` params are sent, it's only going to return reservations within that date range, if no param is sent returns all the reservations.
the valid `date formats` are: 

 - YYYY-MM-DD
 - YYYY/MM/DD

- **URL:** https://movies-reservation.herokuapp.com/api/v1/reservations?start_date=2020-05-01&finish_date=2020-05-10
- **Http Method:** Get
- **Response Status:**  200
- **Response Body:**
```json
[
    {
        "id": 2,
        "reservation_code": "1585046268617394",
        "movie_id": 1,
        "available_places": 9,
        "date": "2020-05-05",
        "week_day": "tuesday",
        "presentation": {
            "id": 2,
            "available_places": 9,
            "date": "2020-05-05",
            "week_day": "tuesday",
            "movie": {
                "id": 1,
                "name": "Harry Potter",
                "description": "Best movie ever filmed!",
                "image_url": "https://starwars.com"
            }
        }
    },
    {
        "id": 1,
        "reservation_code": "1585048720670017",
        "movie_id": 1,
        "available_places": 9,
        "date": "2020-05-01",
        "week_day": "friday",
        "presentation": {
            "id": 1,
            "available_places": 9,
            "date": "2020-05-01",
            "week_day": "friday",
            "movie": {
                "id": 1,
                "name": "Harry Potter",
                "description": "Best movie ever filmed!",
                "image_url": "https://starwars.com"
            }
        }
    }
]
```
## Running the project locally

 - Clone the [development branch](https://github.com/sebasdeldi/Grape-Sequel-Example) (`$ git clone https://github.com/sebasdeldi/Grape-Sequel-Example.git`)
 - Install dependencies (`$ bundle install`)
 - Create a PG database for development and another one for test
 - Specify the databases information in a [Dotenv](https://github.com/bkeepers/dotenv) file specifying the following information:
   - DEVELOPMENT_DB (this is the database name)
   - DEVELOPMENT_DB_HOST
   - DEVELOPMENT_DB_USER
   - DEVELOPMENT_DB_PASSWORD
   - TEST_DB (this is the database name)
   - TEST_DB_HOST
   - TEST_DB_USER
   - TEST_DB_PASSWORD
- Run Sequel DB migrations: `$ sequel -m db/migrations postgres://localhost/sequel_test`, replacing `postgres://localhost/sequel_test` with your database information. It's not necessary to do the same for the test db (it's auto ran while executing specs), the same goes for production (migrations are auto ran on server start up) 
- Run the server! (`$ rackup`)

## Extra cool stuff worth mentioning
- The project includes [Travis CI](https://travis-ci.com/) which is a continuos integration tool that runs [Rubocop](https://github.com/rubocop-hq/rubocop) and [Rspec](https://rspec.info/) (you can make it run whatever you want) every time I generate a new pull request in a remote server, assuring that my code is always well written and tested before letting merge branches.
- All user facing strings are handled by translation files so in case the application would need to be used in a language other than english, it can be accomplished fairly easy
- If you are interested in seeing the step by step progress of the project you can checkout the closed [PR's history](https://github.com/sebasdeldi/Grape-Sequel-Example/pulls?q=is:pr%20is:closed)
- Instead of using DRY Transactions, I preffered to use [Interactors](https://github.com/collectiveidea/interactor) since DRY Transactions [will be discontinued](https://dry-rb.org/gems/dry-transaction/0.13/) pretty soon
