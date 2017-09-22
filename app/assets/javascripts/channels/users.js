$(document).ready(() => {
  if($('.users-by-age').length) {
    App.messages = App.cable.subscriptions.create('UsersChannel', {
      received: function(data) {
        const users_data = data.users_by_age.map((ageStats) => ageStats.count)
        window.chart.series[0].setData(users_data);
      }
    });
  }
});
