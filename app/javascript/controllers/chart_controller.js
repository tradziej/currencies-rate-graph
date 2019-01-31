import { Controller } from "stimulus"
import "chart.js"
import { groupBy, values, prop, uniq, map, pipe } from "ramda";

export default class extends Controller {
  static targets = ["ratesChart"]

  connect() {
    const rates = JSON.parse(this.element.dataset.exchangeRates)
    this.loadRatesChart(rates)
  }

  loadRatesChart(rates) {
    const ctx = this.ratesChartTarget.getContext("2d")

    const byCurrency = groupBy(prop("currency"))
    const groupedCurrencies = byCurrency(rates)
    const currencies = ["USD", "AUD", "EUR"]

    const uniqueDates = pipe(map(prop("date")), uniq)
    const labels = uniqueDates(rates)

    const getColor = currency => {
      const colors = {
        "USD": [30, 158, 218],
        "AUD": [246, 128, 26],
        "EUR": [0, 166, 139],
      }
      return colors[currency]
    }

    const datasets = values(groupedCurrencies).map((currencyRates, index) => {
      const currencyName = currencies[index]
      const color = getColor(currencyName)

      return {
        label: currencyName,
        backgroundColor:
          "rgba(" + color[0] + "," + color[1] + "," + color[2] + ",0.2)",
        borderColor:
          "rgba(" + color[0] + "," + color[1] + "," + color[2] + ",1)",
        pointBackgroundColor:
          "rgba(" + color[0] + "," + color[1] + "," + color[2] + ",1)",
        pointBorderColor: "#fff",
        data: currencyRates.map(rate => parseFloat(rate.rate))
      }
    })

    const data = {
      datasets: datasets,
      labels: labels
    }

    const options = {
      responsive: true,
      legend: {
        position: "bottom"
      },
      scales: {
        xAxes: [
          {
            type: "time",
            time: {
              parser: "YYYY-MM-DD",
              unit: "day"
            },
            ticks: {
              autoSkip: true,
              maxTicksLimit: 12
            }
          }
        ]
      },
      elements: {
        point: {
          radius: 0,
          hitRadius: 10,
          hoverRadius: 5
        }
      }
    }

    return new Chart(ctx, { type: "line", data, options })
  }
}