Ruby Version: 2.7.0 - Rails Version: 6.0.2 - React Version: 16.12.0

Deployed App: https://stocky.solomonfeldman.dev

# Stocky

Stocky is a Rails/React app for simulating users buying and selling stocks as real prices rise and fall throught the day. The user can view their purchase history and their current stocks along with their current value.

## Installation

Do the following in the respective directories.

### Backend

Install and setup postgresql then clone the repository. Run ```$ bundle install```. Then run ```$ rake db:create``` then ```$ rake db:migrate``` to setup the database. Finally run ```$ rails s -p 3001``` to run the server locally in development mode. The Frontend has a proxy set up to send requests here.

### Frontend

Run up ```npm install``` to install dependencies, then ```npm start``` to start up the server in development mode.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SolomonRFeldman/stocky. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The app is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).