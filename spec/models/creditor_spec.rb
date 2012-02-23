require 'model_helper'
require 'app/models/creditor'

describe Creditor do
  it 'should return to_s as name' do
    subject.name = 'Empresa LTDA.'
    subject.to_s.should eq 'Empresa LTDA.'
  end

  it { should belong_to :entity }

  it { should validate_presence_of :name }
  it { should validate_presence_of :status }
  it { should validate_presence_of :entity }
end
