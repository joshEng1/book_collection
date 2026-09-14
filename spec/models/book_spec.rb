require "rails_helper"

RSpec.describe Book, type: :model do
  it "accepts a title" do
    expect(Book.new(title: "Dune")).to be_valid
  end

  it "rejects a blank title" do
    book = Book.new(title: " ")
    expect(book).not_to be_valid
    expect(book.errors[:title]).to include("can't be blank")
  end

  it "stores an author" do
    book = Book.create!(title: "Dune", author: "Frank Herbert")
    expect(book.reload.author).to eq("Frank Herbert")
  end

  it "stores a decimal price without losing cents" do
    book = Book.create!(title: "Dune", price: "12.99")
    expect(book.reload.price).to eq(BigDecimal("12.99"))
  end

  it "stores a published date" do
    book = Book.create!(title: "Dune", published_date: Date.new(1965, 8, 1))
    expect(book.reload.published_date).to eq(Date.new(1965, 8, 1))
  end
end
