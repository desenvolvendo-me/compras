# encoding: utf-8
require 'model_helper'
require 'app/models/person'
require 'app/models/address'
require 'app/models/individual'
require 'app/models/identity'

describe Individual do
  it "delegate to person to_s method" do
    subject.build_person
    subject.person.name = 'Gabriel Sobrinho'
    subject.person.name.should eq subject.to_s
  end

  it "be invalid with invalid cpfs" do
    %w(00000321837556 01.000.000/0883-84 80000008098888).each do |cpf|
      subject.cpf = cpf
      subject.valid?
      subject.errors[:cpf].should include 'não é válido'
    end
  end

  it "be valid with valid cpfs" do
    %w(003.218.345-34 003.214.865-87 003.214.470-93).each do |cpf|
      subject.cpf = cpf
      subject.valid?
      subject.errors[:cpf].should be_empty
    end
  end

  it { should have_one(:address).conditions(:correspondence => false) }
  it { should have_one(:correspondence_address).conditions(:correspondence => true) }
  it { should have_one :identity }
  it { should have_one :person }
  it { should have_many(:provider_partners).dependent(:restrict) }

  it { should validate_presence_of :cpf }
  it { should validate_presence_of :mother }
  it { should validate_presence_of :birthdate }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :address }
  it { should validate_presence_of :identity }

  it { should_not allow_value(Date.current).for(:birthdate) }
  it { should allow_value(Date.yesterday).for(:birthdate) }
end
