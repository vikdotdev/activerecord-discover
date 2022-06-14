# Manual testing
Since printer is not tested (yet), manual testing is helpful.

```
bin/console
```

## Test validations
```
items_shown = 0
items_confirmed = 0

ActiveRecord::Base.descendants.select do |klass|
  klass.to_s.start_with?("ManualValidation")
end.each do |klass|
  puts
  puts "====== BEGIN FETCHING VALIDATIONS FROM #{klass} ======".green
  discover_validations_of klass
  puts "====== END FETCHING VALIDATIONS FROM #{klass} ======".green
  items_shown += 1
  puts 'All looks valid? [y/N]: '
  next unless gets.chomp.match?(/[Yy]/)
  items_confirmed += 1
  puts
end && nil

puts "Inspected and confirmed #{items_shown}/#{items_confirmed}"
```

## Test callbacks
```
items_shown = 0
items_confirmed = 0

ActiveRecord::Base.descendants.select do |klass|
  klass.to_s.start_with?("ManualCallback")
end.each do |klass|
  puts
  puts "====== BEGIN FETCHING CALLBACKS FROM #{klass} ======".green
  discover_callbacks_of klass
  puts "====== END FETCHING CALLBACKS FROM #{klass} ======".green
  items_shown += 1
  puts 'All looks valid? [y/N]: '
  next unless gets.chomp.match?(/[Yy]/)
  items_confirmed += 1
  puts
end && nil

puts "Inspected and confirmed #{items_shown}/#{items_confirmed}"
```
