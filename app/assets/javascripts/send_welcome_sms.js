$(document).ready(() => {
  const $mainContainer = $(".main-container");
  $(".send-user-sms").click((e) => {
      e.preventDefault();
      const userId = $(e.target).data().userId;
      $.post(`/admin/users/${userId}/send_welcome_sms`)
        .done(() => {
          $mainContainer.prepend("<div class='alert alert-success'>Sms has been send</div>");
        })
        .fail(() => {
          $mainContainer.prepend("<div class='alert alert-danger'>Something went wrong.</div>");
        });
  });
});
