# TireRansack

TireRansack provides condition predicate searching to your elasticsearch models like ransack or meta_search gems.
Inspired by [Ransack](https://github.com/ernie/ransack) gem

## Installation

Add this line to your application's Gemfile:

    gem 'tire_ransack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tire_ransack

## Basic Usage

Specify attributes for autocompletion. By default, this is `name` attribute:

```ruby
class User < ActiveRecord::Base
  ac_field :full_name
end
```
## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
