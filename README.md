# TireRansack

TireRansack provides condition predicate searching to your elasticsearch models like ransack or meta_search gems.
Your can just create serach form with `name_cont` or `created_at_gt` fields and tire_ransack build a search query for you.

It uses [Tire](https://github.com/karmi/tire) and [Elasticsearch](http://www.elasticsearch.org/) for searching.

Inspired by [Ransack](https://github.com/ernie/ransack) gem.

## Installation

Add this line to your application's Gemfile:

    gem 'tire_ransack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tire_ransack

## Usage

Include TireRansack extension to your model:

```ruby
class User < ActiveRecord::Base
  include TireRansack::Model
end
```

Search with `tire_ransack` method. It return `Tire::Results::Collection` instance:

```ruby
User.tire_ransack({name_cont: 'alex', role_id_eq: 1, state_id_in: [2, 3], created_at_gt: 1.day.ago})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
