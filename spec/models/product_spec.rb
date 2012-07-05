# encoding: utf-8
require 'model_helper'
require 'app/models/product'

describe Product do
  it { should validate_presence_of :specification }

  it "should return specification as to_s" do
    subject.specification = 'Lápis'

    subject.to_s.should eq 'Lápis'
  end
end
