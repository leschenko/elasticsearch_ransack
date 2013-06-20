require 'spec_helper'

describe ElasticRansack::Predicate do
  it 'require :query option' do
    expect { ElasticRansack::Predicate.new('test', {}) }.to raise_error(ArgumentError, ':query option is required')
  end

  it 'creates regexp based on name' do
    predicate = ElasticRansack::Predicate.new('test', {query: proc {} })
    predicate.regexp.should == /^(.+)_test$/
  end
end