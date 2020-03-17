# Helpscout::Api::Auth

[![Build status](https://badge.buildkite.com/1a7a4e8f4426115e361e8f149c0d4d93fe5fb886fec80fd6c1.svg)](https://buildkite.com/jayco/helpscout-api-auth) [![Gem Version](https://badge.fury.io/rb/helpscout-api-auth.svg)](https://badge.fury.io/rb/helpscout-api-auth)

Gem for authenticating with the HelpScout V2 API.

See [https://developer.helpscout.com/mailbox-api/overview/authentication/](https://developer.helpscout.com/mailbox-api/overview/authentication/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'helpscout-api-auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install helpscout-api-auth

## Usage

### Helpscout::Api::Auth::Token

Creates a new Token class

| Parameter       | Type      | Description                                                          |
| :-------------- | :-------- | :------------------------------------------------------------------- |
| `client_id`     | `string`  | **Required** HelpScout API client id                                 |
| `client_secret` | `string`  | **Required** HelpScout API client secret                             |
| `endpoint`      | `string`  | **Optional** Defaults to `https://api.helpscout.net/v2/oauth2/token` |
| `expires_in`    | `integer` | **Optional** Defaults to `300`                                       |

```ruby
require 'helpscout/api/auth'

token = Helpscout::Api::Auth::Token.new(client_id: 'some id', client_secret: 'keep it secret')
token.access_token
# => 'BMEv1lmcNgDBpOFNHo8TPlODMrF3BG5T'

```

### refresh

Refreshes a token from the api

```ruby
access_token = token.refresh
# => 'BMEv1lmcNgDBpOFNHo8TPlODMrF3BG5T'

token.access_token
# => 'BMEv1lmcNgDBpOFNHo8TPlODMrF3BG5T'
```

### to_s

Prints a friendly formated bearer token string to use

```ruby
access_token = token.to_s
# => 'Bearer BMEv1lmcNgDBpOFNHo8TPlODMrF3BG5T'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/helpscout-api-auth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Helpscout::Api::Auth project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/helpscout-api-auth/blob/master/CODE_OF_CONDUCT.md).
