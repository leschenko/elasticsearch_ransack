# ElasticRansack

ElasticRansack provides searching to your elasticsearch models like Ransack or MetaSearch gems.
Your just create search form with `name_cont` or `created_at_gt` fields and ElasticRansack build a search query for you.
It is compatible with most of the Ransack helper methods and predicates.

[![Build Status](https://travis-ci.org/leschenko/elastic_ransack)](https://travis-ci.org/leschenko/elastic_ransack)

ElasticRansack uses [Tire](https://github.com/karmi/tire) and [Elasticsearch](http://www.elasticsearch.org/) for searching.

Inspired by [Ransack](https://github.com/ernie/ransack) gem.

## Installation

Add this line to your application's Gemfile:

    gem 'elastic_ransack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elastic_ransack

## Usage

Include ElasticRansack extension to your model:

```ruby
class User < ActiveRecord::Base
  include ElasticRansack::Model
end
```

Search with `elastic_ransack` method. It return `Tire::Results::Collection` instance:

```ruby
User.elastic_ransack({name_cont: 'alex', role_id_eq: 1, state_id_in: [2, 3], created_at_gt: 1.day.ago})
```

### Options
* `:s` sorting column, can contain sort mode separated by space, example: `id desc`
* `:q_cont` search against _all fields

### Predicates
* `_cont`    contains string value
* `_eq`      equal value
* `_in`      include any of the values
* `_in_all`  include all values
* `_gt`      greater then value
* `_lt`      less then value
* `_gteq`    greater or equal the value
* `_lteq `   less or equal the value

### Examples

```ruby
Product.elastic_ransack(name_cont: 'alex', category_id_eq: 1, tag_ids_in: [2, 3])
Product.elastic_ransack(tag_ids_in: '2,3,4')
Product.elastic_ransack(created_at_gt: 1.day.ago)
Product.elastic_ransack(q_cont: 'table')
Product.elastic_ransack(s: 'price desc')
```

For search on localized attributes like `name_en` use `translations_` prefixed field:

```ruby
Product.elastic_ransack({translations_name_cont: 'chair'}, globalize: true)
```

It will search on `name_en` field (depending on current locale)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
