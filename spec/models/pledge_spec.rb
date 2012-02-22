# encoding: utf-8
require 'model_helper'
require 'app/models/pledge'

describe Pledge do
  it { should belong_to :entity }
  it { should belong_to :management_unit }
  it { should belong_to :commitment_type }
  it { should belong_to :budget_allocation }
  it { should belong_to :pledge_category }

  it 'should return id as to_s method' do
    subject.id = '1'

    subject.to_s.should eq '1'
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  it "should not have emission_date less than today" do
    subject.emission_date = Date.current - 1

    subject.valid?

    subject.errors[:emission_date].should include("deve ser em ou depois de #{I18n.l Date.current}")
  end
end
