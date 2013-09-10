require 'spec_helper'

describe 'predicates' do
  before :all do
    @model = ModelSearch
    @model.setup_index
  end

  it 'delegate methods to model' do
    [:results, :each, :empty?, :size, :[], :total_entries, :per_page, :total_pages,
     :current_page, :previous_page, :next_page, :offset, :out_of_bounds?].each do |meth|
      @model.elastic_ransack.should.respond_to?(meth)
    end
  end

  context 'string fields' do
    it '_cont' do
      @model.elastic_ransack(text_cont: 'test').map(&:id).map(&:to_i).should =~ [1, 3]
    end

    it '_cont localized' do
      I18n.locale = :ru
      @model.elastic_ransack({translations_text_cont: 'alexandr'}, {globalize: true}).map(&:id).map(&:to_i).should =~ [1]
    end

    it 'q_cont param search on _all fields' do
      @model.elastic_ransack(q_cont: 'test').map(&:id).map(&:to_i).should =~ [1, 3]
    end
  end

  it '_eq' do
    @model.elastic_ransack(one_assoc_id_eq: 2).map(&:id).map(&:to_i).should =~ [2, 3]
  end

  it '_in' do
    @model.elastic_ransack(many_assoc_ids_in: [3, 99]).map(&:id).map(&:to_i).should =~ [1, 2]
  end

  it '_in_all' do
    @model.elastic_ransack(many_assoc_ids_in_all: [4, 5]).map(&:id).map(&:to_i).should =~ [2]
  end

  context '_gt' do
    it 'integer' do
      @model.elastic_ransack(int_attr_gt: 20).map(&:id).map(&:to_i).should =~ [3]
    end

    it 'datetime' do
      @model.elastic_ransack(created_at_gt: 2.days.ago).map(&:id).map(&:to_i).should =~ [1, 3]
    end

    it 'datetime string' do
      @model.elastic_ransack(created_at_gt: 2.days.ago.strftime('%d.%m.%Y %H:%M')).map(&:id).map(&:to_i).should =~ [1, 3]
    end

    it 'date' do
      @model.elastic_ransack(created_at_gt: 3.days.ago.to_date).map(&:id).map(&:to_i).should =~ [1, 3]
    end

    it 'date string' do
      @model.elastic_ransack(created_at_gt: 3.days.ago.to_date.strftime('%d.%m.%Y')).map(&:id).map(&:to_i).should =~ [1, 3]
    end
  end

  context '_lt' do
    it 'integer' do
      @model.elastic_ransack(int_attr_lt: 20).map(&:id).map(&:to_i).should =~ [1]
    end

    it 'datetime' do
      @model.elastic_ransack(created_at_lt: 2.days.ago).map(&:id).map(&:to_i).should =~ [2]
    end

    it 'datetime string' do
      @model.elastic_ransack(created_at_lt: 2.days.ago.strftime('%d.%m.%Y %H:%M')).map(&:id).map(&:to_i).should =~ [2]
    end

    it 'date' do
      @model.elastic_ransack(created_at_lt: 3.days.ago.to_date).map(&:id).map(&:to_i).should =~ [2]
    end

    it 'date string' do
      @model.elastic_ransack(created_at_lt: 3.days.ago.to_date.strftime('%d.%m.%Y')).map(&:id).map(&:to_i).should =~ [2]
    end
  end

  it '_gteq' do
    @model.elastic_ransack(int_attr_gteq: 20).map(&:id).map(&:to_i).should =~ [2, 3]
  end

  it '_lteq' do
    @model.elastic_ransack(int_attr_lteq: 20).map(&:id).map(&:to_i).should =~ [1, 2]
  end

  it '_null' do
    @model.elastic_ransack(missing_attr_null: true).map(&:id).map(&:to_i).should =~ [1, 2]
  end

  it '_present' do
    @model.elastic_ransack(missing_attr_present: true).map(&:id).map(&:to_i).should =~ [3]
  end

end