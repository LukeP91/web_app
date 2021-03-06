$(document).ready(() => {
  const $mostCommonWords = $('.most-common-words');
  if ($mostCommonWords.length) {
    const $container = $('<div>').appendTo($mostCommonWords);
    const totalWords = $mostCommonWords.data('wordsStats').map((wordStats) => wordStats.count)
      .reduce((totalCount, current) => totalCount + current);
    const wordsStats = $mostCommonWords.data('wordsStats')
      .map((wordStats) => ({ name: wordStats.word, y: +(wordStats.count * 100 / totalWords).toFixed(2) }));

    window.chart = new Highcharts.Chart({
      chart: {
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false,
          type: 'pie',
          renderTo: $container[0]
      },
      title: {
        text: 'Most common words count',
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
          name: 'Words',
          colorByPoint: true,
          data: wordsStats
      }]
    });
  }
});
