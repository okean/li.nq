# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # default bar chart options
  bar_options =
    chart:
      type: "column"
      margin: [50, 50, 100, 80]
    title:
      text: "Number of visits"
    legend:
      enabled: false
    yAxis:
      min: 0
      title:
        text: "Clicks"
    series: [
      name: "Visits"
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
  
  #create visit per day bar chart
  count_days_bar_options =
    chart:
      renderTo: "count_days_bar"
    xAxis:
      type: "datetime"
    tooltip:
      formatter: ->
        "<b>" + new Date(@x).toDateString() + "</b><br/>" + "Clicks per day: " + @y
    series: [
      data: $("#count_days_bar").data("visits")
    ]
    
  count_days_bar_options = jQuery.extend(true, {}, bar_options, count_days_bar_options)
  count_days_bar_chart = new Highcharts.Chart(count_days_bar_options)
  
  # create visit by country bar chart
  count_country_bar_options =
    chart:
      renderTo: "count_country_bar"
    xAxis:
      categories: $("#count_country_bar").data("countrycodes")
    tooltip:
      formatter: ->
        @y + " visits from " + @x
    series: [
      data: $("#count_country_bar").data("visits")
    ]
    
  count_country_bar_options = jQuery.extend(true, {}, bar_options, count_country_bar_options)
  count_country_bar_chart = new Highcharts.Chart(count_country_bar_options)