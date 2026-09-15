require "rails_helper"

RSpec.describe User, type: :model do
  it "requires a username" do
    expect(User.new(username: " ")).not_to be_valid
  end

  it "reaches many books through user books" do
    user = User.create!(username: "reader_one")
    books = [ Book.create!(title: "Dune"),
      Book.create!(title: "Foundation") ]
    books.each { |book| user.user_books.create!(book: book) }
    expect(user.books).to match_array(books)
  end

  it "removes associations when deleted while retaining books" do
    user = User.create!(username: "reader_one")
    book = Book.create!(title: "Dune")
    user.user_books.create!(book: book)
    expect { user.destroy! }.to change(UserBook, :count).by(-1)
    expect(Book.exists?(book.id)).to be(true)
  end
end
