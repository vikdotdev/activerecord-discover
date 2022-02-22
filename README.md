# ActiveRecordDiscover
Short description and motivation.

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

## Developer notes
### TODO
- Add more specs and automatically test existing model scenarios

### Open questions & issues

### Ideas & Thoughts
- Print actual source with `target.ast.loc.expression.source` instead of unparsing
- Monkey-patch ActiveRecord::Base class to include method for print instead of generating methods?
Add arbitrary methods with method_missing e.g. Model.discover_before_save_and_after_create_callbacks;
- Optionally display system callbacks? E.g. `has_many dependent: :destroy` etc;
- Optionally display gem callbacks?
- Adapt gem to be compatible with ActiveRecord without Rails?
- Add Pry paging support
- Setup automatic push to RubyGems and Github actions to run specs
- Add automatic version increment with Fast
- Make generator for initializer
- Add threshold option to truncate long methods
- Include executable file, add .ardiscover dotfile with override options
