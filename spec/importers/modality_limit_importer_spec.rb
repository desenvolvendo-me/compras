# encoding: utf-8
require 'importer_helper'
require 'app/importers/modality_limit_importer'

describe ModalityLimitImporter do
  subject do
    described_class.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'import' do
    null_repository.should_receive(:create!).with(
      'without_bidding' => '8000.0',
      'invitation_letter' => '80000.0',
      'taken_price' => '650000.0',
      'public_competition' => '99999999.99',
      'work_without_bidding' => '15000.0',
      'work_invitation_letter' => '150000.0',
      'work_taken_price' => '1500000.0',
      'work_public_competition' => '99999999.99')

    subject.import!
  end
end
