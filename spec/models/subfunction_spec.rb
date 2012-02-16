# encoding: utf-8
require 'model_helper'
require 'app/models/subfunction'

describe Subfunction do
  it "should return code and description as to_s method" do
    subject.code = '01'
    subject.description = 'Subfunção'

    subject.to_s.should eq '01 - Subfunção'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_presence_of :function_id }
end
