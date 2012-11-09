require 'spec_helper'

describe SequenceGenerator, 'ActiveRecord' do
  it 'should defines methods for the class' do
    expect(ActiveRecord::Base).to respond_to(:auto_increment)
  end

  context 'class without' do
    class BudgetAllocationWithoutOptions < Compras::Model
      self.table_name = 'compras_budget_allocations'
      auto_increment :code, :by => [:description]
    end

    it 'should store values in variables when call auto_increment' do
      expect(BudgetAllocationWithoutOptions.new.sequencer_field).to eq :code
      expect(BudgetAllocationWithoutOptions.new.sequence_group).to eq [:description]
    end

    it 'should have :before_create as default sequence update callback' do
      expect(BudgetAllocationWithoutOptions.new.sequencer_callback).to eq :before_create
    end

    it 'should set sequence update callback on auto_increment' do
      expect(BudgetAllocationWithoutOptions._create_callbacks.
                                     select { |cb| cb.kind.eql?(:before) }.
                                     collect(&:filter)).
                                     to include(:set_next_sequence)
    end

    it 'should return the correct sequential number' do
      b = BudgetAllocationWithoutOptions.new(:description => 'description')
      b.should_receive(:last_sequence).and_return(0)
      b.save

      expect(b.code).to eq 1

      b = BudgetAllocationWithoutOptions.new(:description => 'description')
      b.should_receive(:last_sequence).and_return(1)
      b.save

      expect(b.code).to eq 2
    end

    it 'should not increase the sequence if has already a sequence' do
      b = BudgetAllocationWithoutOptions.new(:code => 1)
      b.should_not_receive(:next_sequence)
      b.save

      expect(b.code).to eq 1
    end
  end

  context 'class with options' do
    class BudgetAllocationWithOptions < Compras::Model
      self.table_name = 'compras_budget_allocations'
      auto_increment :code, :by => :descriptor_id, :on => :before_save
    end

    it 'should have :before_save as callback' do
      expect(BudgetAllocationWithOptions.new.sequencer_callback).to eq :before_save

      expect(BudgetAllocationWithOptions._save_callbacks.
                                  select { |cb| cb.kind.eql?(:before) }.
                                  collect(&:filter)).
                                  to include(:set_next_sequence)
    end

    it 'should force by to array' do
      expect(BudgetAllocationWithOptions.new.sequence_group).to eq [:descriptor_id]
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
      b.should_receive(:last_sequence).and_return(0)
      b.save

      expect(b.code).to eq 1

      b = BudgetAllocationWithScope.new(:kind => 'little')
      b.should_receive(:last_sequence).and_return(1)
      b.save

      expect(b.code).to eq 2

      b = BudgetAllocationWithScope.new(:kind => 'big')
      b.should_receive(:last_sequence).and_return(0)
      b.save

      expect(b.code).to eq 1
    end
  end
end
