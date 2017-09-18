$(document).ready(() => {
  $(".send-user-email").click((e) => {
      e.preventDefault();
      const userId = $(e.target).data().userId;
      $.get(`/admin/users/${userId}/send_email`)
        .done(() => {
          $(".main-container").prepend("<div class='alert alert-success'>Regards email has been send</div>");
        })
        .fail(() => {
          $(".main-container").prepend("<div class='alert alert-danger'>Something went wrong.</div>");
        });
  });
});
