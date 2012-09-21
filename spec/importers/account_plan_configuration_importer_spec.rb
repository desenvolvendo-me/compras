# encoding: utf-8

require 'unit_helper'
require 'app/importers/account_plan_configuration_importer'

describe AccountPlanConfigurationImporter do
  subject do
    described_class.new(account_plan_configuration_repository, point_separator, state)
  end

  let(:account_plan_configuration_repository) do
    mock(:account_plan_configuration_repository)
  end

  let(:point_separator) do
    "."
  end

  let(:state) do
    mock(:state)
  end

  let(:config) do
    mock(:config)
  end

  it "should import the configuration" do
    state.should_receive(:id_by_acronym!).with("SP").and_return(1)

    account_plan_configuration_repository.should_receive(:create!).with({ :year => 2013,
                                                                          :state_id => 1,
                                                                          :description => "Novo Código AUDESP",
                                                                          :account_plan_levels_attributes => levels
                                                                         }).and_return(config)

    expect(subject.import!).to eq config
  end

  def levels
    [
      { :level => 7, :description => "Subitem",   :digits => 2, :separator => point_separator },
      { :level => 6, :description => "Item",      :digits => 2, :separator => point_separator },
      { :level => 5, :description => "Subtítulo", :digits => 1, :separator => point_separator },
      { :level => 4, :description => "Título",    :digits => 1, :separator => point_separator },
      { :level => 3, :description => "Subgrupo",  :digits => 1, :separator => point_separator },
      { :level => 2, :description => "Grupo",     :digits => 1, :separator => point_separator },
      { :level => 1, :description => "Classe",    :digits => 1, :separator => point_separator }
    ]
  end
end
