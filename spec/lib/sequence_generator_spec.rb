require 'spec_helper'

describe SequenceGenerator, 'ActiveRecord' do
  it 'should defines methods for the class' do
    ActiveRecord::Base.should respond_to(:auto_increment)
    ActiveRecord::Base.should respond_to(:set_sequence_updater_callback)
  end

  it 'should defines variables for the class' do
    ActiveRecord::Base.should respond_to(:sequencer_field)
    ActiveRecord::Base.should respond_to(:sequencer_callback)
    ActiveRecord::Base.should respond_to(:sequence_group)

    ActiveRecord::Base.should respond_to(:sequencer_field=)
    ActiveRecord::Base.should respond_to(:sequencer_callback=)
    ActiveRecord::Base.should respond_to(:sequence_group=)
  end

  context 'class without' do
    class BudgetAllocationWithoutOptions < Compras::Model
      self.table_name = 'compras_budget_allocations'
      auto_increment :code, :by => [:description]
    end

    it 'should defines methods for the instance' do
      BudgetAllocationWithoutOptions.new.should respond_to(:set_next_sequence)
      BudgetAllocationWithoutOptions.new.should respond_to(:sequence_value)
      BudgetAllocationWithoutOptions.new.should respond_to(:sequence_query)
      BudgetAllocationWithoutOptions.new.should respond_to(:last_sequence)
      BudgetAllocationWithoutOptions.new.should respond_to(:next_sequence)
    end

    it 'should store values in variables when call auto_increment' do
      BudgetAllocationWithoutOptions.new.sequencer_field.should eq :code
      BudgetAllocationWithoutOptions.new.sequence_group.should eq [:description]
    end

    it 'should have :before_create as default sequence update callback' do
      BudgetAllocationWithoutOptions.new.sequencer_callback.should eq :before_create
    end

    it 'should set sequence update callback on auto_increment' do
      BudgetAllocationWithoutOptions._create_callbacks.
                                     select { |cb| cb.kind.eql?(:before) }.
                                     collect(&:filter).
                                     should include(:set_next_sequence)
    end

    it 'should return the correct sequential number' do
      b = BudgetAllocationWithoutOptions.new(:description => 'description')
      b.should_receive(:last_sequence).and_return(0)
      b.save

      b.code.should eq 1

      b = BudgetAllocationWithoutOptions.new(:description => 'description')
      b.should_receive(:last_sequence).and_return(1)
      b.save

      b.code.should eq 2
    end

    it 'should not increase the sequence if has already a sequence' do
      b = BudgetAllocationWithoutOptions.new(:code => 1)
      b.should_not_receive(:next_sequence)
      b.save

      b.code.should eq 1
    end
  end

  context 'class with options' do
    class BudgetAllocationWithOptions < Compras::Model
      self.table_name = 'compras_budget_allocations'
      auto_increment :code, :by => [:descriptor_id], :on => :before_save
    end

    it 'should have :before_save as callback' do
      BudgetAllocationWithOptions.new.sequencer_callback.should eq :before_save

      BudgetAllocationWithOptions._save_callbacks.
                                  select { |cb| cb.kind.eql?(:before) }.
                                  collect(&:filter).
                                  should include(:set_next_sequence)
    end
  end
end
