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

## Roadmap
- Add filtering by fields for validations.
- Add `after_[create|update|destroy]_commit` alias callbacks and related ones.
- Implement associations.
- Improve coloring for light themes.
- Potentially bring some items from [Unsupported](#unsupported) section.

## Unsupported
Some things from here might get implemented in the future:
- `with_options` won't display in the output;
- `validates_with` with custom `ActiveModel::Validator` won't display class definition in the output;
- `validates` with custom `ActiveModel::EachValidator` won't display class definition in the output;
- Options for specific validator `validates :foo, presence: { if: :bar? }` won't display method definitions;

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

### Ideas & Thoughts
- Monkey-patch ActiveRecord::Base class to include method for print instead of generating methods?
Add arbitrary methods with method_missing e.g. Model.discover_before_save_and_after_create_callbacks;
- Adapt gem to be compatible with ActiveRecord without Rails?
- Print file path "Intelligently" by looking at combined entity LOC.
- Show inherited entities in the output.

## TODO
- Rename manual dummy models to something more generic.
- Fix handling of `ASTMethod`s that are not found. Current approach has a bug?
- Print with debug information.
