$(document).ready(() => {
  const $container = $('<div>').appendTo($('#tweets_per_hashtag'));
  const totalHashTags = $('#tweets_per_hashtag').data('tweetsStats').map((tweetStats) => tweetStats.count)
    .reduce((totalCount, current) => totalCount + current);
  const hashTagsStats = $('#tweets_per_hashtag').data('tweetsStats')
    .map((tweetStats) => ({ name: tweetStats.name, y: +(tweetStats.count * 100 / totalHashTags).toFixed(2) }));

  window.chart = new Highcharts.Chart({
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: 'pie',
        renderTo: $container[0]
    },
    title: {
      text: 'Count of tweets per hashtag',
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: true,
                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                style: {
                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                }
            }
        }
    },
    credits: {
      enabled: false,
    },
    series: [{
        name: 'Hashtags',
        colorByPoint: true,
        data: hashTagsStats
    }]
  });
});
