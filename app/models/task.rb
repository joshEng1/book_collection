class Task < ApplicationRecord

  belongs_to :category, optional: true
  # optional parameter makes this relationship optional
  validates :name, presence: true

end
