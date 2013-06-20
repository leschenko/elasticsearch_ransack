require 'spec_helper'

describe 'sorting' do
  before :all do
    @model = ModelSearch
    @model.setup_index
  end

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
