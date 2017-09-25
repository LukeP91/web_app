$(document).ready(() => {
  if($('.users-by-category').length) {
    App.messages = App.cable.subscriptions.create('CategoriesChannel', {
      received: function(data) {
        const categories_data = data.users_by_category.map((categoriesStats) => categoriesStats.count)
        window.chart.series[0].setData(categories_data);
      }
    });
  }
});
