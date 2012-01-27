# encoding: utf-8
require 'model_helper'
require 'app/models/service_type'

describe ServiceType do
  it 'should return name as to_s method' do
    subject.name = 'Contratação de estagiários'
    subject.to_s.should eq 'Contratação de estagiários'
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :service_goal }
end
