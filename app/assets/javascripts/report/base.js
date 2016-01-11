function nTabs(thisObj, Num) {
	if (thisObj.className == "active") return;
	var tabList = document.getElementById("myTab").getElementsByTagName("li");
	for (i = 0; i < tabList.length; i++) { //点击之后，其他tab变成灰色，内容隐藏，只有点击的tab和内容有属性
		if (i == Num) {
			thisObj.className = "active";
			document.getElementById("myTab_Content" + i).style.display = "block";
		} else {
			tabList[i].className = "normal";
			document.getElementById("myTab_Content" + i).style.display = "none";
		}
	}
}
//-----图表-----
 $(function () {

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
            categories: ['10.22', '10.23', '10.24', '10.25', '10.26', '10.27','10.28']
        },
        series: [{
            name:'7日销量趋势 ',
            data: [ 2.9, 3.5, 4.5, 5.5, 6.5, 4.5, 7.5]
        }]
    });
});