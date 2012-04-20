# encoding: utf-8
require 'model_helper'
require 'app/models/accreditation'
require 'app/models/licitation_commission'
require 'app/models/licitation_process'

describe Accreditation do
  it { should validate_presence_of(:licitation_process) }
  it { should validate_presence_of(:licitation_commission) }

  it { should belong_to(:licitation_process) }
  it { should belong_to(:licitation_commission) }

  it 'should return id as to_s method' do
    subject.id = 2

    subject.to_s.should eq '2'
  end
end
