require 'spec_helper'

describe 'string lucene query escaping' do
  it do
    'string'.should respond_to(:lucene_escape)
  end

  %w( + - && || ! ( ) { } [ ] ^ " ~ * ? : / ).each do |char|
    it "escape #{char}" do
      "abc #{char} edf".lucene_escape.should == "abc \\#{char} edf"
    end
  end

  it 'escape \ ' do
    "abc \\ edf".lucene_escape.should == "abc \\\\ edf"
  end

end