# encoding: utf-8
require 'model_helper'
require 'app/models/reserve_fund_annul'

describe ReserveFundAnnul do
  it { should belong_to :employee }
  it { should belong_to :reserve_fund }

  it { should validate_presence_of :employee }
  it { should validate_presence_of :date }
end
