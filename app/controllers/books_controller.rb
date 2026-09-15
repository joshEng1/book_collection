class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update delete destroy ]

  # GET /books or /books.json
  def index
    @books = Book.order(:id)
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  def delete
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html do
          redirect_to root_path,
            notice: "Book was successfully created.",
            status: :see_other
        end
        format.json do
          render :show, status: :created, location: @book
        end
      else
        format.html do
          flash.now[:alert] = "Book could not be saved."
          render :new, status: :unprocessable_content
        end
        format.json do
          render json: @book.errors, status: :unprocessable_content
        end
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html do
          redirect_to root_path,
            notice: "Book was successfully updated.",
            status: :see_other
        end
        format.json { render :show, status: :ok, location: @book }
      else
        format.html do
          flash.now[:alert] = "Book could not be saved."
          render :edit, status: :unprocessable_content
        end
        format.json do
          render json: @book.errors, status: :unprocessable_content
        end
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html do
        redirect_to root_path,
          notice: "Book was successfully destroyed.",
          status: :see_other
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between
    # actions.
    def set_book
      @book = Book.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.expect(book: [ :title, :author, :price,
        :published_date ])
    end
end
