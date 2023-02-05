# Federails

Federails is an engine that brings ActivityPub to Ruby on Rails application.

## Features

TBD

## Installation

Add this line to your application's Gemfile:

```ruby
gem "federails"
```

And then execute:

```bash
$ bundle
```

## Usage

### Configuration

Execute

```sh
bundle exec rails generate federails:install
```

It creates an initializer and a configuration file:
- `config/initializers/federails.rb`
- `config/federails.yml`

By default, Federails is configured using `config_from` method, that loads the appropriate YAML file, but you may want
to configure it differently:

```rb
# config/initializers/federails.rb
Federails.configure do |config|
  config.host = 'localhost'
  # ...
end
```

For now, refer to [the source code](lib/federails/configuration.rb) for the full list of options.

## Community

You can join the [matrix chat room](https://matrix.to/#/#federails:matrix.org) to chat with humans.

## Contributing

Contributions are welcome, may it be issues, ideas, code or whatever you want to share. Please note:

- This project is _fast forward_ only: we don't do merge commits
- We adhere to [semantic versioning](). Please update the changelog in your commits
- We try to adhere to [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) principles
- We _may_ rename your commits before merging them
- We _may_ split your commits before merging them

To contribute:

1. Fork this repository
2. Create small commits
3. Ideally create small pull requests. Don't hesitate to open them early so we all can follow how it's going
4. Get congratulated

### Tooling

#### RSpec

RSpec is the test suite. Start it with

```sh
bundle exec rspec
```

#### Rubocop

Rubocop is a linter. Start it with

```sh
bundle exec rubocop
```

#### FactoryBot

FactoryBot is a factory generator used in tests and development.
A rake task checks the replayability of the factories and traits:

```sh
bundle exec app:factory_bot:lint
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
