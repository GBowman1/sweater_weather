class Api::V1::BookSearchController < ApplicationController
  def index
      if params[:quantity].to_i > 0
        book_weather = BookFacade.books_and_weather(params[:location], params[:quantity])
        render json: BookSerializer.new(book_weather)
      else
        error = "Quantity Can't Be Less Than 0"
        render json: ErrorSerializer.serialize(ErrorMessage.new(error, 400)), status: 400
      end
  end
end