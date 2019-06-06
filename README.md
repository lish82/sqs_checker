# SqsChecker

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sqs_checker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sqs_checker

## Usage

### List messages

```bash
bundle exec sqs_checker list {queue_name}
```

### Delete messages

```bash
bundle exec sqs_checker delete {queue_name} {eventType}
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
