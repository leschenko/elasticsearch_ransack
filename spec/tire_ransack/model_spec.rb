require 'spec_helper'

class ModelBase < ActiveModelTireBase
end

describe TireRansack do
  subject { ModelBase }

  before :all do
    ModelBase.setup_index
  end

  it 'add tire_ransack method' do
    should respond_to(:tire_ransack)
  end

end
