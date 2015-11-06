require 'spec_helper'

describe 'sorting' do
  before :all do
    @model = ModelSearch
    @model.setup_index
  end

  it 'default sort by id desc' do
    @model.elastic_ransack.map(&:id).map(&:to_i).should eq [3, 2, 1]
  end

  it 'custom sort' do
    @model.elastic_ransack(s: 'float_attr').map(&:id).map(&:to_i).should eq [1, 3, 2]
  end

  it 'custom sort mode' do
    @model.elastic_ransack(s: 'float_attr desc').map(&:id).map(&:to_i).should eq [2, 3, 1]
  end

  it 'custom sort by multiple fields' do
      @model.elastic_ransack(s: 'one_assoc_id desc created_at desc').map(&:id).map(&:to_i).should eq [3, 2, 1]
  end

end
