require 'spec_helper'

class ModelSearch < ActiveModelTireBase

  mapping do
    indexes :id, type: 'integer'
    indexes :int_attr, type: 'integer'
  end

  def self.test_data
    [
        {
            id: 1, text: 'alex test', text_ru: 'alexandr',
            one_assoc_id: 1, many_assoc_ids: [2, 3, 4],
            int_attr: 10, float_attr: 5.5, created_at: 1.day.ago
        },
        {
            id: 2, text: 'andrey black', text_ru: 'andrey rus',
            one_assoc_id: 2, many_assoc_ids: [3, 4, 5, 6],
            int_attr: 20, float_attr: 27.5, created_at: 1.month.ago
        },
        {
            id: 3, text: 'mike test', text_ru: 'mike rus',
            one_assoc_id: 2, many_assoc_ids: [10, 14, 17],
            int_attr: 80, float_attr: 7.5, created_at: 1.hour.ago
        }
    ]
  end
end


describe 'searching' do
  before :all do
    @model = ModelSearch
    @model.setup_index
  end

  context 'predicates' do
    it '_cont' do
      @model.tire_ransack(text_cont: 'test').map(&:id).map(&:to_i).should =~ [1, 3]
    end

    it '_eq' do
      @model.tire_ransack(one_assoc_id_eq: 2).map(&:id).map(&:to_i).should =~ [2, 3]
    end

    it '_in' do
      @model.tire_ransack(many_assoc_ids_in: [3, 99]).map(&:id).map(&:to_i).should =~ [1, 2]
    end

    it '_in_all' do
      @model.tire_ransack(many_assoc_ids_in_all: [4, 5]).map(&:id).map(&:to_i).should =~ [2]
    end

    context '_gt' do
      it 'integer' do
        @model.tire_ransack(int_attr_gt: 20).map(&:id).map(&:to_i).should =~ [3]
      end

      it 'datetime' do
        @model.tire_ransack(created_at_gt: 2.days.ago).map(&:id).map(&:to_i).should =~ [1, 3]
      end

      it 'datetime string' do
        @model.tire_ransack(created_at_gt: 2.days.ago.strftime('%d.%m.%Y %H:%M')).map(&:id).map(&:to_i).should =~ [1, 3]
      end

      it 'date' do
        @model.tire_ransack(created_at_gt: Date.yesterday).map(&:id).map(&:to_i).should =~ [1, 3]
      end

      it 'date string' do
        @model.tire_ransack(created_at_gt: Date.yesterday.strftime('%d.%m.%Y')).map(&:id).map(&:to_i).should =~ [1, 3]
      end
    end

    context '_lt' do
      it 'integer' do
        @model.tire_ransack(int_attr_lt: 20).map(&:id).map(&:to_i).should =~ [1]
      end

      it 'datetime' do
        @model.tire_ransack(created_at_lt: 2.days.ago).map(&:id).map(&:to_i).should =~ [2]
      end

      it 'datetime string' do
        @model.tire_ransack(created_at_lt: 2.days.ago.strftime('%d.%m.%Y %H:%M')).map(&:id).map(&:to_i).should =~ [2]
      end

      it 'date' do
        @model.tire_ransack(created_at_lt: Date.yesterday).map(&:id).map(&:to_i).should =~ [2]
      end

      it 'date string' do
        @model.tire_ransack(created_at_lt: Date.yesterday.strftime('%d.%m.%Y')).map(&:id).map(&:to_i).should =~ [2]
      end
    end

    it '_gteq' do
      @model.tire_ransack(int_attr_gteq: 20).map(&:id).map(&:to_i).should =~ [2, 3]
    end

    it '_lteq' do
      @model.tire_ransack(int_attr_lteq: 20).map(&:id).map(&:to_i).should =~ [1, 2]
    end

    it '_cont localized' do
      I18n.locale = :ru
      @model.tire_ransack({translations_text_cont: 'alexandr'}, {globalize: true}).map(&:id).map(&:to_i).should =~ [1]
    end
  end

  it 'q_cont param search on _all fields' do
    @model.tire_ransack(q_cont: 'test').map(&:id).map(&:to_i).should =~ [1, 3]
  end

  context 'sorting' do
    it 'default sort by id desc' do
      @model.tire_ransack.map(&:id).map(&:to_i).should =~ [3, 2, 1]
    end

    it 'custom sort' do
      @model.tire_ransack(s: 'float_attr').map(&:id).map(&:to_i).should =~ [1, 3, 2]
    end

    it 'custom sort mode' do
      @model.tire_ransack(s: 'float_attr desc').map(&:id).map(&:to_i).should =~ [2, 3, 1]
    end
  end
end