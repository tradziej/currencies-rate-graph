class HomeController < ApplicationController
  def show
    @rates = ExchangeRate.last_week.to_json(only: [:date, :rate, :currency])
  end
end
