class API::V1::ForecastController < ApplicationController
  def index
    if params[:location].present?
      location = MapQuestFacade.get_grid(params[:location])
      forecast = WeatherService.new.get_forecast(location[:lat], location[:lng])
      render json: ForecastSerializer.new(forecast)
    end
  end
end