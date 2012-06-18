# encoding: utf-8
require 'model_helper'
require 'app/models/person'
require 'app/models/unico/company'
require 'app/models/company'
require 'app/models/unico/address'
require 'app/models/unico/partner'
require 'app/models/partner'

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

  context "with valid partners" do
    context "total percentage" do
      let :partner_one do
        Partner.new(:percentage => BigDecimal.new('75.00'))
      end

      let :partner_two do
        Partner.new(:percentage => BigDecimal.new('25.00'))
      end

      it "the total percentage of partners should not be greater than hundred percent" do
        subject.partners << partner_one
        subject.valid?
        subject.errors.messages[:partners].should include("o total das porcentagens deve ser 100%")
      end

      it "the total percentage of partners should not be less than hundred percent" do
        subject.partners << partner_one
        subject.valid?
        subject.errors.messages[:partners].should include("o total das porcentagens deve ser 100%")
      end

      it "the total percentage of partners should be hundred percent" do
        partner_one.percentage = 100
        subject.partners << partner_one
        subject.valid?
        subject.errors.messages[:partners].should be_nil
        subject.partners.first.errors.messages[:percentage].should be_nil
      end

      it "ignore the marked for destruction partner" do
        partner_one.percentage = 100
        subject.partners << partner_one
        subject.partners << partner_two
        subject.partners.last.mark_for_destruction
        subject.valid?
        subject.errors.messages[:partners].should be_nil
        subject.partners.first.errors.messages[:percentage].should be_nil
      end
    end

    context 'uniqueness of person_id' do
      let :partner_one do
        Partner.new :person_id => 1, :percentage => BigDecimal.new('80')
      end

      let :partner_two do
        Partner.new :person_id => 1, :percentage => BigDecimal.new('20')
      end

      it 'partner should_not be invalid when not duplicated' do
        partner_two.person_id = 2
        subject.partners = [partner_one, partner_two]
        subject.should_not be_valid
        subject.errors.messages[:partners].should be_nil
        subject.partners.last.errors.messages[:person_id].should be_nil
      end

      it 'should return correct validation for empty partner_id' do
        subject.partners = [Partner.new, Partner.new]
        subject.should_not be_valid
        subject.errors.messages[:partners].should include("o total das porcentagens deve ser 100%")
        subject.partners.last.errors.messages[:person_id].should_not be_nil
        subject.partners.last.errors.messages[:person_id].should_not include("já está em uso")
        subject.partners.last.errors.messages[:person_id].should include("não pode ficar em branco")
      end

      it 'partner should be invalid when duplicated' do
        subject.partners = [partner_one, partner_two]
        subject.should_not be_valid
        subject.errors.messages[:partners].should include("não é válido")
        subject.partners.last.errors.messages[:person_id].should include("já está em uso")
      end
    end
  end

  it { should have_one(:address).dependent(:destroy).conditions(:correspondence => false) }
  it { should have_one(:correspondence_address).dependent(:destroy).conditions(:correspondence => true) }
  it { should have_many(:partners).dependent(:destroy) }

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
