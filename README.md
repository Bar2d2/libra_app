# Libra app

## Requirements

You should have already installed:

- Ruby 3.2.0
- Ruby on Rails 7.0.6
- Postgresql

## API endpoints

Restful API was built upon Grape API framework, and documented using OpenAPI. The UI for API documentation is available on [localhost:/3000/api-docs](http://localhost:3000/api-docs)

#### Book endpoints
| Endpoint |  Action  | Description |
|:-----|:--------:|------:|
| /books   | GET | Get list of books |
| /books?page={number}   | GET | Get list of books for specific page |
| /books   | POST | Create new book |
| /books{id}   | GET | Get a specific book by ID with related author |
| /books{id}   | PUT | Update a specific book by ID |
| /books{id}   | DELETE | Delete a specific book by ID |
| /books{id}/upload_cover   | POST | Upload cover image for specific book with ID |

#### Author endpoints
| Endpoint |  Action  | Description |
|:-----|:--------:|------:|
| /authors   | GET | Get list of author |
| /authors?page={number}   | GET | Get list of authors for specific page |
| /authors   | POST | Create new author |
| /authors{id}   | GET | Get a specific author by ID with related books |
| /authors{id}   | PUT | Update a specific author by ID |
| /authors{id}   | DELETE | Delete a specific author by ID |


## Local Installation

### 1. Clone Github repo and install Ruby gems

```sh
git clone git@github.com:Bar2d2/libra_app.git
cd libra_app
gem install bundler
bundle install
yarn install
```

### 2. Set up your credentials with Master Key from the owner of this app

The master.key file should live under the ```/app/config``` directory.

### 3. Images upload is handle by AWS S3 service, if you would want to update the credentials with your own

```sh
rails credentials:edit
```

```sh
s3:
  bucket: <bucket-name>
  region: <bucket-region>
  access_key_id: <your-access-key>
  secret_access_key: <your-secret-access-key>
```

### 4. Set up database, migrations and seed data

```sh
rake db:create
rake db:migrate
rake db:seed
```

### 5. Start Postgresql (they should be started on startup)

#### For Mac users

```sh
brew services start postgres
```

You can check running services with `brew services list`.

#### For Ubuntu >=16.x check that services are running

```sh
systemctl status postgres
```

Start services if required:

```sh
sudo systemctl start postgres.service
```

### 6. Run the tests to know everthing is working fine

```sh
bundle exec rspec
bundle exec cucumber
```

### 7. Test Coverage

```sh
COVERAGE=on bundle exec rspec
```

### 8. Code smells and formatting

```sh
rubocop
reek
```
### 9. Launch Rails server

```sh
foreman start
```
### 10. API documentation - to see UI go to the

[localhost:/3000/api-docs](http://localhost:3000/api-docs)

