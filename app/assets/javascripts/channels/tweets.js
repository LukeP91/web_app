$(document).ready(() => {
  const tweetsElement = $('.tweets');
  if(tweetsElement.length) {
    App.messages = App.cable.subscriptions.create('TweetsChannel', {
      received: function(data) {
        const hashTagId = +$(location).attr('href').split("/").pop();

        if(data.hash_tags_ids.indexOf(hashTagId) > -1 ) {
          tweetsElement.removeClass('hidden')
          return tweetsElement.append(this.renderMessage(data));
        }
      },

      renderMessage: function(data) {
        return '<tr><td>${data.user_name}</td><td>${data.tweet_id}</td><td>${data.message}</td><td>${data.tweet_created_at}</td></tr>';
      }
    });
  }
});
