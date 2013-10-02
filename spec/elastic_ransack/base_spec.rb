require 'spec_helper'

describe ElasticRansack do
  subject { ModelSearch }

  before :all do
    ModelSearch.setup_index
  end

  it 'setup yields ElasticRansack' do
    ElasticRansack.setup do |config|
      config.should == ElasticRansack
    end
  end

  it 'add predicates' do
    expect do
      ElasticRansack.add_predicate 'test', {query: proc {}}
    end.to change { ElasticRansack.predicates.size }.by(1)

    ElasticRansack.predicates.last.name.should == 'test'
  end

  it 'integer fields' do
    ElasticRansack.should respond_to(:integer_fields_regexp)
    ElasticRansack.integer_fields_regexp.should == /id_/
  end

  it 'add elastic_ransack method' do
    should respond_to(:elastic_ransack)
  end

  describe '#val_to_array' do
    it 'convert comma separated string to array' do
      ElasticRansack.val_to_array('2,3,4').should == [2, 3, 4]
    end

    it 'return if array' do
      array = [1, 2, 3]
      ElasticRansack.val_to_array(array).should == array
    end

    it 'return empty array if value evaluates to false' do
      ElasticRansack.val_to_array(nil).should == []
    end
  end

  describe '#normalize_vals' do
    it 'return value for non integer fields' do
      ElasticRansack.normalize_integer_vals('test', 'qwe').should == 'qwe'
    end

    it 'normalize integer field' do
      ElasticRansack.normalize_integer_vals('test_id_eq', '1 qwe').should == 1
    end

    it 'normalize integer field for array value' do
      ElasticRansack.normalize_integer_vals('test_id_eq', ['1 qwe', 2]).should == [1, 2]
    end
  end
end
