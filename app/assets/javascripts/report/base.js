//-----图表-----
$(function () {
    $.getJSON($('.tabs').find('li:first').data('url'), function (data) {
        $('#sale').html(data.sale);
        $('#platform').html(data.platform);
        $('#face_to_face').html(data.face_to_face);
        $('#order').html(data.order);
        $('#appointment').html(data.appointment);
        $('#title').html(data.report.title);
        var categories = [];
        $.each(data.report.categories, function (index, value) {
            categories.push(value);
        });

        $('#container').highcharts({
            title: {
                text: ''
            },
            subtitle: {
                text: ' '
            },

            yAxis: {
                title: {
                    text: ' '
                }
            },
            xAxis: {
                categories: categories
            },
            series: [{
                name: data.report.title,
                data: data.report.data
            }]
        });
    })
    $('.tabs li').on('click', function () {
        $(this).parent().find("li").removeClass('active');
        $(this).parent().find("li").addClass('normal');
        $(this).removeClass('normal');
        $(this).addClass('active');
        $.getJSON($(this).data('url'), function (data) {
            $('#sale').html(data.sale);
            $('#platform').html(data.platform);
            $('#face_to_face').html(data.face_to_face);
            $('#order').html(data.order);
            $('#appointment').html(data.appointment);
            $('#title').html(data.report.title);
            var categories = [];
            $.each(data.report.categories, function (index, value) {
                categories.push(value);
            });

            $('#container').highcharts({
                title: {
                    text: ''
                },
                subtitle: {
                    text: ' '
                },

                yAxis: {
                    title: {
                        text: ' '
                    }
                },
                xAxis: {
                    categories: categories
                },
                series: [{
                    name: data.report.title,
                    data: data.report.data
                }]
            });
        })
    });
});