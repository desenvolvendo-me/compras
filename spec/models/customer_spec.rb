require 'model_helper'
require 'app/models/customer'

describe Customer do
  it "return name on to_s" do
    subject.name = 'Belo Horizonte'
    subject.name.should eq subject.to_s
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :domain }
  it { should validate_presence_of :database }

end
