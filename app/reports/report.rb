class Report < ActiveRelatus::Base
  extend EnumerateIt
  include I18n::Alchemy

  class << self
    attr_accessor :page, :per
  end

  def records
    if render_list?
      super.page(self.class.page).per(self.class.per)
    else
      super
    end
  end

  def paginate(page, per)
    self.class.page = page
    self.class.per  = per
  end

  def disable_pagination
    self.class.page = nil
    self.class.per  = nil
  end

  def parse_filter(param, data)
    ReportFilterParser.parse(self, param, data)
  end

  def render_list?
    false
  end

  def searched?
    normalize_attributes.present?
  end
end
