$(document).ready(() => {
  $(".send-user-sms").click((e) => {
      e.preventDefault();
      const userId = $(e.target).data().userId;
      $.post(`/admin/users/${userId}/send_welcome_sms`)
        .done(() => {
          $(".main-container").prepend("<div class='alert alert-success'>Sms has been send</div>");
        })
        .fail(() => {
          $(".main-container").prepend("<div class='alert alert-danger'>Something went wrong.</div>");
        });
  });
});
