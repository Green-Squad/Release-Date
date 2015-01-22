class Product < ActiveRecord::Base
  after_create :fix_slug
  
  belongs_to :category
  has_many :releases
  has_many :launch_dates, through: :releases
  has_many :regions, through: :releases
  has_many :mediums, through: :releases
  
  validates :name, presence: true
  validates :category_id, presence: true
  validates :slug, uniqueness: { case_sensitive: false }
  
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def slug_candidates
    [
      :name,
      [:name, self.category.name],
      [:name, self.category.name, :id]
    ]
  end
  
  def fix_slug
    self.slug = nil
    self.save!
  end
end