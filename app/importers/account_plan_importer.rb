# encoding: utf-8
class AccountPlanImporter < Importer
  attr_accessor :repository, :nature_balance, :nature_information,
                :surplus_indicator, :nature_balance_variation,
                :movimentation_kind, :checking_account_repository

  def initialize(repository = AccountPlan, nature_balance = NatureBalance, nature_information = NatureInformation, surplus_indicator = SurplusIndicator, nature_balance_variation = NatureBalanceVariation, movimentation_kind = MovimentationKind, checking_account_repository = CheckingAccountOfFiscalAccount)
    self.repository = repository
    self.nature_balance = nature_balance
    self.nature_information = nature_information
    self.surplus_indicator = surplus_indicator
    self.nature_balance_variation = nature_balance_variation
    self.movimentation_kind = movimentation_kind
    self.checking_account_repository = checking_account_repository
  end

  def import!
    transaction do
      parser.foreach(file, options) do |row|
        account_plan = repository.new(normalize_attributes(row.to_hash))
        account_plan.save(:validate => false)
      end
    end
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge(
      "title" => attributes["title"],
      "bookkeeping" => value_for_bookkeeping(attributes),
      "nature_balance" => value_for_nature_balance(attributes),
      "nature_information" => value_for_nature_information(attributes),
      "surplus_indicator" => value_for_surplus_indicator(attributes),
      "nature_balance_variation" => value_for_nature_balance_variation(attributes),
      "movimentation_kind" => value_for_movimentation_kind(attributes),
      "ends_at_twelfth_month" => value_for_ends_at_twelfth_month(attributes),
      "ends_at_thirteenth_month" => value_for_ends_at_thirteenth_month(attributes),
      "ends_at_fourteenth_month" => value_for_ends_at_fourteenth_month(attributes),
      "does_not_ends" => value_for_does_not_ends(attributes),
      "detailing_required_opening" => value_for_detailing_required_opening(attributes),
      "detailing_required_thirteenth" => value_for_detailing_required_thirteenth(attributes),
      "detailing_required_fourteenth" => value_for_detailing_required_thirteenth(attributes),
      "checking_account_of_fiscal_account_id" => value_for_checking_account_of_fiscal_account_id(attributes)
    ).except('end', 'checking_account_of_fiscal_account')
  end

  def value_for_checking_account_of_fiscal_account_id(attributes)
    unless attributes["checking_account_of_fiscal_account"].blank?
      tce_code = attributes["checking_account_of_fiscal_account"].match(/[0-9]+/)[0]
      checking_account_repository.find_by_tce_code!(tce_code).try(:id)
    end
  end

  def value_for_bookkeeping(attributes)
    attributes["bookkeeping"] == "S"
  end

  def value_for_nature_balance(attributes)
    case attributes["nature_balance"]
    when "D"
      nature_balance.value_for('DEBT')
    when "C"
      nature_balance.value_for('CREDIT')
    end
  end

  def value_for_nature_information(attributes)
    case attributes["nature_information"]
    when "P"
      nature_information.value_for('PATRIMONIAL')
    when "O"
      nature_information.value_for('BUDGET')
    when "C"
      nature_information.value_for('COMPENSATED')
    end
  end

  def value_for_surplus_indicator(attributes)
    case attributes["surplus_indicator"]
    when "F"
      surplus_indicator.value_for('FINANCIAL')
    when "P"
      surplus_indicator.value_for('PERMANENT')
    end
  end

  def value_for_nature_balance_variation(attributes)
    case attributes["nature_balance_variation"]
    when "NIS"
      nature_balance_variation.value_for('NOT_REVERSE_BALANCE')
    when "IS"
      nature_balance_variation.value_for('REVERSE_BALANCE')
    end
  end

  def value_for_movimentation_kind(attributes)
    case attributes["movimentation_kind"]
    when "B"
      movimentation_kind.value_for('BILATERAL')
    when "UD"
      movimentation_kind.value_for('UNILATERAL_BORROWING')
    when "UC"
      movimentation_kind.value_for('UNILATERAL_CREDITOR')
    end
  end

  def value_for_ends_at_twelfth_month(attributes)
    attributes['end'] == 'M12'
  end

  def value_for_ends_at_thirteenth_month(attributes)
    attributes['end'] == 'M13'
  end

  def value_for_ends_at_fourteenth_month(attributes)
    attributes['end'] == 'M14'
  end

  def value_for_does_not_ends(attributes)
    attributes['end'] == 'NENC'
  end

  def value_for_detailing_required_opening(attributes)
    attributes["detailing_required_opening"] == "S"
  end

  def value_for_detailing_required_thirteenth(attributes)
    attributes["detailing_required_thirteenth"] == "S"
  end

  def value_for_detailing_required_thirteenth(attributes)
    attributes["detailing_required_thirteenth"] == "S"
  end

  def file
    "lib/import/files/account_plan.csv"
  end
end
