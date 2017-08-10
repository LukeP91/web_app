$("[id^='user_send_email']").click(function(e) {
    e.preventDefault();
    mail_url = this.attributes.href;
    $.ajax({
        type: "GET",
        url: mail_url,
        success: function(result) {
          $( ".main-container" ).prepend( "<div class='alert alert-success'>Regards email has been send</div>" );
        },
        error: function(result) {
          $( ".main-container" ).prepend( "<div class='alert alert-danger'>Something went wrong.</div>" );
        }
    });
});
