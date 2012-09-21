# encoding: utf-8

class AccountPlanConfigurationImporter
  attr_accessor :account_plan_configuration_repository, :point_separator, :state

  def initialize(account_plan_configuration_repository = AccountPlanConfiguration, point_separator = AccountPlanSeparator::POINT, state = State)
    self.account_plan_configuration_repository = account_plan_configuration_repository
    self.point_separator                       = point_separator
    self.state                                 = state
  end

  def import!
    account_plan_configuration_repository.create!(:year =>  2013,
                                                 :state_id => state.id_by_name!("São Paulo"),
                                                 :description => "Novo Código AUDESP",
                                                 :account_plan_levels_attributes => levels
                                                )
  end

  protected

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
