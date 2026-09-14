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
end
