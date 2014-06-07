require 'active_model'
require 'elasticsearch/model'
require 'active_support/core_ext'
require 'elastic_ransack'

Elasticsearch::Model.client = Elasticsearch::Client.new host: "http://localhost:#{ENV['ES_PORT'] || 9200}", log: ENV['ES_LOGGER'], trace: ENV['ES_LOGGER']

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect, :should]
  end
end

class ActiveModelBase
  include ActiveModel::AttributeMethods
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON
  include ActiveModel::Naming

  extend ActiveModel::Callbacks
  define_model_callbacks :save, :destroy

  attr_reader :attributes
  attr_accessor :id, :created_at

  def initialize(attributes = {})
    @attributes = attributes
  end

  def to_indexed_json
    @attributes.to_json
  end

  def method_missing(id, *args, &block)
    attributes[id.to_sym] || attributes[id.to_s] || super
  end

  def persisted?
    true
  end

  def save
    run_callbacks(:save) {}
  end

  def destroy
    run_callbacks(:destroy) { @destroyed = true }
  end

  def destroyed?
    !!@destroyed
  end
end


class ModelSearch < ActiveModelBase
  include Elasticsearch::Model
  include Elasticsearch::Model::Adapter::ActiveRecord

  after_save -> { __elasticsearch__.index_document }
  after_destroy -> { __elasticsearch__.delete_document }

  include ElasticRansack::Model

  mapping do
    indexes :id, type: 'integer'
    indexes :int_attr, type: 'integer'
  end

  def self.setup_index
    __elasticsearch__.create_index! force: true, index: index_name
    populate
    __elasticsearch__.refresh_index!
  end

  def self.test_data
    [
        {
            id: 1, text: 'alex test', text_ru: 'alexandr',
            one_assoc_id: 1, many_assoc_ids: [2, 3, 4],
            int_attr: 10, float_attr: 5.5,
            missing_attr: nil,
            created_at: 1.day.ago
        },
        {
            id: 2, text: 'andrey black', text_ru: 'andrey rus',
            one_assoc_id: 2, many_assoc_ids: [3, 4, 5, 6],
            int_attr: 20, float_attr: 27.5,
            missing_attr: [],
            created_at: 1.month.ago
        },
        {
            id: 3, text: 'mike test', text_ru: 'mike rus',
            one_assoc_id: 2, many_assoc_ids: [10, 14, 17],
            int_attr: 80, float_attr: 7.5,
            missing_attr: [1, 3, 3],
            created_at: 1.hour.ago
        }
    ]
  end

  def self.populate
    test_data.each do |attrs|
      u = new(attrs)
      u.id = attrs[:id]
      u.save
    end
  end

end
