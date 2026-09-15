class AddAuthorToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :author, :string
  end
end
