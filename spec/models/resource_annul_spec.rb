# encoding: utf-8
require 'model_helper'
require 'app/models/resource_annul'

describe ResourceAnnul do
  it { should belong_to :resource }
  it { should belong_to :employee }

  it { should validate_presence_of :date }
  it { should validate_presence_of :employee }
  it { should validate_presence_of :resource }
end
