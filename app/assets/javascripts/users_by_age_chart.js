$(document).ready(() => {
  const $usersByAge = $('.users-by-age');
  if ($usersByAge.length) {
    const $container = $('<div>').appendTo($usersByAge);
    const ageRanges = $usersByAge.data('ageStats').map((ageStats) => ageStats.range);
    const usersCount = $usersByAge.data('ageStats').map((ageStats) => ageStats.count);

    window.chart = new Highcharts.Chart({
      chart: {
        type: 'bar',
        renderTo: $container[0],
      },
      title: {
        text: 'Users by age groupes',
      },
      xAxis: {
        categories: ageRanges,
        title: {
          text: "Age groupes",
        },
      },
      yAxis: {
        min: 0,
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
