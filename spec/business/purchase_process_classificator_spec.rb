require 'unit_helper'
require 'app/business/purchase_process_classificator'

describe PurchaseProcessClassificator do
  subject do
    described_class.new(classification_a, classification_b)
  end

  let :classification_a do
    double(:classification_a)
  end

  let :classification_b do
    double(:classification_b)
  end

context 'with one benefited' do
  before do
    classification_a.stub(:benefited).and_return(false)
    classification_b.stub(:benefited).and_return(true)
  end

  context 'when draw by total value' do
    before do
      subject.stub(:classification_a_total_value).and_return(100)
      subject.stub(:classification_b_total_value).and_return(100)
    end

    context 'when will submit new proposal' do
      it 'should draw' do
        expect(subject.draw?).to be true
      end

      it 'should not have winner' do
        pending 'será removido na proxima apuração'
        expect(subject.winner).to eq nil
      end

      it 'should not have loser' do
        pending 'será removido na proxima apuração'
        expect(subject.loser).to eq nil
      end
    end

    context 'when will not submit new proposal' do
      it 'should not draw' do
        pending 'será removido na proxima apuração'
        expect(subject.draw?).to eq false
      end

      it 'should return classification not benefited as winner' do
        expect(subject.winner).to eq classification_a
      end

      it 'should return classification benefited as loser' do
        expect(subject.loser).to eq classification_b
      end
    end
    end # context 'when draw by total value'

    context 'when not draw by total value' do
      before do
        subject.stub(:classification_a_total_value).and_return(99)
        subject.stub(:classification_b_total_value).and_return(100)
      end

      context 'when will submit new proposal' do
        it 'should not draw' do
          expect(subject.draw?).to be false
        end

        it 'should have classification with lowest total price as winner' do
          expect(subject.winner).to eq classification_a
        end

        it 'should have classification with highest total price as loser' do
          expect(subject.loser).to eq classification_b
        end
      end

      context 'when will not submit new proposal' do
        it 'should not draw' do
          expect(subject.draw?).to eq false
        end

        it 'should have classification with lowest total price as winner' do
          expect(subject.winner).to eq classification_a
        end

        it 'should have classification with highest total price as loser' do
          expect(subject.loser).to eq classification_b
        end
      end # context 'when will not submit new proposal'
    end # context 'when not draw by total value'
  end # context 'with one benefited'

  context 'with both benefited' do
    before do
      classification_a.stub(:benefited).and_return(true)
      classification_b.stub(:benefited).and_return(true)
    end

    context 'when draw by total value' do
      before do
        subject.stub(:classification_a_total_value).and_return(100)
        subject.stub(:classification_b_total_value).and_return(100)
      end

      context 'when will submit new proposal' do
        it 'should draw' do
          expect(subject.draw?).to be true
        end

        it 'should not have winner' do
          expect(subject.winner).to eq nil
        end

        it 'should not have loser' do
          expect(subject.loser).to eq nil
        end
      end

      context 'when will not submit new proposal' do
        it 'should not draw' do
          expect(subject.draw?).to eq true
        end

        it 'should not have winner' do
          expect(subject.winner).to eq nil
        end

        it 'should not have loser' do
          expect(subject.loser).to eq nil
        end
      end
    end # context 'when draw by total value'

    context 'when not draw by total value' do
      before do
        subject.stub(:classification_a_total_value).and_return(99)
        subject.stub(:classification_b_total_value).and_return(100)
      end

      context 'when will submit new proposal' do
        it 'should not draw' do
          expect(subject.draw?).to be false
        end

        it 'should have classification with lowest total price as winner' do
          expect(subject.winner).to eq classification_a
        end

        it 'should have classification with highest total price as loser' do
          expect(subject.loser).to eq classification_b
        end
      end

      context 'when will not submit new proposal' do
        it 'should not draw' do
          expect(subject.draw?).to eq false
        end

        it 'should have classification with lowest total price as winner' do
          expect(subject.winner).to eq classification_a
        end

        it 'should have classification with highest total price as loser' do
          expect(subject.loser).to eq classification_b
        end
      end # context 'when will not submit new proposal'
    end # context 'when not draw by total value'
  end # context 'with both benefited'

  context 'with neither benefited' do
    before do
      classification_a.stub(:benefited).and_return(true)
      classification_b.stub(:benefited).and_return(true)
    end

    context 'when draw by total value' do
      before do
        subject.stub(:classification_a_total_value).and_return(100)
        subject.stub(:classification_b_total_value).and_return(100)
      end

      context 'when will submit new proposal' do
        it 'should draw' do
          expect(subject.draw?).to be true
        end

        it 'should not have winner' do
          expect(subject.winner).to eq nil
        end

        it 'should not have loser' do
          expect(subject.loser).to eq nil
        end
      end

      context 'when will not submit new proposal' do
        it 'should not draw' do
          expect(subject.draw?).to eq true
        end

        it 'should not have winner' do
          expect(subject.winner).to eq nil
        end

        it 'should not have loser' do
          expect(subject.loser).to eq nil
        end
      end
    end # context 'when draw by total value'

    context 'when not draw by total value' do
      before do
        subject.stub(:classification_a_total_value).and_return(99)
        subject.stub(:classification_b_total_value).and_return(100)
      end

      context 'when will submit new proposal' do
        it 'should not draw' do
          expect(subject.draw?).to be false
        end

        it 'should have classification with lowest total price as winner' do
          expect(subject.winner).to eq classification_a
        end

        it 'should have classification with highest total price as loser' do
          expect(subject.loser).to eq classification_b
        end
      end

      context 'when will not submit new proposal' do
        it 'should not draw' do
          expect(subject.draw?).to eq false
        end

        it 'should have classification with lowest total price as winner' do
          expect(subject.winner).to eq classification_a
        end

        it 'should have classification with highest total price as loser' do
          expect(subject.loser).to eq classification_b
        end
      end # context 'when will not submit new proposal'
    end # context 'when not draw by total value'
  end # context 'with neither benefited'
end
