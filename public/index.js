$(document).ready(function() {


  // AJAX Hit action
  $(document).on('click', 'form#hit input', function() {

    $.ajax({
      type: 'POST',
      url: '/game/hit'
    }).done(function(response) {
      $("#game-table").replaceWith(response);
    });

    return false;

  });


  // AJAX Stay action
  $(document).on('click', 'form#stay input', function() {

    $.ajax({
      type: 'POST',
      url: '/game/stay'
    }).done(function(response) {
      $("#game-table").replaceWith(response);
    });

    return false;

  });

  // AJAX Dealer hit action
  $(document).on('click', 'form#dealer-hit input', function() {

    $.ajax({
      type: 'POST',
      url: '/game/hit/dealer'
    }).done(function(response) {
      $("#game-table").replaceWith(response);
    });

    return false;

  });
  

});