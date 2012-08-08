# encoding: utf-8
require 'model_helper'
require 'app/models/registration_cadastral_certificate'

describe RegistrationCadastralCertificate do
  it { should belong_to :creditor }

  it { should validate_presence_of :fiscal_year }
  it { should validate_presence_of :specification }
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :registration_date }
  it { should validate_presence_of :validity_date }

  it { should allow_value('2012').for(:fiscal_year) }
  it { should_not allow_value('212').for(:fiscal_year) }
  it { should_not allow_value('2a12').for(:fiscal_year) }

  it 'should return number/fiscal year as to_s method' do
    subject.fiscal_year = 2012
    subject.stub(:count_crc).and_return(1)

    expect(subject.to_s).to eq "1/2012"
  end

  context 'validate creditor' do
    before do
      subject.stub(:creditor).and_return(creditor)
    end

    let :creditor do
      double('Creditor')
    end

    it 'should not be valid with creditor that is not company' do
      creditor.stub(:company?).and_return(false)

      subject.valid?
      expect(subject.errors[:creditor]).to_not be_empty
    end

    it 'should be valid with creditor that is company' do
      creditor.stub(:company?).and_return(true)

      subject.valid?
      expect(subject.errors[:creditor]).to be_empty
    end
  end

  context 'validate registration_date related with today' do
    it { should allow_value(Date.current).for(:registration_date) }

    it { should allow_value(Date.yesterday).for(:registration_date) }

    it 'should not allow date after today' do
      expect(subject).not_to allow_value(Date.tomorrow).for(:registration_date).
                                                    with_message("deve ser igual ou anterior a data atual (#{I18n.l(Date.current)})")
    end
  end

  it "should not allow revocation_date before registration_date" do
    subject.stub(:registration_date => Date.current)

    expect(subject).not_to allow_value(Date.yesterday).for(:revocation_date).
                                                   with_message("deve ser igual ou posterior a data da inscrição (#{I18n.l(Date.current)})")
  end

  it "should allow revocation_date on registration_date" do
    subject.stub(:registration_date => Date.current)

    expect(subject).to allow_value(Date.current).for(:revocation_date)
  end

  it "should allow revocation_date after registration_date" do
    subject.stub(:registration_date => Date.current)

    expect(subject).to allow_value(Date.tomorrow).for(:revocation_date)
  end

  context 'signatures' do
    let :signature_configuration_item1 do
      double('SignatureConfigurationItem1')
    end

    let :signature_configuration_item2 do
      double('SignatureConfigurationItem2')
    end

    let :signature_configuration_item3 do
      double('SignatureConfigurationItem3')
    end

    let :signature_configuration_item4 do
      double('SignatureConfigurationItem4')
    end

    let :signature_configuration_item5 do
      double('SignatureConfigurationItem5')
    end

    let :signature_configuration_items do
      [
        signature_configuration_item1,
        signature_configuration_item2,
        signature_configuration_item3,
        signature_configuration_item4,
        signature_configuration_item5
      ]
    end

    let :signature_configuration_item_store do
      double('SignatureConfigurationItemStore')
    end

    it 'should return related signatures' do
      signature_configuration_item_store.should_receive(:all_by_configuration_report).
                                         with('registration_cadastral_certificates').
                                         and_return(signature_configuration_items)
      expect(subject.signatures(signature_configuration_item_store)).to eq signature_configuration_items
    end
  end
end
