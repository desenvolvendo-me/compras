require 'spec_helper'

class CreditorProvider < Provider
  provide :id, :name
  provide :to_s

  def name
    'my_name'
  end
end

describe CreditorProvider do
  context 'with subject' do
    let(:sobrinho) { Creditor.make!(:sobrinho) }
    let(:wenderson) { Creditor.make!(:wenderson_sa) }

    subject do
      CreditorProvider.new(sobrinho)
    end

    describe '#to_json' do
      context 'without options' do
        it 'should return only fields/methods specified on provide' do
          data = JSON.parse(subject.to_json).symbolize_keys!

          expect(data).to eq({
            id: sobrinho.id,
            name: "my_name",
            to_s: "Gabriel Sobrinho"
          })
        end
      end

      context 'with options only' do
        context 'with only one only options not being an array' do
          it 'should return only fields/methods specified on provide and limited by only' do
            data = JSON.parse(subject.to_json(only: :id)).symbolize_keys!

            expect(data).to eq({ id: sobrinho.id })
          end
        end

        context 'with options being an array' do
          it 'should return only fields/methods specified on provide and limited by only' do
            data = JSON.parse(subject.to_json(only: [:id, :name])).symbolize_keys!

            expect(data).to eq({ id: sobrinho.id, name: "my_name" })
          end
        end
      end
    end

    describe '#==' do
      it 'should compare the component with other' do
        expect(subject).to eq CreditorProvider.new(sobrinho)
        expect(subject).to_not eq CreditorProvider.new(wenderson)
      end
    end

    describe '#to_s' do
      context 'when has an component' do
        it "should return the component' to_s" do
          expect(subject.to_s).to eq sobrinho.to_s
        end
      end
    end
  end

  describe '.build_array' do
    it 'should wrapp all objects of array with ApiResource' do
      sobrinho = Creditor.make!(:sobrinho)
      wenderson = Creditor.make!(:wenderson_sa)

      expect(described_class.build_array([sobrinho, wenderson])).to eq [CreditorProvider.new(sobrinho), CreditorProvider.new(wenderson)]
    end
  end
end
