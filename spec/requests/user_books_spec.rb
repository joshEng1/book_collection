require "rails_helper"

RSpec.describe "User Books", type: :request do
  let!(:user) { User.create!(username: "reader_one") }
  let!(:book) { Book.create!(title: "Dune") }

  it "makes User Books the home page with navigation" do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("User Books", 'href="/books"',
      'href="/users"', 'href="/user_books/new"')
  end

  it "uses dropdowns containing available users and books" do
    get new_user_book_path
    document = Nokogiri::HTML(response.body)
    users = document.at_css('select[name="user_book[user_id]"]')
    expect(users.text).to include("reader_one")
    books = document.at_css('select[name="user_book[book_id]"]')
    expect(books.text).to include("Dune")
  end

  it "creates, shows, updates, and deletes an association" do
    expect do
      post user_books_path,
        params: { user_book: { user_id: user.id,
                               book_id: book.id } }
    end.to change(UserBook,
      :count).by(1)
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include(
      "User book was successfully created.", "reader_one", "Dune")
    association = UserBook.last
    get user_book_path(association)
    expect(response.body).to include("reader_one", "Dune")
    get edit_user_book_path(association)
    expect(response).to have_http_status(:ok)
    other_book = Book.create!(title: "Foundation")
    patch user_book_path(association),
      params: { user_book: { book_id: other_book.id } }
    expect(association.reload.book).to eq(other_book)
    expect do
      delete user_book_path(association)
    end.to change(UserBook,
      :count).by(-1)
    expect(User.exists?(user.id)).to be(true)
    expect(Book.exists?(other_book.id)).to be(true)
  end

  it "rerenders invalid links with errors and populated dropdowns" do
    post user_books_path,
      params: { user_book: { user_id: "", book_id: book.id } }
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("User must exist", "reader_one",
      "Dune")
    UserBook.create!(user: user, book: book)
    expect do
      post user_books_path,
        params: { user_book: { user_id: user.id,
                               book_id: book.id } }
    end.not_to change(
      UserBook, :count)
    expect(response).to have_http_status(:unprocessable_content)
  end

  it "rejects missing foreign records without a server error" do
    post user_books_path,
      params: { user_book: { user_id: -1, book_id: -1 } }
    expect(response).to have_http_status(:unprocessable_content)
  end
end
