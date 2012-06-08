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
  it { should validate_presence_of :revocation_date }

  it { should allow_value('2012').for(:fiscal_year) }
  it { should_not allow_value('212').for(:fiscal_year) }
  it { should_not allow_value('2a12').for(:fiscal_year) }

  it 'should return number/fiscal year as to_s method' do
    subject.fiscal_year = 2012
    subject.stub(:count_crc).and_return(1)

    subject.to_s.should eq "1/2012"
  end
end
