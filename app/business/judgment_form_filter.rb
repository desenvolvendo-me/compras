class JudgmentFormFilter
  def initialize(judgment_form_repository = JudgmentForm)
    @judgment_form_repository = judgment_form_repository
  end

  def by_modality
    {
      :with_price_registration => {
        :concurrence => concurrence(true),
        :taken_price => taken_price,
        :invitation => invitation,
        :trading => trading(true),
        :auction => auction,
        :competition => competition
      },

      :without_price_registration => {
        :concurrence => concurrence(false),
        :taken_price => taken_price,
        :invitation => invitation,
        :trading => trading(false),
        :auction => auction,
        :competition => competition
      }
    }
  end

  private

  attr_reader :judgment_form_repository

  def filter
    judgment_form_repository.enabled.order { description }
  end

  def concurrence(price_registration)
    if price_registration
      filter.select { |item| item.lowest_price? || item.higher_discount_on_table? }
    else
      filter.select { |item|
        item.lowest_price? || item.best_technique? || item.technical_and_price? ||
        item.best_auction_or_offer?
      }
    end
  end

  def taken_price
    filter.select { |item|
      item.lowest_price? || item.best_technique? || item.technical_and_price? ||
      item.best_auction_or_offer?
    }
  end

  def invitation
    filter.select { |item| item.lowest_price? }
  end

  def trading(price_registration)
    if (price_registration)
      filter.select { |item| item.lowest_price? || item.higher_discount_on_table? }
    else
      filter.select { |item| item.lowest_price? && !item.global? }
    end
  end

  def auction
    filter.select { |item| item.best_auction_or_offer? }
  end

  def competition
    filter.select { |item| item.best_technique? }
  end
end
