# encoding: utf-8
require 'model_helper'
require 'app/models/unico/person'
require 'app/models/person'
require 'app/models/unico/address'
require 'app/models/address'
require 'app/models/unico/individual'
require 'app/models/individual'
require 'app/models/unico/identity'
require 'app/models/identity'
require 'app/models/licitation_commission_responsible'
require 'app/models/licitation_commission_member'
require 'app/models/judgment_commission_advice_member'

describe Individual do
  it "delegate to person to_s method" do
    subject.build_person
    subject.person.name = 'Gabriel Sobrinho'
    subject.person.name.should eq subject.to_s
  end

  it { should have_many(:licitation_commission_responsibles).dependent(:restrict) }
  it { should have_many(:licitation_commission_members).dependent(:restrict) }
  it { should have_many(:judgment_commission_advice_members).dependent(:restrict) }

  it { should validate_presence_of :mother }
  it { should validate_presence_of :birthdate }
  it { should validate_presence_of :identity }
end
