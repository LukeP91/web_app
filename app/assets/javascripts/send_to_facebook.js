$(document).ready(() => {
  const $mainContainer = $(".main-container");
  $(".send-to-facebook").click((e) => {
      e.preventDefault();
      const tweetId = $(e.target).data().tweetId;
      $.post(`/admin/facebook_posts/${tweetId}/send_to_facebook`)
        .done(() => {
          $mainContainer.prepend("<div class='alert alert-success'>Tweet has been send to Facebook</div>");
        })
        .fail(() => {
          $mainContainer.prepend("<div class='alert alert-danger'>Something went wrong.</div>");
        });
  });
});
