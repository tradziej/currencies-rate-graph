## BRL quotation versus EUR, USD and AUD

This is a Rails 5 application using [Stimulus](https://stimulusjs.org/) and [Chart.js](https://www.chartjs.org/) for showing currencies quatation in form of graph.

## Details
Base exchange rates are fetched asynchronously from European Central Bank once a day on every working day. Application converts base currency from EUR to BRL and keeps rates in PosgreSQL database.

## Demo
A live demo is available at: [https://brl-exchange-rates.herokuapp.com/](https://brl-exchange-rates.herokuapp.com/)
![Screenshot](https://raw.githubusercontent.com/tradziej/currencies-rate-graph/assets/assets/screenshot.png)

## Testing
```
bundle exec rspec spec/
```