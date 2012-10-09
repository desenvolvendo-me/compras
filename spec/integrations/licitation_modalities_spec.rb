require 'spec_helper'

describe LicitationModality do

  describe "#invitation_letter" do

    it "has a default value of false" do
      licitation_modality = LicitationModality.make!(:publica)
      expect(licitation_modality.invitation_letter?).to eq false
    end
  end
end
