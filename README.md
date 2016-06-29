# GreaterLess

[![Build Status](https://secure.travis-ci.org/esposito/greater_less.png)](http://travis-ci.org/esposito/greater_less)
[![Dependency Status](https://gemnasium.com/esposito/greater_less.png)](https://gemnasium.com/esposito/greater_less)

The GreaterLess gem can be used to generate objects that represent
halfopen intervals, but transparently behave as Ruby Floats.

## Setup

To install, type

```bash
sudo gem install greater_less
```

If you are using bundler, add `greater_less` to your gemfile

```ruby
gem 'greater_less'
```

## Getting Started

One easy way to integrate this gem into your project is by requiring the GreaterLess
string extension as follows:

```ruby
require 'greater_less/string_extension'
```

This extension redifines the `#to_f` method of the String class:

```ruby
class String
  alias :to_f_without_greater_less :to_f

  def to_f
    if self =~ GreaterLess::GREATER_LESS
      return GreaterLess.new(self)
    end
    self.to_f_without_greater_less
  end
end
```

Now when a string starts with a greater or less sign (like for instance
`"> 3.45"`), the `#to_f` method converts it to a GreaterLess object
instead of the value `0.0`.

Alternatively you can opt to create GreaterLess objects using `initialize` directly, like so:

```ruby
value = GreaterLess.new("> 3.45")
```

## Usage

A GreaterLess object can be compared to a Float (or other numeric) as if it were a
Float itself. For instance one can do the following:

```ruby
>> value = ">3.45".to_f
=> > 3.45
>> value > 2.45
=> true
>> value >= 2.45
=> true
>> 2.45 > value
=> false
>> 2.45 >= value
=> false
>> value == ">3.45".to_f
=> true
>> value != 2.45
=> true
```

It is also possible to compare GreaterLess objects with each other, so you
do not have to worry about what kind of object you are dealing with in your
code:

```ruby
>> value1 = ">3.45".to_f
=> > 3.45
>> value2 = "< 2.45".to_f
=> < 2.45
>> value1 > value2
=> true
>> value2 > value1
=> false
```

Finally it is possible to apply simple arithmetics to GreaterLess objects
like addition, subtraction, multiplication and division:

```ruby
>> value = ">3.45".to_f
=> > 3.45
>> value + 2
=> > 5.45
>> value - 2
=> > 1.4500000000000002
>> value * 2
=> > 1.725
```

Inverting the object's sign when multiplying with a negative numerical
or using a GreaterLess object in the denominator is nicely dealt with:

```ruby
>> value = ">3.45".to_f
=> > 3.45
>> -1 * value
=> < -3.45
>> 1 / value
=> < 0.2898550724637681
>> -1 / value
=> > -0.2898550724637681
```

In many cases it makes no sense to apply the operators +, -, * or / on 
a pair of GreaterLess objects, so when this happens an exception is 
raised for now.

All other methods are delegated to the Float value the GreaterLess
object contains, so that it transparently acts like a Float. This means you should be careful when using methods like
`abs` or `round` since they return the result from the underlying Float and bypass the GreaterLess behavior.

## Contributing to greater_less
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2016 Samuel Esposito, Jorn van de Beek. See LICENSE.txt for further details.
