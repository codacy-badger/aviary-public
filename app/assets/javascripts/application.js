// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require 'blacklight_advanced_search'


//= require popper.min
//= require rails.validations
//= require jquery_ujs
//= require tinymce
//= require jquery-fileupload/vendor/jquery.ui.widget
//= require jquery-fileupload/jquery.iframe-transport
//= require jquery-fileupload/jquery.fileupload
//= require datatables
//= require cocoon
//= require bootstrap-tagsinput
//= require best_in_place
//= require jquery.minicolors
//= require owl.carousel.min
//= require moment
//= require daterangepicker
//= require 'blacklight_range_limit'
//= require clipboard
//= require ahoy
//= require aviary_app
//= require resource_bulk_edit
//= require jquery-ui
//= require_tree .

var isIE = /*@cc_on!@*/false || !!document.documentMode;
var player_widget = null;
var activeCollapsedLayout = false;
Object.size = function (obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};
if (typeof Array.prototype.forEach != 'function') {
    Array.prototype.forEach = function (callback) {
        for (var i = 0; i < this.length; i++) {
            callback.apply(this, [this[i], i, this]);
        }
    };
}

if (window.NodeList && !NodeList.prototype.forEach) {
    NodeList.prototype.forEach = Array.prototype.forEach;
}


/**
 *
 * @param identifier string tag/id/class
 * @param options hash
 * @param start_date
 */
function daterange_init(identifier, options, start_date) {
    if (typeof options == "undefined")
        options = false;

    if (typeof start_date == "undefined")
        start_date = moment();

    if (!options) {
        options = {
            startDate: start_date,
            endDate: moment(),
            showDropdowns: true,
            locale: {
                format: 'YYYY-MM-DD',
            }, ranges: {
                'Today': [moment(), moment()],
                'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                'This Month': [moment().startOf('month'), moment().endOf('month')],
                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            }
        };
    }
    $(identifier).daterangepicker(options);
}

/**
 *
 * @param append_class string tag/id/class
 */
function jsloader(append_class) {
    let html = $('.loading_skeleton').html();
    $(append_class).append(html);
}

function pad(num) {
    return ("0" + num).slice(-2);
}

/**
 *
 * @param d float
 * @returns {{seconds: string, hour: string, minute: string}}
 */
function secondsToHuman(d) {
    let time = seconds_to_time(d);
    if (!isNaN(d))
        return pad(time.h) + ':' + pad(time.m) + ':' + pad(time.s);
    else
        return '';
}

/**
 *
 * @param d float
 * @returns {{seconds: string, hour: string, minute: string}}
 */
function seconds_to_time(d) {
    d = Number(d);
    return {h: Math.floor(d / 3600), m: Math.floor(d % 3600 / 60), s: Math.floor(d % 3600 % 60)};

}

/**
 *
 * @param d float
 * @returns {{seconds: string, hour: string, minute: string}}
 */
function secondsToHumanHash(d) {
    let time = seconds_to_time(d);
    if (!isNaN(d))
        return {seconds: pad(time.s), minute: pad(time.m), hour: pad(time.h)};
    else
        return {seconds: pad(0), minute: pad(0), hour: pad(0)};
}

/**
 *
 * @param time string 00:00:00
 * @returns {number}
 */
function humanToSeconds(time) {
    let a = time.split(':'); // split it at the colons
    // minutes are worth 60 seconds. Hours are worth 60 minutes.
    let seconds = (+a[0]) * 60 * 60 + (+a[1]) * 60 + (+a[2]);
    return seconds;
}


/**
 *
 * @param target_element  tag/class/id
 * @param caller object
 * @param callback string
 */
function init_sortable(target_element, caller, callback) {
    $(target_element).sortable({
        activate: function (event, ui) {
            let data = $(this).sortable('toArray');
            eval('caller.callback(data)');
        },
        update: function (event, ui) {
            let data = $(this).sortable('toArray');
            eval('caller.callback(data)');
        }
    }).disableSelection();
}


/**
 *
 * @param target_element tag/class/id
 * @param time int/float
 */
function scroll_to(target_element, time) {
    if ($(target_element).length > 0) {
        $([document.documentElement, document.body]).animate({
            scrollTop: $(target_element).offset().top
        }, time);
    }
}

/**
 *
 * @param type string danger/success
 * @param text string
 */
function jsMessages(type, text) {
    html = '<div id="alert_message" class="alert animated fadeInDown alert-' + type + '">' +
        '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' +
        text + '</div>';
    $('body').append(html);
    window.setTimeout(function () {
        $("#alert_message").fadeIn(1500, function () {
            $(this).addClass("backToTop");
        });
    }, 10000);
}

