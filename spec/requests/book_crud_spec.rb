require "rails_helper"

RSpec.describe "Book CRUD", type: :request do
  let!(:book) { Book.create!(title: "Dune", author: "Frank Herbert", price: "12.99", published_date: Date.new(1965, 8, 1)) }

  it "provides all five book pages and a home link" do
    [ books_path, new_book_path, book_path(book), edit_book_path(book), delete_book_path(book) ].each do |path|
      get path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('href="/">Home</a>')
    end
  end

  it "prepopulates edit fields and uses three publication date dropdowns" do
    get edit_book_path(book)
    document = Nokogiri::HTML(response.body)
    expect(document.at_css('input[name="book[title]"]')["value"]).to eq("Dune")
    expect(document.at_css('input[name="book[author]"]')["value"]).to eq("Frank Herbert")
    expect(document.css('select[name^="book[published_date"]').size).to eq(3)
    expect(document.css("select option[selected]").map { |option| option["value"] }).to eq(%w[1965 8 1])
  end

  it "updates all attributes and shows a home-page notice" do
    patch book_path(book), params: { book: { title: "Foundation", author: "Isaac Asimov", price: "9.50", published_date: "1951-06-01" } }
    expect(response).to redirect_to(root_path)
    expect(book.reload.attributes.slice("title", "author", "price", "published_date")).to eq(
      "title" => "Foundation", "author" => "Isaac Asimov", "price" => BigDecimal("9.50"), "published_date" => Date.new(1951, 6, 1)
    )
    follow_redirect!
    expect(response.body).to include("Book was successfully updated.")
  end

  it "does not change a record on an invalid update" do
    patch book_path(book), params: { book: { title: "", author: "Changed" } }
    expect(response).to have_http_status(:unprocessable_content)
    expect(book.reload.title).to eq("Dune")
    expect(book.author).to eq("Frank Herbert")
  end

  it "rejects invalid prices without writing to the database" do
    [ "-1", "not-a-number", "100000000" ].each do |price|
      expect { post books_path, params: { book: { title: "Invalid", price: price } } }.not_to change(Book, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  it "rejects an incomplete publication date with validation errors" do
    expect do
      post books_path, params: { book: { title: "Incomplete date", "published_date(1i)" => "1965", "published_date(2i)" => "", "published_date(3i)" => "1" } }
    end.not_to change(Book, :count)
    expect(response).to have_http_status(:unprocessable_content)
  end

  it "requires a DELETE request and shows a home-page deletion notice" do
    expect { get delete_book_path(book) }.not_to change(Book, :count)
    expect(response.body).to include("Are you sure", "Confirm delete")
    expect { delete book_path(book) }.to change(Book, :count).by(-1)
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("Book was successfully destroyed.")
  end

  it "returns 404 for missing records" do
    get book_path(-1)
    expect(response).to have_http_status(:not_found)
  end

  it "returns all book attributes through the existing JSON API" do
    get book_path(book, format: :json)
    expect(response.parsed_body).to include("title" => "Dune", "author" => "Frank Herbert", "price" => "12.99", "published_date" => "1965-08-01")
  end
end
