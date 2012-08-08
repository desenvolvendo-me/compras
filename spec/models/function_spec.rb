# encoding: utf-8
require 'model_helper'
require 'app/models/function'
require 'app/models/subfunction'

describe Function do
  it "should return the code and description as to_s method" do
    subject.code = '4'
    subject.description = 'Administração'

    expect(subject.to_s).to eq '4 - Administração'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_numericality_of :code }

  it { should have_many(:subfunctions).dependent(:restrict) }
end
