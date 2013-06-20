require 'active_model'
require 'tire'
require 'active_support/core_ext'
require 'tire_ransack'

Tire.configure do
  logger 'tmp/elasticsearch.log'  # Commented out logger line here so that it doesn't break specs when tmp directory doesn't exist.
  url 'http://localhost:9200'
  pretty 1
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
    _run_save_callbacks do
    end
  end

  def destroy
    _run_destroy_callbacks do
      @destroyed = true
    end
  end

  def destroyed?
    !!@destroyed
  end
end

class ActiveModelTireBase < ActiveModelBase
  include Tire::Model::Search
  include Tire::Model::Callbacks

  include TireRansack::Model

  def self.setup_index
    tire.index.delete
    tire.create_elasticsearch_index
    populate
    tire.index.refresh
  end

  def self.test_data
    [
        {
           text: 'alex test', text_ru: 'alex rus', text_en: 'alex eng',
           one_assoc_id: 1, many_assoc_ids: [2, 3, 4],
           int_attr: 10, float_attr: 5.5, created_at: 1.day.ago
        },
        {
           text: 'andrey black', text_ru: 'andrey rus', text_en: 'andrey eng',
           one_assoc_id: 2, many_assoc_ids: [3, 4, 5, 6],
           int_attr: 20, float_attr: 27.5, created_at: 1.month.ago
        },
        {
           text: 'mike test', text_ru: 'mike rus', text_en: 'mike eng',
           one_assoc_id: 5, many_assoc_ids: [10, 14, 17],
           int_attr: 80, float_attr: 7.5, created_at: 1.hour.ago
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
