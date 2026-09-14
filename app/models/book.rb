class Book < ApplicationRecord
  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0, less_than: 100_000_000 }, allow_nil: true
end
