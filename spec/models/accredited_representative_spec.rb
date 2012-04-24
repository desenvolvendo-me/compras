# encoding: utf-8
require 'model_helper'
require 'app/models/accredited_representative'
require 'app/models/accreditation'
require 'app/models/individual'
require 'app/models/provider'

describe AccreditedRepresentative do
  it { should belong_to(:accreditation) }
  it { should belong_to(:individual) }
  it { should belong_to(:provider) }

  it { should validate_presence_of(:accreditation) }
  it { should validate_presence_of(:individual) }
  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:role) }

  context "when given a provider that are not in licitation processes" do
    let :licitation_processes do
      double("licitation_processes")
    end

    let :provider do
      double("provider", :licitation_processes => licitation_processes)
    end

    let :accreditation do
      double("accreditation", :licitation_process_id => 1)
    end

    it "should include error cannot_have_providers_that_are_not_in_licitation_process" do
      licitation_processes.should_receive(:find_by_id).with(accreditation.licitation_process_id).and_return(nil)
      subject.stub(:accreditation => accreditation)
      subject.stub(:provider => provider)
      subject.valid?
      subject.errors[:provider].should include 'não pode ter fornecedores que não estejam no processo licitatório'
    end
  end

  context "when given a provider that are in licitation processes" do
    let :licitation_processes do
      double("licitation_processes")
    end

    let :provider do
      double("provider", :licitation_processes => licitation_processes)
    end

    let :accreditation do
      double("accreditation", :licitation_process_id => 1)
    end

    it "should include error cannot_have_providers_that_are_not_in_licitation_process" do
      licitation_processes.should_receive(:find_by_id).with(accreditation.licitation_process_id).and_return(provider)
      subject.stub(:accreditation => accreditation)
      subject.stub(:provider => provider)
      subject.valid?
      subject.errors[:provider].should_not include 'não pode ter fornecedores que não estejam no processo licitatório'
    end
  end
end
