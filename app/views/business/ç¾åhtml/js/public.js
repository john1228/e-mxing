// JavaScript Document
$(document).ready(function(){
if (/android/i.test(navigator.userAgent)){
	//适配android
	$(".return").css("top","16px");
	$(".dele").css("top","16px");
	$(".set_up").css("top","15px");
	$(".set_l").css("top","15px");
	$(".focus_header h3").css("top","15px");
	$("header.hdcon h3").css("padding-top","15px");
	$("header").css("padding-top","15px");
	$(".hdcon").attr("class","hdcon_az");
}
if (/ipad|iphone|mac/i.test(navigator.userAgent)){	
  // 适配ios
}
});


function toggle(targetid){
     if (document.getElementById){
         target=document.getElementById(targetid);
             if (target.style.display=='block'){
                 target.style.display='none';
             } else {
                 target.style.display='none';
                 target.style.display='block';
             }
     }
}

