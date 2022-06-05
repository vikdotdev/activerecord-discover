# DiscoverRails
Ever worked with messy Rails application that violates style guides and is difficult to navigate? I'm talking ActiveRecord callbacks/associations/methods spread out all over the model? This library might help seeing certain bits of the application in separation.

Prepare the testing database:
```
pushd test/dummy
RAILS_ENV=test bin/rails db:migrate
popd
```

## Usage
```bash
rails console
```
Once inside Rails console:
```ruby
discover_callbacks_of User
discover_before_callbacks_of Post
discover_save_callbacks_of Comment
discover_after_destroy_callbacks_of Organization
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'discover-rails'
```

And then execute:
```bash
$ bundle
```

## Contributing
TODO Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

### Ideas & Thoughts
- Extend to include more than ActiveRecord discovery features.
- Add simple TUI interface.
- Monkey-patch ActiveRecord::Base class to include method for print instead of generating methods?
Add arbitrary methods with method_missing e.g. Model.discover_before_save_and_after_create_callbacks;
