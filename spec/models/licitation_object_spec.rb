# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_object'

describe LicitationObject do
  it 'should return description as to_s method' do
    subject.description = 'Objeto'

    subject.to_s.should eq 'Objeto'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :year }
  it { should validate_presence_of :purchase_licitation_exemption }
  it { should validate_presence_of :purchase_invitation_letter }
  it { should validate_presence_of :purchase_taking_price }
  it { should validate_presence_of :purchase_public_concurrency }
  it { should validate_presence_of :build_licitation_exemption }
  it { should validate_presence_of :build_invitation_letter }
  it { should validate_presence_of :build_taking_price }
  it { should validate_presence_of :build_public_concurrency }
  it { should validate_presence_of :special_auction }
  it { should validate_presence_of :special_unenforceability }
  it { should validate_presence_of :special_contest }

  it { should_not allow_value('a2012').for(:year) }
  it { should allow_value('2012').for(:year) }

  it { should have_many(:direct_purchases).dependent(:restrict) }
end
