var n = $(".mySlides").length;
var slideIndex = 1; 

function changeTo(i) {
  // hide(slideIndex);
  $(".mySlides:eq("+(slideIndex-1)+")").css("display", "none");
  $(".w3-badge:eq("+(slideIndex-1)+")")
    .toggleClass("w3-blue", false)
    .toggleClass("w3-transparent", true);
  slideIndex = i;
  // show(slideIndex);
  $(".mySlides:eq("+(slideIndex-1)+")").css("display", "block");
  $(".w3-badge:eq("+(slideIndex-1)+")")
    .toggleClass("w3-blue", true)
    .toggleClass("w3-transparent", false);
}

function showPrevious() {
  var i = (slideIndex + 1 - n) % n;
  changeTo(i);
}

function showNext() {
  var i = (slideIndex + 1) % n;
  changeTo(i);
}
