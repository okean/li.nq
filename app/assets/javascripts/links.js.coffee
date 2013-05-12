# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#count_days_bar").highcharts
    chart:
      type: "column"
      margin: [50, 50, 100, 80]
    title:
      text: "Number of visits"
    xAxis:
        type: "datetime"
    yAxis:
      min: 0
      title:
        text: "Clicks"
    legend:
      enabled: false
    tooltip:
      formatter: ->
        "<b>" + new Date(@x).toDateString() + "</b><br/>" + "Clicks per day: " + @y
    series: [
      name: "Visits"
      data: $("#count_days_bar").data("visits")
      dataLabels:
        enabled: true
        rotation: -90
        color: "#FFFFFF"
        align: "right"
        x: 4
        y: 10
        style:
          fontSize: "13px"
          fontFamily: "Verdana, sans-serif"
    ]