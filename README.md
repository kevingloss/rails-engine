# Rails Engine Lite: Turing 2110 BE Mod 3

![languages](https://img.shields.io/github/languages/top/kevingloss/rails-engine?color=red)
![PRs](https://img.shields.io/github/issues-pr-closed/kevingloss/rails-engine)
![rspec](https://img.shields.io/gem/v/rspec?color=blue&label=rspec)
![simplecov](https://img.shields.io/gem/v/simplecov?color=blue&label=simplecov) <!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/contributors-1-orange.svg?style=flat)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

## Author:
[Kevin Gloss](https://github.com/kevingloss)

## Background & Description:

"Rails Engine Lite" is a solo project built over the course of four days in Turing's module 3 backend program. It takes a fictitious E-Commerce Application and required exposing API's to return data in a standard format (related to merchants and their items) for a frontend team to consume.
- Original Project Details and Requirements can be found [here](https://backend.turing.edu/module3/projects/rails_engine_lite/).

## Learning Goals
- Practice exposing API's.
- Practice SRP using Controllers, Models, Serializers.
- Utilize advanced routing techniques including namespacing to organize and group like functionality together under V1.
- Test API responses with RSpec and capture happy/sad paths.

## Requirements and Setup (for Mac):
### Ruby and Rails
- Ruby -V 2.7.2
- Rails -V 5.2.6
### Gems Utilized
- rspec
- pry
- simplecov
- factory_bot_rails
- faker
- jsonapi-serializer
### Setup
1. Fork and/or Clone this Repo from GitHub.
2. In your terminal use `$ git clone <ssh or https path>`
3. Change into the cloned directory using `$ cd rails-engine`
4. Install the gem packages using `$ bundle install`
5. Database Migrations (Information comes from [here](rails-engine-development.pgdump)) can be setup by running:
```shell
$ rails rake db:{drop,create,migrate,seed}
$ rails db:schema:dump
```
6. Startup and Access require the server to be running locally and a web browser opened.
  - Start Server
```shell
$ rails s
```
 - Open Web Broswer and visit http://localhost:3000/
   - Please visit below endpoints to see JSON data being exposed

## Testing
 - Testing is performed in two places.
   1. The terminal utilizing RSpec
 ```shell
 $ rspec spec/<follow directory path to test specific files>
 ```
   or test the whole suite with `$ rspec`
   2. [Postman](https://www.postman.com/) to test what the endpoints are returning and the happy/sad paths while the local server is running. 
    - To install Turing's pre-made postman tests for both part one and two of the project use these links: [Postman Part 1 Tests](https://backend.turing.edu/module3/projects/rails_engine_lite/RailsEngineSection1.postman_collection.json) & [Postman Part 2 Tests](https://backend.turing.edu/module3/projects/rails_engine_lite/RailsEngineSection2.postman_collection.json)
    - Copy the link and in postman choose to import then paste the link under the link option. This should create a new collection with the needed tests.

## Endpoints
### Merchants
 - Merchants Index
 - Merchants Show
 - Merchant's Items Index
 - Merchants Find
### Items
 - Items Index
 - Items Show
 - Items Create
 - Items Update
 - Items Destroy
 - Item's Merchant Index
 - Items Find_All

## Further Project Information
 - [Turing Project Details](https://backend.turing.edu/module3/projects/rails_engine_lite/)
 - [Further Requirements/Enpoint - requests & responses](https://backend.turing.edu/module3/projects/rails_engine_lite/requirements)
