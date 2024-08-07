class Api::V1::ForecastController < ApplicationController
  def index
    if params[:location].present?
      location = MapQuestFacade.get_grid(params[:location])
      forecast = WeatherFacade.weather_data(location)
      render json: ForecastSerializer.new(forecast)
    else
      render json: ErrorSerializer.serialize(ErrorMessage.new("Must Provide Location", 400)), status: 400
    end
  end
end