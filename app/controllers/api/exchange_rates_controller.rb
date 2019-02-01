class Api::ExchangeRatesController < ApplicationController
  def index
    @rates = ExchangeRate.all
    if params[:from_date]
      @rates = @rates.where("date >= :date", date: params[:from_date])
    end
    render json: @rates.to_json(only: [:date, :rate, :currency])
  end
end
