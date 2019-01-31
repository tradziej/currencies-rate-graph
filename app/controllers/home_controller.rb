class HomeController < ApplicationController
  def show
    @rates = ExchangeRate.all.to_json(only: [:date, :rate, :currency])
  end
end
