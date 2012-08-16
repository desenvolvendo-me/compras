require 'model_helper'
require 'app/models/management_unit'
require 'app/models/pledge'
require 'app/models/record_price'

describe ManagementUnit do
  it "should return the description as to_s method" do
    subject.description = "Central Unit"

    expect(subject.to_s).to eq "Central Unit"
  end

  it { should validate_presence_of(:descriptor) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:acronym) }
  it { should validate_presence_of(:status) }

  it { should belong_to(:descriptor) }

  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:record_prices).dependent(:restrict) }
end
