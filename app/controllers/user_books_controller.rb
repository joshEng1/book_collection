class UserBooksController < ApplicationController
  before_action :set_user_book, only: %i[ show edit update destroy ]
  before_action :set_options, only: %i[ new edit create update ]

  # GET /user_books or /user_books.json
  def index
    @user_books = UserBook.includes(:user, :book).order(:id)
  end

  # GET /user_books/1 or /user_books/1.json
  def show
  end

  # GET /user_books/new
  def new
    @user_book = UserBook.new
  end

  # GET /user_books/1/edit
  def edit
  end

  # POST /user_books or /user_books.json
  def create
    @user_book = UserBook.new(user_book_params)

    respond_to do |format|
      if @user_book.save
        format.html do
          redirect_to root_path,
            notice: "User book was successfully created.",
            status: :see_other
        end
        format.json do
          render :show, status: :created, location: @user_book
        end
      else
        format.html { render :new, status: :unprocessable_content }
        format.json do
          render json: @user_book.errors,
            status: :unprocessable_content
        end
      end
    end
  end

  # PATCH/PUT /user_books/1 or /user_books/1.json
  def update
    respond_to do |format|
      if @user_book.update(user_book_params)
        format.html do
          redirect_to root_path,
            notice: "User book was successfully updated.",
            status: :see_other
        end
        format.json do
          render :show, status: :ok, location: @user_book
        end
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json do
          render json: @user_book.errors,
            status: :unprocessable_content
        end
      end
    end
  end

  # DELETE /user_books/1 or /user_books/1.json
  def destroy
    @user_book.destroy!

    respond_to do |format|
      format.html do
        redirect_to user_books_path,
          notice: "User book was successfully destroyed.",
          status: :see_other
      end
      format.json { head :no_content }
    end
  end

  private
    def set_options
      @users = User.order(:username)
      @books = Book.order(:title)
    end

    # Use callbacks to share common setup or constraints between
    # actions.
    def set_user_book
      @user_book = UserBook.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_book_params
      params.expect(user_book: [ :user_id, :book_id ])
    end
end
