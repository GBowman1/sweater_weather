class Api::V1::ForecastController < ApplicationController
  def index
    if params[:location].present?
      location = MapQuestFacade.get_grid(params[:location])
      forecast = WeatherFacade.weather_data(location)
      render json: ForecastSerializer.new(forecast)
    end
  end
end