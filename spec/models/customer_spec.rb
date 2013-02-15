require 'model_helper'
require 'app/models/unico/customer'
require 'app/models/customer'

describe Customer do
  describe "#cache_key" do
    it "returns the cache key" do
      subject.id = 10

      expect(subject.cache_key).to eq "customer-10"
    end
  end
end
