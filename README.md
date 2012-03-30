# Spamster [![Build Status](https://secure.travis-ci.org/balexand/spamster.png)](http://travis-ci.org/balexand/spamster)

Simple spam filtering that works with any Ruby application. It does not depend on any framework or ORM, although it has optional Rack middleware.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spamster'
```

And then execute:

    $ bundle

## Usage

### Configuration

First you'll need to sign up for an API key from [Akismet](https://akismet.com/signup/) or [TypePad AntiSpam](http://antispam.typepad.com/info/get-api-key.html). Then configure Spamster like:

```ruby
Spamster.use_akismet("your-api-key", "http://yoursite.com/")
```

or...

```ruby
Spamster.use_typepad("your-api-key", "http://yoursite.com/")
```

If you're building a Rack app (all Rails 3+ apps are Rack apps), then you'll probably want to use the optional Rack middleware so Spamster can automatically fill in the `referrer`, `user_agent`, and `user_ip` params. If you're using Rails then add the middleware like this:

```ruby
Rails.application.config.middleware.use Spamster::Rack::Middleware
```

If you're using Rails, then a suggested location to keep the above configuration is in an initializer file.

### Sanity check

First check that your key is valid:

```ruby
Spamster.key_valid? # => true
```

Then check that it detects spam using the name `viagra-test-123`:

```ruby
Spamster.spam?(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123") # => true
```

And if you want to see the HTTP requests/responses while debugging:

```ruby
Spamster.debug_output = $stderr
```

### Model mixin

FIXME

### Spamster methods

#### key_valid?

Checks if the key is valid using [verify-key](http://akismet.com/development/api/#verify-key).

```ruby
Spamster.key_valid?
```

#### spam?

Checks if a comment is spam using [comment-check](http://akismet.com/development/api/#comment-check).

```ruby
Spamster.spam?(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

### spam!

Reports a false negative using [submit-spam](http://akismet.com/development/api/#submit-spam).

```ruby
Spamster.spam!(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

### ham!

Reports a false positive using [submit-ham](http://akismet.com/development/api/#submit-ham).

```ruby
Spamster.ham!(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
