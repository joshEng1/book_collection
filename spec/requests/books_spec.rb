require "rails_helper"

RSpec.describe "Books", type: :request do
  it "creates a titled book and displays a success notice on the home page" do
    expect { post books_path, params: { book: { title: "Dune" } } }.to change(Book, :count).by(1)
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("Book was successfully created.")
  end

  it "rejects a blank title with an error notice and preserves the database" do
    expect { post books_path, params: { book: { title: " " } } }.not_to change(Book, :count)
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Book could not be saved.", "Title can&#39;t be blank")
  end

  it "saves and displays the author from the form" do
    post books_path, params: { book: { title: "Dune", author: "Frank Herbert" } }
    get book_path(Book.last)
    expect(response.body).to include("Frank Herbert")
  end

  it "saves and displays the price from the form" do
    post books_path, params: { book: { title: "Dune", price: "12.99" } }
    get book_path(Book.last)
    expect(response.body).to include("12.99")
  end

  it "saves a published date from dropdowns and displays it" do
    post books_path, params: { book: { title: "Dune", "published_date(1i)" => "1965", "published_date(2i)" => "8", "published_date(3i)" => "1" } }
    get book_path(Book.last)
    expect(response.body).to include("1965-08-01")
  end
end
