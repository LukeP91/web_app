$(document).ready(() => {
  const $container = $('<div>').appendTo($('#tweets_per_hashtag'));
    const hashtags = $('#tweets_per_hashtag').data('tweetsStats').map((x) => x[0]);
  const tweets_count = $('#tweets_per_hashtag').data('tweetsStats').map((x) => x[1]);

  window.chart = new Highcharts.Chart({
    chart: {
        type: 'column',
        renderTo: $container[0]
    },
    title: {
        text: 'Count of tweets per hashtag'
    },
    xAxis: {
        categories: hashtags,
        crosshair: true
    },
    yAxis: {
        min: 0,
        title: {
            text: 'Count of tweets'
        }
    },
    tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>{point.y:.0f}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
    },
    plotOptions: {
        column: {
            pointPadding: 0.2,
            borderWidth: 0
        }
    },
    series: [{
        name: 'Hashtags',
        data: tweets_count
    }]
  });
});