/**
 *
 * @param value string
 * @param search_type string
 * @returns {string}
 */
function manage_field_value(value, search_type) {
    if (search_type == 'advance')
        value = value.replace(/[*]/g, '');
    value = value.replace(/[[]/g, '');
    return value;
};


/**
 *
 * @param element string tag/id/class
 * @param refresh_slider boolean
 * @param configuration hash
 */
function show_slider(element, refresh_slider, configuration) {
    if (typeof configuration == 'undefined') {
        configuration = {
            loop: true,
            margin: 0,
            autoplayHoverPause: true,
            navigation: true,
            autoplay: false,
            items: 1,
            dots: false,
            nav: true,
            singleItem: true
        };
    }
    if (typeof refresh_slider == 'undefined') {
        refresh_slider = false;
    }

    let owl_obj = $('.org-banner-slider').owlCarousel(configuration);
    if (refresh_slider) {
        $('#menu-bar').click(function () {
            owl_obj.trigger('refresh.owl.carousel');
        });
    }

    var owl = $(element).data('owl.carousel');
    if (owl) {
        owl.onResize();
    }
    $(".owl-prev").html('<i class="fa fa-chevron-left"></i>');
    $(".owl-next").html('<i class="fa fa-chevron-right"></i>');
}


function readURL(input, id) {
    if (input.files && input.files[0]) {

        if ((/\.(gif|jpg|jpeg|png)$/i).test(input.files[0].name) || ((/\.(ico)$/i).test(input.files[0].name) && id == "favicon")) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#' + id).attr('src', e.target.result);
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            alert("Invalid Image File.");
        }
    }
}


/**
 *
 * @param selector string tag/id/class
 * @param type_of_event click/keyup/etc...
 * @param func function()
 * @param unbind boolean
 */
function bindingElement(selector, type_of_event, func, unbind) {
    if (typeof unbind == 'undefined') {
        unbind = true;
    }
    if (unbind) {
        $(selector).unbind(type_of_event);
    }
    $(selector).bind(type_of_event, func);
}

/**
 *
 * @param selector string tag/id/class
 * @param type_of_event click/keyup/etc...
 * @param func function()
 * @param unbind boolean
 */
function document_level_binding_element(selector, type_of_event, func, unbind) {
    if (typeof unbind == 'undefined') {
        unbind = true;
    }
    if (unbind) {
        $(selector).unbind(type_of_event);
    }
    $(document).on(type_of_event, selector, func);
}

/**
 *
 * @param selector string tag/id/class
 * @param custom_config hash
 * @returns {*}
 */
function init_tinymce_for_element(selector, custom_config) {
    if (typeof custom_config == 'undefined') {
        custom_config = false;
    }
    if (custom_config == false) {
        height = parseInt($(selector).attr('height'), 10);
        tinyMCE.init({
            selector: selector,
            height: height,
            plugins: 'link charmap hr anchor wordcount code lists advlist',
            toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | forecolor backcolor",
            branding: false
        });
    } else {
        tinyMCE.init(custom_config);
    }
    return tinyMCE;
}

document.addEventListener("DOMContentLoaded", function (event) {
    init_tinymce_for_element('.apply_tinymce_to_it');

    $('.search_field_selector_main').on('keyup', function () {
        $(this).parent('.search-query-form').find('.keywords_main').val($(this).val());
    });

});


function orgAndColNav() {
    if ($(".org-tab-main").length > 0) {
        $(".org-tab-main").unstick();
        if ($(window).width() >= 992) {
            $(".org-tab-main").sticky({topSpacing: 121});
        } else {
            $(".org-tab-main").sticky({topSpacing: 0});
        }
    }


}

function resourceSearchBar() {
    if ($(".search_details_bar > div").length > 0) {
        $(".search_details_bar > div").unstick();
        $(".search_details_bar > div").sticky({topSpacing: 0});
    }
}

function checkMenuType(layout) {
    activeCollapsedLayout = $('#main_container').hasClass('main_collapsed');
    subNavs = ['#organization_subnav'];
    if (layout == 'main_collapsed') {
        for (subnav in subNavs) {
            if ($(subNavs[subnav]).hasClass('show')) {
                $(subNavs[subnav]).removeClass('show');
                $(subNavs[subnav]).addClass('collapsed');
            }
        }

        $('[data-toggle="tooltip"]').tooltip({
            template: '<div class="tooltip sidebartooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
        });
    } else {
        for (subnav in subNavs) {
            if ($(subNavs[subnav]).hasClass('collapsed')) {
                $(subNavs[subnav]).removeClass('collapsed');
                $(subNavs[subnav]).addClass('show');
            }
        }
        $('[data-toggle="tooltip"]').tooltip('dispose');
    }

}

