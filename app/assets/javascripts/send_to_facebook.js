$(document).ready(() => {
  console.log('runned', $(".send-to-facebook"))
  $(".send-to-facebook").click((e) => {
      console.log('click')
      e.preventDefault();
      const tweetId = $(e.target).data().tweetId;
      $.post(`/admin/facebook_posts/${tweetId}/send_to_facebook`)
        .done(() => {
          $( ".main-container" ).prepend( "<div class='alert alert-success'>Tweet has been send to Facebook</div>" );
        })
        .fail(() => {
          $( ".main-container" ).prepend( "<div class='alert alert-danger'>Something went wrong.</div>" );
        });
  });
});
