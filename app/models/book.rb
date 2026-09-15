class Book < ApplicationRecord
  has_many :user_books, dependent: :destroy
  has_many :users, through: :user_books
  validates :title, presence: true
  validates :price,
    numericality: {
      greater_than_or_equal_to: 0, less_than: 100_000_000
    }, allow_nil: true
  validate :published_date_must_be_complete

  # Rails otherwise supplies defaults for missing date-select
  # components.
  def published_date=(value)
    @invalid_published_date = false
    if value.is_a?(Hash)
      parts = value.values_at(1, 2, 3)
      complete = parts.all? { |part| part.is_a?(Integer) }
      @invalid_published_date = !complete || !Date.valid_date?(*parts)
      super(@invalid_published_date ? nil : Date.new(*parts))
    else
      super
      @invalid_published_date = value.present? && published_date.nil?
    end
  end

  private

    def published_date_must_be_complete
      errors.add(:published_date,
        "must be a complete, valid date") if @invalid_published_date
    end
end
