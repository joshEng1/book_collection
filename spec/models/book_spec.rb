require "rails_helper"

RSpec.describe Book, type: :model do
  it "seeds five books and preserves existing records" do
    load Rails.root.join("db/seeds.rb")
    titles = [ "Lantern Bay", "The Quiet Observatory", "Paper Moons",
      "A Map of Rain", "The Last Orchard" ]
    titles.each do |title|
      expect(Book.find_by(title: "Test: #{title}")).to be_present
    end
    book = Book.find_by!(title: "Test: Lantern Bay")
    book.update!(price: "8.25")

    expect { load Rails.root.join("db/seeds.rb") }
      .not_to change(Book, :count)
    expect(book.reload.price).to eq(BigDecimal("8.25"))
  end

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
    book = Book.create!(title: "Dune",
      published_date: Date.new(1965, 8, 1))
    expect(book.reload.published_date).to eq(Date.new(1965, 8, 1))
  end

  it "rejects invalid publication date strings" do
    expect(Book.new(title: "Dune",
      published_date: "not-a-date")).not_to be_valid
  end

  it "rejects impossible publication dates from dropdowns" do
    book = Book.new(title: "Dune", "published_date(1i)" => "2025",
      "published_date(2i)" => "2", "published_date(3i)" => "31")
    expect(book).not_to be_valid
    expect(book.errors[:published_date]).to include(
      "must be a complete, valid date"
    )
  end
end
