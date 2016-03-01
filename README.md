# signin-frontend

Frontend to sign people in at Bernie events. React + React-Router + CoffeeScript

## Development

### Prerequisites

* git
* npm

### Setup

1. Clone the repository (`git clone git@github.com:Bernie-2016/signin-frontend.git`)
2. Install dependencies: `npm install`
3. Run development server: `gulp serve` and open [http://localhost:8080](http://localhost:8080) (you'll also need to setup and run the [development server](https://github.com/Bernie-2016/signin-api))

### Deployment

1. Add valid IAM credentials in `credentials.json`.
2. Run `npm run webpack` to generate production assets.
3. Run `npm run deploy` to deploy.

## Contributing

1. Fork it ( https://github.com/Bernie-2016/signin-frontend/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

[AGPL](http://www.gnu.org/licenses/agpl-3.0.en.html)