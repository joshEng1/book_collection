require "rails_helper"

RSpec.describe UserBook, type: :model do
  let(:user) { User.create!(username: "reader_one") }
  let(:book) { Book.create!(title: "Dune") }

  it "requires an existing user and book" do
    expect(UserBook.new).not_to be_valid
    expect(UserBook.new(user_id: -1, book_id: -1)).not_to be_valid
  end

  it "prevents duplicate associations" do
    UserBook.create!(user: user, book: book)
    expect(UserBook.new(user: user, book: book)).not_to be_valid
  end

  it "allows the same book to belong to multiple users" do
    second_user = User.create!(username: "reader_two")
    UserBook.create!(user: user, book: book)
    UserBook.create!(user: second_user, book: book)
    expect(book.users).to match_array([ user, second_user ])
  end

  it "removes associations when a book is deleted while retaining users" do
    UserBook.create!(user: user, book: book)
    expect { book.destroy! }.to change(UserBook, :count).by(-1)
    expect(User.exists?(user.id)).to be(true)
  end
end
