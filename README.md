# Spamster [![Build Status](https://secure.travis-ci.org/balexand/spamster.png)](http://travis-ci.org/balexand/spamster)

Simple spam filtering that works with any Ruby application and can be set up in minutes. It does not depend on any specific ORM or framework, although it includes optional Rack middleware. It uses Akismet or TypePad AntiSpam.

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

The easiest way to use Spamster is to include the mixin in your comment model:

```ruby
class Comment
  attr_accessor :content, :email, :name

  include Spamster::Model
  spamster_attrs comment_author: :name, comment_author_email: :email, comment_content: :content
end

comment = Comment.new #...
comment.spamster.spam? # checks for spam
comment.spamster.spam! # reports a false negative
comment.spamster.ham!  # reports a false positive
```

For a full list of parameters accepted by `spamster_attrs`, see [Akismet's documentation for `comment-check`](http://akismet.com/development/api/#comment-check).

### Spamster methods

#### key_valid?

Checks if the key is valid using [`verify-key`](http://akismet.com/development/api/#verify-key).

```ruby
Spamster.key_valid?
```

#### spam?

Checks if a comment is spam using [`comment-check`](http://akismet.com/development/api/#comment-check).

```ruby
Spamster.spam?(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

### spam!

Reports a false negative using [`submit-spam`](http://akismet.com/development/api/#submit-spam).

```ruby
Spamster.spam!(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

### ham!

Reports a false positive using [`submit-ham`](http://akismet.com/development/api/#submit-ham).

```ruby
Spamster.ham!(user_ip: "222.222.222.222", user_agent: "Mozilla", comment_author: "viagra-test-123")
```

## Contributing

Fork it, install dependencies with `bundle`, and run tests with `bundle exec rake`. If you submit a pull request, then remember to include tests.

Created by Brian Alexander and released under an MIT License.
