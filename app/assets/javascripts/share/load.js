var demoImgArray = [
    '/images/share/page01.jpg',
    '/images/share/page02.jpg',
    '/images/share/page03.jpg',
    '/images/share/page04.jpg',
    '/images/share/s-up.png',
    '/images/share/ico1.png',
    '/images/share/code.png',
    '/images/share/jmtext.png',
    '/images/share/jmtext2.png',
    '/images/share/kcico1.png',
    '/images/share/kcico3.png',
    '/images/share/kcico4.png',
    '/images/share/music.png',
    '/images/share/telico.png',
    '/images/share/vitu.png',
    '/images/share/logo.png',
    '/images/share/fottu1.png',
    '/images/share/fottu2.png',
    '/images/share/fottu3.png'];
var stripesAnim;
var calcPercent;
$progress = $('.progress-bar');
$percent = $('.percentage');
$stripes = $('.progress-stripes');
$ycnone = $('.load');
$('.skin').click(function () {
    var whichColor = $(this).attr('id');
    setSkin(whichColor);
});
preload(demoImgArray);
stripesAnimate();
$(window).load(function () {
    loaded = true;
    $progress.animate({width: "100%"}, 100, function () {
        $percent.text('100%');
        $ycnone.addClass('ycnone');
        clearInterval(calcPercent);
        clearInterval(stripesAnim)
    })
});
function preload(imgArray) {
    var increment = Math.floor(100 / imgArray.length);
    $(imgArray).each(function () {
        $('<img>').attr("src", this).load(function () {
            $progress.animate({width: "+=" + increment + "%"}, 100)
        })
    });
    calcPercent = setInterval(function () {
        $percent.text(Math.floor(($progress.width() / $('.loader').width()) * 100) + '%')
    })
}
function stripesAnimate() {
    animating();
    stripesAnim = setInterval(animating, 2500)
}
function animating() {
    $stripes.animate({marginLeft: "-=30px"}, 2500, "linear").append('/')
}
	