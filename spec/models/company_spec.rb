# encoding: utf-8
require 'model_helper'
require 'app/models/person'
require 'app/models/company'
require 'app/models/address'

describe Company do
  it "converted to name when call to_s" do
    subject.build_person
    subject.person.name = 'Banco do Brasil'
    subject.to_s.should eq subject.person.name
  end

  describe "validating cnpj" do
    it "with invalid cnpjs" do
      %w(00.001.000/1010-64 00.000.000/0883-84 00000000098889).each do |cnpj|
        subject.cnpj = cnpj
        subject.valid?
        subject.errors[:cnpj].should include 'não é válido'
      end
    end

    it "with valid cnpjs" do
      %w(00.000.000/1000-64 00.000.000/0993-84 00.000.000/0988-17).each do |cnpj|
        subject.cnpj = cnpj
        subject.valid?
        subject.errors[:cnpj].should be_empty
      end
    end
  end

  it { should have_one(:address).dependent(:destroy).conditions(:correspondence => false) }
  it { should have_one(:correspondence_address).dependent(:destroy).conditions(:correspondence => true) }

  it { should have_one :person }
  it { should belong_to :legal_nature }
  it { should belong_to :responsible }
  it { should belong_to :company_size }

  it { should validate_presence_of :cnpj }
  it { should validate_presence_of :company_size }
  it { should validate_presence_of :address }
  it { should validate_presence_of :responsible_role }
  it { should validate_presence_of :legal_nature }
  it { should validate_presence_of :responsible }

end
