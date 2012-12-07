require 'spec_helper'

describe TradingItem do
  describe 'validations' do
    subject do
      TradingItem.make!(:item_pregao_presencial)
    end

    context 'with both minimum_reductions' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 1.0,
          :minimum_reduction_percent => 1.0)
      end

      it "validates if minimum percent is zero if minimum_value is present" do
        subject.valid?

        expect(subject.errors[:minimum_reduction_value]).to include "deve ser igual a 0.0"
      end

      it "validates if minimum value is zero if minimum_percent is present" do
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to include "deve ser igual a 0.0"
      end

      it "validates if reduction percent is less than or equal to 100" do
        subject.minimum_reduction_percent = 101.0
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to include "deve ser menor ou igual a 100"
      end
    end

    context 'with no minimum_reduction_percent nor minimum_reduction_value' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 0.0,
          :minimum_reduction_percent => 0.0)
      end

      it 'validates at least one minimum_reduction' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_value]).to include "um dos campos precisa ser preenchido"
      end
    end

    context 'with minimum_reduction_percent' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 0.0,
          :minimum_reduction_percent => 10.0)
      end

      it 'does not validate at least one minimum_reduction when have minimum_reduction_percent' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_value]).to_not include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_percent]).to_not include "um dos campos precisa ser preenchido"
      end
    end

    context 'with minimum_reduction_percent' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 10.0,
          :minimum_reduction_percent => 0.0)
      end

      it 'does not validate at least one minimum_reduction when have minimum_reduction_value' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to_not include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_value]).to_not include "um dos campos precisa ser preenchido"
      end
    end
  end
end
