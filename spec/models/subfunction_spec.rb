# encoding: utf-8
require 'model_helper'
require 'app/models/subfunction'
require 'app/models/budget_allocation'

describe Subfunction do
  it "should return code and description as to_s method" do
    subject.code = '01'
    subject.description = 'Subfunção'

    expect(subject.to_s).to eq '01 - Subfunção'
  end

  it { should belong_to :descriptor }
  it { should belong_to :function }

  it { should have_many(:budget_allocations).dependent(:restrict) }
end
