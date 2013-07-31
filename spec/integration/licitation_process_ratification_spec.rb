# encoding: UTF-8
require 'spec_helper'

describe LicitationProcessRatification do
  context 'validations' do
    describe 'licitation without proposal_envelope_opening_date' do
      let(:licitation_process) do
        LicitationProcess.make!(:processo_licitatorio_computador,
                                proposal_envelope_opening_date: nil)
      end

      it 'should return error over licitation process' do
        ratification = LicitationProcessRatification.make(
          :processo_licitatorio_computador,
          licitation_process: licitation_process)

        ratification.valid?

        expect(ratification.errors.to_a).to include "O processo de compra (#{licitation_process.to_s}) não tem data da Abertura da Proposta"
      end
    end

    describe 'licitation with proposal_envelope_opening_date' do
      let(:licitation_process) do
        LicitationProcess.make!(:processo_licitatorio_computador)
      end

      it 'should not return error over licitation process' do
        ratification = LicitationProcessRatification.make(
          :processo_licitatorio_computador,
          licitation_process: licitation_process)

        ratification.valid?

        expect(ratification.errors.to_a).to_not include "O processo de compra (#{licitation_process.to_s}) não tem data da Abertura da Proposta"
      end
    end
  end
end
