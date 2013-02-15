require 'unit_helper'
require 'lib/nil_customer'

describe NilCustomer do
  describe "#id" do
    it "returns nil" do
      expect(subject.id).to be_nil
    end
  end

  describe "#domain" do
    it "returns nil" do
      expect(subject.domain).to be_nil
    end
  end

  describe "#database" do
    it "returns nil" do
      expect(subject.database).to be_nil
    end
  end

  describe "#cache_key" do
    it "returns nil" do
      expect(subject.cache_key).to eq "nil-customer"
    end
  end

  describe "#using_connection" do
    it "calls a block" do
      block = lambda { }

      block.should_receive(:call)

      subject.using_connection(&block)
    end
  end
end
