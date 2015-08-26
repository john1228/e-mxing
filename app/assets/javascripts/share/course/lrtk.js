(function ($) {
   
        $('div, img').slideShow({
            timeOut: 5000,
            showNavigation: true,
            pauseOnHover: true,
            swipeNavigation: true
        });

        var navbar=$('.navbar')

        navbar.animate({top: '-100px'}, function () {
            navbar.hide();
        });


}(jQuery));

$(function() {
	var openImg='iVBORw0KGgoAAAANSUhEUgAAABAAAAAKCAYAAAC9vt6cAAAAz0lEQVR4AbWQPUoFMRRGz509DWjWYWNj4fNHi9erCP6DIFjYqCBYWNq4ibkT3s1e3IAv14ykegw4Fh5Ile87+YhENcvwEkL7zHTo+zTH2W3c+WhEHlVtf3K5S4cCD46/VZudxT7lqLY34eWdIVskpytWO/+5KAEYR9W2Smapmi4ZI2q6GCQlOBspbw7lsvb2l4mLqyrZptJ1ttGrfZVzzwoyLrFrQU7IeZal+RT8HXhaD+18kqD+yY00cgQscX9dC+0B4PwF1cVx1HQHCP/FN/IRdzmplLfLAAAAAElFTkSuQmCC';
	var closeImg='iVBORw0KGgoAAAANSUhEUgAAABAAAAAKCAYAAAC9vt6cAAAA/UlEQVR4AaXQPUvDABCH8eeSVqljEQRxs1tLi+goErRoIrSDWvETFtJUHMSXwUF8cXLqyzcRB2nyN2SKoqHib7rlOY4zfqFefQFz+2BVNOtaNH3jB05BPAT2gUY6X6mzujTXAm1SToMI8EgSHyV7QJ3K8qV6a5XCBVlca0bALsSBDScvFo3HKG5jbGDVCwW1RXLsS7zeGoDaEPs2mD6To+PGFq57Bzyh2VH6kw8AJxeHWSwLvsUZO5+8YvJBO1gplEcJwLJhpRkCB8SkZ48eKaBeaxtHt4gbNDoznTb7GF2kQxuMH5iDThoejnuNEToY73+IM+lz70nUQZT5r08AxmFJWgglxwAAAABJRU5ErkJggg==';
	 $("#toggle img")[0].src='data:image/png;base64,'+openImg;
    $("#toggle").click(function() {
        $(this).find('img').attr('src',$("#content").is(":hidden") ? 'data:image/png;base64,'+closeImg : 'data:image/png;base64,'+openImg);
        $("#content").slideToggle();
    });
});

$(document).ready(function(){
  $("#download-button").click(function(){
    $(".downtoad").slideToggle();
  });
});