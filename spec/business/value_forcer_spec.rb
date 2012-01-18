require 'unit_helper'
require 'app/business/value_forcer'

describe ValueForcer do

  let :resource do
    mock('Resource')
  end

  it "the value should be forced" do
    resource.should_receive(:send).with('forced_final_value').and_return(50)
    resource.should_receive(:send).with('final_value=', 50)

    ValueForcer.new(resource, :final_value).force!
  end

  it "the value should not be forced" do
    resource.should_receive(:send).with('forced_final_value').and_return(nil)
    resource.should_receive(:send).with('final_value=').never

    ValueForcer.new(resource, 'final_value').force!
  end
end
