# encoding: utf-8
require 'model_helper'
require 'app/models/unico/person'
require 'app/models/person'
require 'app/models/unico/address'
require 'app/models/address'
require 'app/models/special_entry'

describe SpecialEntry do
  it "delegate to person to_s method" do
    subject.build_person
    subject.person.name = 'Gabriel Sobrinho'
    subject.person.name.should eq subject.to_s
  end

  it { should have_one(:address).conditions(:correspondence => false) }
  it { should have_one(:correspondence_address).conditions(:correspondence => true) }
  it { should have_one :person }
end
