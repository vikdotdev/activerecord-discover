# ActiveRecordDiscover
Short description and motivation.

Prepare the testing database:
```
pushd test/dummy
RAILS_ENV=test bin/rails db:migrate
popd
```

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'activerecord-discover'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install activerecord-discover
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

### Ideas & Thoughts
- Monkey-patch ActiveRecord::Base class to include method for print instead of generating methods?
Add arbitrary methods with method_missing e.g. Model.discover_before_save_and_after_create_callbacks;
- Adapt gem to be compatible with ActiveRecord without Rails?
