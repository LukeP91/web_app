$( "[id^='user_send_email]" ).click(function(e) {
    e.preventDefault();
    $.ajax({
        type: "GET",
        url: this.attributes.href,
        success: function(result) {
          $( ".main-container" ).append( "<div class='alert alert-success'>User has been successfully updated.</div>" );
        },
        error: function(result) {
          $( ".main-container" ).append( "<div class='alert alert-danger'>Something went wrong.</div>" );
        }
    });
});
