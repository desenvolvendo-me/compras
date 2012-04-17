# encoding: utf-8
require 'model_helper'
require 'app/models/pledge_expiration'
require 'app/models/pledge_cancellation'

describe PledgeExpiration do
  it { should belong_to :pledge }
  it { should have_many(:pledge_cancellations).dependent(:restrict) }

  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :value }
end
