require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/bank_account_capabilities_status_verifier'

describe BankAccountCapabilitiesStatusVerifier do

  context "update date and status of capabilities" do
    let :capability1 do
      double(:status => nil, :date => nil, :inativation_date => nil)
    end

    let :capability2 do
      double(:status => nil, :date => nil, :inativation_date => nil)
    end

    let :capability3 do
      double(:status => nil, :date => nil, :inativation_date => nil)
    end

    let :capabilities do
      [capability1, capability2, capability3]
    end

    let :update_date do
      Date.new(2012, 1, 1)
    end

    it "first capability should receive active and current date" do
      capability1.should_receive(:active!)
      capability1.should_receive(:date=).with(update_date)
      capability1.should_receive(:save!).and_return(true)

      capability2.should_receive(:inactive!)
      capability2.should_receive(:date=).with(update_date)
      capability2.should_receive(:inactivation_date=).with(update_date)
      capability2.should_receive(:save!).and_return(true)

      capability3.should_receive(:inactive!)
      capability3.should_receive(:date=).with(update_date)
      capability3.should_receive(:inactivation_date=).with(update_date)
      capability3.should_receive(:save!).and_return(true)

      BankAccountCapabilitiesStatusVerifier.new(capabilities, update_date).verify!
    end
  end
end
