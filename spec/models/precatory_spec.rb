#encoding: utf-8
require 'model_helper'
require 'app/models/precatory'
require 'app/models/creditor'

describe Precatory do
  it { should belong_to :creditor }

  it "should return id when call to_s method" do
    subject.number = '1234/2012'

    expect(subject.to_s).to eq "1234/2012"
  end
end
