class Bookmark < Compras::Model
  attr_accessible :user_id, :link_ids

  belongs_to :user

  has_and_belongs_to_many :links

  validates :user, :presence => true

  def to_s
    self.class.model_name.human
  end
end
