require 'spec_helper'

describe TireRansack::Predicate do
  it 'require :query option' do
    expect { TireRansack::Predicate.new('test', {}) }.to raise_error(ArgumentError, ':query option is required')
  end

  it 'creates regexp based on name' do
    predicate = TireRansack::Predicate.new('test', {query: proc {} })
    predicate.regexp.should == /^(.+)_test$/
  end
end