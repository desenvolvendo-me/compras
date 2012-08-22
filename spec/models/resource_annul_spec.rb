# encoding: utf-8
require 'model_helper'
require 'lib/annullable'
require 'app/models/resource_annul'

describe ResourceAnnul do
  it { should belong_to :annullable }
  it { should belong_to :employee }

  it { should validate_presence_of :date }
  it { should validate_presence_of :employee }
  it { should validate_presence_of :annullable }

  context '#annulled?' do
    let :annullable do
      double(:annullable, :annulled? => true)
    end

    it 'delegates to annullable' do
      subject.stub(:annullable => annullable)

      expect(subject).to be_annulled
    end
  end

  context 'with annullable' do
    let :annullable do
      double(:annullable)
    end

    it 'should return purchase_solicitation_ids if annullable respond_to? it' do
      annullable.stub(:purchase_solicitation_ids).and_return([1, 2, 3])

      subject.stub(:annullable).and_return(annullable)

      expect(subject.purchase_solicitation_ids).to eq [1, 2, 3]
    end

    it 'should return nil if annullable does not respond_to? purchase_solicitation_ids' do
      subject.stub(:annullable).and_return(annullable)

      expect(subject.purchase_solicitation_ids).to eq nil
    end
  end
end
