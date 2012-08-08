require 'unit_helper'
require 'app/business/direct_purchase_modality_limit_verificator'

describe DirectPurchaseModalityLimitVerificator do
  context 'when do not have previous value' do
    let :direct_purchase do
      double('direct purchase', :licitation_object_purchase_licitation_exemption => 400.0,
                                :licitation_object_build_licitation_exemption => 500.0,
                                :total_allocations_items_value_was => 0)
    end

    let :limit_repository do
      double('modality limit', :current_limit_material_or_service_without_bidding => 500.0,
                               :current_limit_engineering_works_without_bidding => 700.0)
    end

    let :subject do
      DirectPurchaseModalityLimitVerificator.new(direct_purchase, limit_repository)
    end

    context 'when material_or_service?' do
      before do
        direct_purchase.stub(:material_or_service?).and_return(true)
        direct_purchase.stub(:engineering_works?).and_return(false)
      end

      context 'and total is less than limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(50)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).to be_value_less_than_available_limit
        end
      end

      context 'and total is equals to limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(100)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).to be_value_less_than_available_limit
        end
      end

      context 'and total is greater than limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(1500)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).not_to be_value_less_than_available_limit
        end
      end
    end

    context 'when engineering_works?' do
      before do
        direct_purchase.stub(:material_or_service?).and_return(false)
        direct_purchase.stub(:engineering_works?).and_return(true)
      end

      context 'and total less than limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(100)
        end

        it 'should return true with modality engineering_works and total of item equal to 200' do
          expect(subject).to be_value_less_than_available_limit
        end
      end

      context 'and total is equals to limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(200)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).to be_value_less_than_available_limit
        end
      end

      context 'and total is greater than limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(1700)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).not_to be_value_less_than_available_limit
        end
      end
    end
  end

  context 'when have previous value' do
    let :direct_purchase do
      double('direct purchase', :licitation_object_purchase_licitation_exemption => 400.0,
                                :licitation_object_build_licitation_exemption => 500.0,
                                :total_allocations_items_value_was => 50)
    end

    let :limit_repository do
      double('modality limit', :current_limit_material_or_service_without_bidding => 500,
                               :current_limit_engineering_works_without_bidding => 700)
    end

    let :subject do
      DirectPurchaseModalityLimitVerificator.new(direct_purchase, limit_repository)
    end

    context 'when material_or_service?' do
      before do
        direct_purchase.stub(:material_or_service?).and_return(true)
        direct_purchase.stub(:engineering_works?).and_return(false)
      end

      context 'and total is less than limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(10)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).to be_value_less_than_available_limit
        end
      end

      context 'and total is equals to limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(50)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).to be_value_less_than_available_limit
        end
      end

      context 'and total is greater than limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(1500)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).not_to be_value_less_than_available_limit
        end
      end
    end

    context 'when engineering_works?' do
      before do
        direct_purchase.stub(:material_or_service?).and_return(false)
        direct_purchase.stub(:engineering_works?).and_return(true)
      end

      context 'and total less than limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(100)
        end

        it 'should return true with modality engineering_works and total of item equal to 200' do
          expect(subject).to be_value_less_than_available_limit
        end
      end

      context 'and total is equals to limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(150)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).to be_value_less_than_available_limit
        end
      end

      context 'and total is greater than limit' do
        before do
          direct_purchase.stub(:total_allocations_items_value).and_return(1700)
        end

        it 'should be value_less_than_available_limit' do
          expect(subject).not_to be_value_less_than_available_limit
        end
      end
    end
  end
end
