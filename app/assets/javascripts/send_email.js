$(document).ready(() => {
  const $mainContainer = $(".main-container");
  $(".send-user-email").click((e) => {
      e.preventDefault();
      const userId = $(e.target).data().userId;
      $.get(`/admin/users/${userId}/send_email`)
        .done(() => {
          $mainContainer.prepend("<div class='alert alert-success'>Regards email has been send</div>");
        })
        .fail(() => {
          $mainContainer.prepend("<div class='alert alert-danger'>Something went wrong.</div>");
        });
  });
});
