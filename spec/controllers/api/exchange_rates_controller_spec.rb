require 'rails_helper'

RSpec.describe Api::ExchangeRatesController, type: :controller do

  describe "GET #index" do
    let!(:exchange_rates) {
      [
        ExchangeRate.create(
          currency: "USD",
          rate: 1,
          date: Date.today
        ),
        ExchangeRate.create(
          currency: "AUD",
          rate: 1,
          date: Date.today.days_ago(10)
        ),
        ExchangeRate.create(
          currency: "BRL",
          rate: 1,
          date: Date.yesterday
        )
      ]
    }

    context "Without filters" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "returns all exchange rates" do
        get :index
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(exchange_rates.size)
      end
    end

    context "With from date filter" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "returns exchange rates for date at or after given date" do
        get :index, params: { from_date: Date.today.days_ago(7) }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(2)
      end
    end
  end

end
