require 'spec_helper'

describe ElasticRansack do
  subject { ModelSearch }

  before :all do
    ModelSearch.setup_index
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
end
