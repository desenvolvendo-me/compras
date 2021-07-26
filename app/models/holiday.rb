class Holiday < Compras::Model
  attr_accessible :day, :month, :name, :recurrent, :year

  attr_modal :name, :day, :month, :year, :recurrent

  validates :name, :year, :month, :day, :presence => true
  validates :month, :day, :numericality => { :only_integer => true }, :allow_blank => true
  validates :month, :inclusion => { :in => 1..12 }, :allow_blank => true
  validates :day,   :inclusion => { :in => 1..31 }, :allow_blank => true
  validate :validates_date

  filterize
  orderize

  def self.by_date(date)
    where { year.eq(date.year) & month.eq(date.month) & day.eq(date.day) | month.eq(date.month) & day.eq(date.day) & recurrent.eq(true) }
  end

  def self.is_a_holiday?(date)
    by_date(date).present?
  end

  def self.by_name(value)
    where { name.matches("#{value}%") }
  end

  def to_s
    name
  end

  def date
    Date.new year, month, day
  end

  protected
  def validates_date
    unless Date.valid_date?(year.to_i, month.to_i, day.to_i)
      errors.add :day, I18n.translate('errors.messages.invalid_day_for_informed_month')
    end
  end
end
