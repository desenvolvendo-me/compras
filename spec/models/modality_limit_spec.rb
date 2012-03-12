require 'model_helper'
require 'app/models/modality_limit'

describe ModalityLimit do
  it 'should return ordinance_number as to_s' do
    subject.ordinance_number = '9999'
    subject.to_s.should eq '9999'
  end

  it { should validate_presence_of :validity_beginning }
  it { should validate_presence_of :ordinance_number }
  it { should validate_presence_of :published_date }
  it { should validate_presence_of :without_bidding }
  it { should validate_presence_of :invitation_letter }
  it { should validate_presence_of :taken_price }
  it { should validate_presence_of :public_competition }
  it { should validate_presence_of :work_without_bidding }
  it { should validate_presence_of :work_invitation_letter }
  it { should validate_presence_of :work_taken_price }
  it { should validate_presence_of :work_public_competition }

  it { should_not allow_value('ab/-9').for(:validity_beginning) }
  it { should_not allow_value('14/2012').for(:validity_beginning) }
  it { should allow_value('12/2012').for(:validity_beginning) }

  it { should_not allow_value('ac99').for(:ordinance_number) }
  it { should_not allow_value('5').for(:ordinance_number) }
  it { should allow_value('0005').for(:ordinance_number) }
  it { should allow_value('4325').for(:ordinance_number) }
end
