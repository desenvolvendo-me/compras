class Link < Compras::Model
  attr_accessible :controller_name

  has_and_belongs_to_many :bookmarks, :join_table => :compras_bookmarks_compras_links

  validates :controller_name, :presence => true, :uniqueness => { :allow_blank => true }

  def self.ordered
    all.sort_by(&:to_s)
  end

  def to_s
    I18n.translate("controllers.#{controller_name}")
  end
end
