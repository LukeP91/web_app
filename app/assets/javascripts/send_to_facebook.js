$(document).ready(() => {
  $(".send-to-facebook").click((e) => {
      e.preventDefault();
      const tweetId = $(e.target).data().tweetId;
      $.post(`/admin/facebook_posts/${tweetId}/send_to_facebook`)
        .done(() => {
          $(".main-container").prepend("<div class='alert alert-success'>Tweet has been send to Facebook</div>");
        })
        .fail(() => {
          $(".main-container").prepend("<div class='alert alert-danger'>Something went wrong.</div>");
        });
  });
});