function mobileLayoutEvents() {
    $("#close-button").click(function () {
        $("#sidebar-main").addClass('main_collapsed').removeClass('not-collapsed');
    });
}


$(document).on('turbolinks:load', function () {
    $('select').selectize();
    $(".transcript-dl").mCustomScrollbar();


});

$(window).resize(function () {
    if ($('#sidebar-main').length > 0) {
        if ($(window).width() < 1024) {
            $('#sidebar-main').addClass('main_collapsed').removeClass('not-collapsed');
            $(".main-content").removeClass('open');
        } else if ($(window).width() > 1024 && activeCollapsedLayout) {
            $('#sidebar-main').removeClass('main_collapsed').addClass('not-collapsed');
            $(".main-content").addClass('open');
        } else {
            $('#sidebar-main').removeClass('main_collapsed').addClass('not-collapsed');
            $(".main-content").addClass('open');
        }
    }

});
$(window).resize(function () {

    if ($(window).width() >= 992) {
        $("#header").unstick();
        $("#header").sticky({topSpacing: 0});
    } else {
        $("#header").unstick();
    }
    resourceSearchBar();
    orgAndColNav();

});


$(document).on('keyup', '.media-duration', function (event) {
    var time = $(this).val();
    var seconds = humanToSeconds(time);

    if (isNaN(seconds)) {
        $(this).val('00:00:00');
        $(this).next().val(0);
    } else {
        $(this).next().val(seconds);
    }
});

$(document).on('keyup', '.only_allow_number', function (event) {
    var reg = /^\d+$/;
    if ($(this).val() < 0 || !$(this).val().match(reg)) {
        $(this).val(0);
    }
});


$(function () {
    if ($('#sidebar-main').length == 0) {
        $(".main-content").removeClass('open');
    }
    $('.search-nav .form-control').focus(function () {
        $('.buttons-search').show();
    });
    $('.search-nav .form-control').blur(function () {
        setTimeout("$('.buttons-search').hide();", 500);
    });


    if ($(window).width() >= 767) {
        $("#header").sticky({topSpacing: 0});
    }
    $("#header").on('sticky-end', function () {
        $("#header-sticky-wrapper").height($("#header").outerHeight());
    });
    $('#introModal').on('shown.bs.modal', function () {
        var playPromise = document.getElementById('intro_video').play();
        if (playPromise !== undefined) {
            playPromise.then(function () {
            }).catch(function (error) {
            });
        }
    });

    $('#introModal').on('hidden.bs.modal', function () {
        $('#intro_video')[0].pause();
    });

    if ($('#password_help_edit').length > 0) {
        setTimeout("$('#password_help_edit').tooltip()", 500);
    }
    $('#signupmodal').on('shown.bs.modal', function () {
        $('#password_help').tooltip();
    });
    $('select').selectize();
    $('.sign_up_link').click(function (e) {
        $('#signinmodal').modal('hide');
        $('#access_denied_popup').modal('hide');
        setTimeout(function () {
            $('#signupmodal').modal('show');
        }, 500);
    });
    checkMenuType($('#menu-bar').data('layout'));
    mobileLayoutEvents();
    if ($(".organization-blur").length > 0) {
        $(".organization-blur").blur(function () {
            var value = $(this).val();
            var currentSubdomain = $("#organization_url").val();
            var newString = value.replace(/&/ig, "and").toLowerCase();
            newString = newString.replace(/[^A-Z0-9]+/ig, "").toLowerCase();
            if ($.trim(currentSubdomain) == "") {
                $('#organization_url').val(newString);
            }
        });
    }
    if ($('#menu-bar').length > 0) {
        $('#menu-bar').click(function () {
            let url = $(this).data('url');
            $('#sidebar-main').toggleClass('main_collapsed');
            $('#sidebar-main').toggleClass('not-collapsed');
            $('.main-content').toggleClass('open');
            layout = $('#sidebar-main').hasClass('main_collapsed') ? 'main_collapsed' : 'not-collapsed';
            checkMenuType(layout);
            $.ajax({
                url: url,
                data: {layout: layout},
                type: 'POST',
                dataType: 'json',
                success: function (response) {
                }
            });
        });
    }
    if ($('#admin_notice_select_all').length > 0) {
        $('#admin_notice_select_all').click(function () {
            let users = $('#notification_list').selectize();
            let selectize = users[0].selectize;
            selectize.setValue(Object.keys(selectize.options));
        });
    }
    resourceSearchBar();
    orgAndColNav();
});

