$(document).ready(() => {
  if ($('.users-by-category').length) {
    const $container = $('<div>').appendTo($('.users-by-category'));
    const categories = $('.users-by-category').data('categoryStats').map((categoryStats) => categoryStats.category);
    const usersCount = $('.users-by-category').data('categoryStats').map((categoryStats) => categoryStats.count);

    window.chart = new Highcharts.Chart({
      chart: {
        type: 'bar',
        renderTo: $container[0],
      },
      title: {
        text: 'Users count per category',
      },
      xAxis: {
        categories: categories,
        title: {
          text: "Categories",
        },
      },
      yAxis: {
        min: 0,
        allowDecimals: false,
        title: {
          text: 'Users count',
          align: 'high',
        }
      },
      plotOptions: {
        bar: {
          dataLabels: {
              enabled: false,
          },
        },
      },
      credits: {
        enabled: false,
      },
      series: [{
        name: '',
        data: usersCount,
      }],
    });
  }
});
