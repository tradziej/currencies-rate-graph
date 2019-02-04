import { Controller } from "stimulus"
import "chart.js"
import { groupBy, values, prop, uniq, map, pipe } from "ramda"

export default class extends Controller {
  static targets = ["ratesChart", "range"]

  initialize() {
    this._disableOrEnableButtons()
  }

  connect() {
    this.chart
    this._updateChart()
  }

  get range() {
    return this.data.get("range")
  }

  set range(value) {
    this.data.set("range", value)
    this._disableOrEnableButtons()
    this._loadData()
  }

  get exchangeRates() {
    const rates = JSON.parse(this.data.get("exchangeRates"))
    return rates
  }

  set exchangeRates(values) {
    this.data.set("exchangeRates", JSON.stringify(values))
    this._updateChart()
  }

  get chart() {
    if (!this._chart) {
      const ctx = this.ratesChartTarget.getContext("2d")

      const currencies = ["USD", "AUD", "EUR"]

      const getColor = currency => {
        const colors = {
          USD: [30, 158, 218],
          AUD: [246, 128, 26],
          EUR: [0, 166, 139]
        }
        return colors[currency]
      }

      const datasets = currencies.map(name => {
          const color = getColor(name)

          return {
            label: name,
            backgroundColor:
              "rgba(" + color[0] + "," + color[1] + "," + color[2] + ",0.2)",
            borderColor:
              "rgba(" + color[0] + "," + color[1] + "," + color[2] + ",1)",
            pointBackgroundColor:
              "rgba(" + color[0] + "," + color[1] + "," + color[2] + ",1)",
            pointBorderColor: "#fff"
          }
        }
      )

      const options = {
        responsive: true,
        legend: {
          position: "bottom"
        },
        scales: {
          xAxes: [
            {
              type: "time",
              distribution: "series",
              time: {
                parser: "YYYY-MM-DD",
                unit: "day"
              },
              ticks: {
                autoSkip: true,
                maxTicksLimit: 12,
                source: "data"
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
        },
        animation: false
      }

      this._chart = new Chart(ctx, { type: "line", data: { datasets }, options })
    }
    return this._chart
  }

  changeRange(event) {
    this.range = event.target.dataset.range
  }

  _loadData() {
    const url = this.data.get("endpoint")
    const params = this._getParams()

    const esc = encodeURIComponent
    const query = Object.keys(params)
      .map(k => `${esc(k)}=${esc(params[k])}`)
      .join("&")

    fetch(`${url}?${query}`)
      .then(response => response.json())
      .then(this._loaded)
  }

  _loaded = data => {
    this.exchangeRates = data
  }

  _getParams() {
    const params = {}
    const date = new Date()

    switch (this.range) {
      case "1W":
        date.setDate(date.getDate() - 7)
        break
      case "1M":
        date.setMonth(date.getMonth() - 1)
        break
      case "1Y":
        date.setMonth(date.getMonth() - 12)
        break
      case "3Y":
        date.setFullYear(date.getFullYear() - 3)
        break
      case "5Y":
        date.setFullYear(date.getFullYear() - 5)
        break
    }
    params["from_date"] = date.toISOString().slice(0, 10)
    return params
  }

  _disableOrEnableButtons() {
    this.rangeTargets.forEach(el => {
      if (el.dataset.range === this.range) {
        el.disabled = true
      } else {
        el.disabled = false
      }
    }, this)
  }

  _updateChart() {
    const data = this.exchangeRates

    const byCurrency = groupBy(prop("currency"))
    const groupedCurrencies = byCurrency(data)

    const uniqueDates = pipe(
      map(prop("date")),
      uniq
    )
    const labels = uniqueDates(data)

    const datasets = values(groupedCurrencies).reduce((res, currencyRates) => {
      const rates = currencyRates.map(rate => parseFloat(rate.rate))
      res[currencyRates[0].currency] = rates
      return res
    }, {})

    this.chart.data.labels = labels

    this.chart.data.datasets.forEach(dataset => {
      dataset.data = datasets[dataset.label]
    })

    this.chart.update()
  }
}
