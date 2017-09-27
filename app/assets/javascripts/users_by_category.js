$(document).ready(() => {
  const $usersByCategory = $('.users-by-category');
  if ($usersByCategory.length) {
    const $container = $('<div>').appendTo($usersByCategory);
    const categories = $usersByCategory.data('categoryStats').map((categoryStats) => categoryStats.category);
    const usersCount = $usersByCategory.data('categoryStats').map((categoryStats) => categoryStats.count);

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
