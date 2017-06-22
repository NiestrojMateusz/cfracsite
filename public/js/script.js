$(document).ready(function() {
    $('.js--section-crossfit').waypoint(function(direction) {
        if (direction == "down") {
            $('#logo').removeClass('logo').addClass('logo-sticky');
            $('nav').addClass('sticky');
        } else {
            $('#logo').removeClass('logo-sticky').addClass('logo');
            $('nav').removeClass('sticky');
        }
    }, {
        offset: '200px'
    });
    
    /* Scroll on buttons */
    $('.js--scroll-to-schedule').click(function () {
        $('html, body').animate({scrollTop: $('.js--section-schedule').offset().top}, 1000);
    });
    $('.js--scroll-to-start').click(function () {
        $('html, body').animate({scrollTop: $('.js--section-crossfit').offset().top}, 1000);
    });
    
    /* Nav scroll */
    $(function() {
      $('a[href*=#]:not([href=#])').click(function() {
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
          if (target.length) {
            $('html,body').animate({
              scrollTop: target.offset().top
            }, 1000);
            return false;
          }
        }
      });
    });
    
    /* Animation on Scroll */
    $('.js--wp-1').waypoint(function(direction) {
        $('.js--wp-1').addClass('animated fadeIn');
    }, {
        offset: '50%'
    });
    
    $('.js--wp-2').waypoint(function(direction) {
        $('.js--wp-2').addClass('animated fadeIn');
    }, {
        offset: '50%'
    });
    
    $('.js--wp-3').waypoint(function(direction) {
        $('.js--wp-3').addClass('animated bounceInLeft');
    }, {
        offset: '50%'
    });
    
    /* Mobile Nav */
    $('.js--nav-icon').click(function() {
        var nav = $('.js--main-nav');
        var icon = $('.js--nav-icon i');
        
        nav.slideToggle(200);
        if (icon.hasClass('ion-navicon-round')) {
            icon.addClass('ion-close-round');
            icon.removeClass('ion-navicon-round');
        } else {
            icon.addClass('ion-navicon-round');
            icon.removeClass('ion-close-round');
        }
        
    });
    
});