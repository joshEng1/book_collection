class MainController < ApplicationController
  def index
    # render('about')
  end

  def about
    @creator = "Pauline"
    @id = params['id']
    @page = params[:page]
    render('about')

  end

  def hello
    redirect_to(action: 'index')
  end

end
