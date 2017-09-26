$(document).ready(() => {
  const mostCommonWords = $('.most-common-words');
  if (mostCommonWords.length) {
    const $container = $('<div>').appendTo(mostCommonWords);
    const words = mostCommonWords.data('wordsStats').map((wordStats) => wordStats.word);
    const wordsCount = mostCommonWords.data('wordsStats').map((wordStats) => wordStats.count);

    window.chart = new Highcharts.Chart({
      chart: {
        type: 'bar',
        renderTo: $container[0],
      },
      title: {
        text: 'Most common words count',
      },
      xAxis: {
        categories: words,
        title: {
          text: "Words",
        },
      },
      yAxis: {
        min: 0,
        title: {
          text: 'Words count',
          align: 'high',
        },
        labels: {
          overflow: 'justify',
        },
      },
      plotOptions: {
        bar: {
          dataLabels: {
              enabled: true,
          },
        },
      },
      credits: {
        enabled: false,
      },
      series: [{
        name: 'Words',
        data: wordsCount,
      }],
    });
  }
});
