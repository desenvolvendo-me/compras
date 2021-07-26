class PurchaseProcessProposalEnvelopeOpeningDateCalculator
  def initialize(purchase_process, options = {})
    @purchase_process = purchase_process
    @date_calculator = options.fetch(:date_calculator) { DateCalculator }
  end

  def self.calculate(*args)
    new(*args).calculate
  end

  def calculate
    return unless can_calculate?

    send "#{modality}_calculator"
  end

  private

  attr_reader :purchase_process, :date_calculator

  def can_calculate?
    purchase_process.edital_published? && respond_to?("#{modality}_calculator", true)
  end

  def modality
    purchase_process.modality
  end

  def publication_date
    last_publication_edital.publication_date
  end

  def last_publication_edital
    purchase_process.published_editals.last
  end

  def calculate_date(days, context)
    date_calculator.calculate(publication_date, days, context)
  end

  def competition_calculator
    calculate_date(45, :calendar)
  end

  def concurrence_calculator
    if purchase_process.integral? && (purchase_process.judgment_form_best_technique? || purchase_process.judgment_form_technical_and_price?)
      calculate_date(45, :calendar)
    else
      calculate_date(30, :calendar)
    end
  end

  def taken_price_calculator
    if purchase_process.judgment_form_best_technique? || purchase_process.judgment_form_technical_and_price?
      calculate_date(30, :calendar)
    else
      calculate_date(15, :calendar)
    end
  end

  def auction_calculator
    calculate_date(15, :calendar)
  end

  def trading_calculator
    calculate_date(8, :working)
  end

  def invitation_calculator
    calculate_date(5, :working)
  end
end
