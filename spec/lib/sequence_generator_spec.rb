require 'spec_helper'

describe SequenceGenerator, 'ActiveRecord' do
  it 'should defines methods for the class' do
    expect(ActiveRecord::Base).to respond_to(:auto_increment)
  end

  context 'class without' do
    class PurchaseSolicitationWithoutOptions < Compras::Model
      self.table_name = 'compras_purchase_solicitations'
      auto_increment :code, :by => :accounting_year
    end

    it 'should store values in variables when call auto_increment' do
      expect(PurchaseSolicitationWithoutOptions.new.sequencer_field).to eq :code
      expect(PurchaseSolicitationWithoutOptions.new.sequence_group).to eq [:accounting_year]
    end

    it 'should have :before_create as default sequence update callback' do
      expect(PurchaseSolicitationWithoutOptions.new.sequencer_callback).to eq :before_create
    end

    it 'should set sequence update callback on auto_increment' do
      expect(PurchaseSolicitationWithoutOptions._create_callbacks.
                                     select { |cb| cb.kind.eql?(:before) }.
                                     collect(&:filter)).
                                     to include("(set_next_sequence_for_code)")
    end

    it 'should return the correct sequential number' do
      b = PurchaseSolicitationWithoutOptions.new(:accounting_year => '2012')
      b.should_receive(:last_sequence_for_code).and_return(0)
      b.save

      expect(b.code).to eq 1

      b = PurchaseSolicitationWithoutOptions.new(:accounting_year => '2012')
      b.should_receive(:last_sequence_for_code).and_return(1)
      b.save

      expect(b.code).to eq 2
    end

    it 'should not increase the sequence if has already a sequence' do
      b = PurchaseSolicitationWithoutOptions.new(:code => 1)
      b.should_not_receive(:next_sequence)
      b.save

      expect(b.code).to eq 1
    end
  end

  context 'class with options' do
    class BudgetAllocationWithOptions < Compras::Model
      self.table_name = 'compras_budget_allocations'
      auto_increment :code, :by => :accounting_year, :on => :before_save
    end

    it 'should have :before_save as callback' do
      expect(BudgetAllocationWithOptions.new.sequencer_callback).to eq :before_save

      expect(BudgetAllocationWithOptions._save_callbacks.
                                  select { |cb| cb.kind.eql?(:before) }.
                                  collect(&:filter)).
                                  to include("(set_next_sequence_for_code)")
    end

    it 'should force by to array' do
      expect(BudgetAllocationWithOptions.new.sequence_group).to eq [:accounting_year]
    end
  end

  context 'class with scope' do
    class BudgetAllocationWithScope < Compras::Model
      self.table_name = 'compras_budget_allocations'
      scope :same_kind_of, lambda { |ba| where(:kind => ba.kind) }
      auto_increment :code, :scope => :same_kind_of
    end

    it 'should store values in variables when call auto_increment' do
      expect(BudgetAllocationWithScope.new.query_scope).to eq :same_kind_of
    end

    it 'should return the correct sequential number' do
      b = BudgetAllocationWithScope.new(:kind => 'little')
      b.should_receive(:last_sequence_for_code).and_return(0)
      b.save

      expect(b.code).to eq 1

      b = BudgetAllocationWithScope.new(:kind => 'little')
      b.should_receive(:last_sequence_for_code).and_return(1)
      b.save

      expect(b.code).to eq 2

      b = BudgetAllocationWithScope.new(:kind => 'big')
      b.should_receive(:last_sequence_for_code).and_return(0)
      b.save

      expect(b.code).to eq 1
    end
  end
end
