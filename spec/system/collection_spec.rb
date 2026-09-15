require "rails_helper"

RSpec.describe "Managing the collection in a browser",
  type: :system do
  before do
    driven_by :selenium, using: :headless_chrome,
      screen_size: [ 1200, 900 ] do |options|
      options.add_argument("--no-sandbox")
      options.add_argument("--disable-dev-shm-usage")
    end
  end

  def capture(name)
    return unless ENV["CAPTURE_EVIDENCE"] == "1"
    directory = Rails.root.join("docs/evidence/screenshots")
    FileUtils.mkdir_p(directory)
    page.save_screenshot(directory.join("#{name}.png"))
  end

  it "handles book CRUD and canceled deletion" do
    visit books_path
    expect(page).to have_text("Books")
    click_link "New book"
    expect(page).to have_selector("h1", text: "New book",
      exact_text: true)
    capture("02-new-book")
    fill_in "Title", with: "Dune"
    fill_in "Author", with: "Frank Herbert"
    fill_in "Price", with: "12.99"
    select "1965", from: "book_published_date_1i"
    select "August", from: "book_published_date_2i"
    select "1", from: "book_published_date_3i"
    click_button "Create Book"
    expect(page).to have_text("Book was successfully created.")
    capture("06-create-flash")
    click_link "Books", exact: true
    expect(page).to have_selector("h1", text: "Books",
      exact_text: true)
    capture("01-books-index")
    click_link "Show this book"
    expect(page).to have_text("Frank Herbert")
    expect(page).to have_text("$12.99")
    expect(page).to have_text("1965-08-01")
    capture("04-show-book")
    click_link "Edit this book"
    expect(page).to have_field("Title", with: "Dune")
    capture("03-edit-book")
    fill_in "Title", with: "Dune Revised"
    click_button "Update Book"
    expect(page).to have_text("Book was successfully updated.")
    click_link "Books", exact: true
    click_link "Delete this book"
    expect(page).to have_text("Dune Revised")
    capture("05-delete-book")
    click_link "Cancel"
    expect(page).to have_text("Dune Revised")
    click_link "Delete this book"
    click_button "Confirm delete"
    expect(page).to have_text("Book was successfully destroyed.")
    click_link "Books", exact: true
    expect(page).not_to have_text("Dune Revised")
  end

  it "shows a blank-title validation error" do
    visit new_book_path
    click_button "Create Book"
    expect(page).to have_text("Book could not be saved.")
    expect(page).to have_text("Title can't be blank")
    capture("07-invalid-book")
  end

  it "manages a user and their book association with dropdowns" do
    book = Book.create!(title: "Dune", author: "Frank Herbert",
      price: "12.99", published_date: Date.new(1965, 8, 1))
    visit users_path
    click_link "New user"
    fill_in "Username", with: "reader_one"
    click_button "Create User"
    expect(page).to have_text("User was successfully created.")
    click_link "Users", exact: true
    expect(page).to have_selector("h1", text: "Users",
      exact_text: true)
    capture("08-users-index")
    click_link "Home"
    click_link "New user book"
    select "reader_one", from: "User"
    select book.title, from: "Book"
    capture("09-new-user-book")
    click_button "Create User book"
    expect(page).to have_text("User book was successfully created.")
    expect(page).to have_text("reader_one")
    expect(page).to have_text("Dune")
    capture("10-user-books-home")
    click_link "Show this user book"
    click_button "Destroy this user book"
    expect(page).to have_text("User book was successfully destroyed.")
    expect(User.count).to eq(1)
    expect(Book.count).to eq(1)
  end
end
