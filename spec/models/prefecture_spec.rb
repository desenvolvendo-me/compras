require 'model_helper'
require 'app/models/prefecture'
require 'app/models/address'

describe Prefecture do
  it 'return name when converted to string' do
    subject.name = 'Apucarana'
    subject.name.should eq subject.to_s
  end

  it { should have_one :address }

  it { should validate_presence_of :name }
  it { should validate_presence_of :mayor_name }

  it { should allow_value('gabriel.sobrinho@gmail.com').for(:email) }
  it { should_not allow_value('missing.host').for(:email) }
end
