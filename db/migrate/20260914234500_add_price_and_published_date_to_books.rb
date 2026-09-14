class AddPriceAndPublishedDateToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :price, :decimal, precision: 10, scale: 2
    add_column :books, :published_date, :date
    add_check_constraint :books, "price >= 0", name: "books_price_nonnegative"
  end
end
