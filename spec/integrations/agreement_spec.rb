# encoding: utf-8
require 'spec_helper'

describe Agreement do
  context '#status' do
    it 'should return active when first occurrence is in_progress' do
      subject = Agreement.make!(:apoio_ao_turismo_with_2_occurrences)

      expect(subject.status).to be Status::ACTIVE
    end

    it 'should return inactive when first occurrence is not in_progress' do
      subject = Agreement.make!(:apoio_ao_turismo_with_2_occurrences_inactive)

      expect(subject.status).to be Status::INACTIVE
    end
  end
end
