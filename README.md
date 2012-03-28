# Spamster

Simple spam filtering.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spamster'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spamster

## Usage

### Quick start

Start by signing up for an API key [here](https://akismet.com/signup/). Then configure Spamster like:

```ruby
Spamster.blog = "http://yoursite.com/"
Spamster.key = "your-api-key"
```

FIXME middleware
FIXME usage

### Spamster methods

#### key_valid?

Checks if the key is valid using [verify-key](http://akismet.com/development/api/#verify-key).

```ruby
Spamster.key_valid?
```

#### spam?

Checks if a comment is spam using [comment-check](http://akismet.com/development/api/#comment-check)

```ruby
Spamster.spam?(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

### spam!

Reports a false negative using [submit-spam](http://akismet.com/development/api/#submit-spam)

```ruby
Spamster.spam!(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

### ham!

Reports a false positive using [submit-ham](http://akismet.com/development/api/#submit-ham)

```ruby
Spamster.ham!(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
