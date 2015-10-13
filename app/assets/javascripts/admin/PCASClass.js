﻿SPT = "--请选择省份--";
SCT = "--请选择城市--";
SAT = "--请选择地区--";
ShowT = 1;		//提示文字 0:不显示 1:显示
PCAD = "北京市$东城区|西城区|崇文区|宣武区|朝阳区|丰台区|石景山区|海淀区|门头沟区|房山区|通州区|顺义区|昌平区|大兴区|怀柔区|平谷区|密云县|延庆县" +
"#天津市$和平区|河东区|河西区|南开区|河北区|红桥区|塘沽区|汉沽区|大港区|东丽区|西青区|津南区|北辰区|武清区|宝坻区|宁河县|静海县|蓟县" +
"#河北省$石家庄市|唐山市|秦皇岛市|邯郸市|邢台市|保定市|张家口市|承德市|沧州市|廊坊市|衡水市" +
"#山西省$太原市|大同市|阳泉市|长治市|晋城市|朔州市|晋中市|运城市|忻州市|临汾市|吕梁市" +
"#内蒙古自治区$呼和浩特市|包头市|乌海市|赤峰市|通辽市|鄂尔多斯市|呼伦贝尔市|巴彦淖尔市|乌兰察布市|兴安盟|锡林郭勒盟|阿拉善盟" +
"#辽宁省$沈阳市|大连市|鞍山市|抚顺市|本溪市|丹东市|锦州市|营口市|阜新市|辽阳市|盘锦市|朝阳市|葫芦岛市" +
"#吉林省$长春市|吉林市|四平市|辽源市|通化市|白山市|松原市|白城市|延边朝鲜族自治州" +
"#黑龙江省$哈尔滨市|齐齐哈尔市|鸡西市|双鸭山市|大庆市|伊春市|佳木斯市|七台河市|牡丹江市|黑河市|绥化市|大兴安岭地区" +
"#上海市$黄浦区|卢湾区|徐汇区|长宁区|静安区|普陀区|闸北区|虹口区|杨浦区|闵行区|宝山区|嘉定区|浦东新区|金山区|松江区|青浦区|南汇区|奉贤区|崇明县" +
"#江苏省$南京市|无锡市|徐州市|常州市|苏州市|南通市|连云港市|淮安市|盐城市|扬州市|镇江市|泰州市|宿迁市" +
"#浙江省$杭州市|宁波市|温州市|嘉兴市|湖州市|金华市|衢州市|舟山市|台州市|丽水市" +
"#安徽省$合肥市|蚌埠市|淮南市|马鞍山市|铜陵市|安庆市|黄山市|滁州市|阜阳市|宿州市|巢湖市|六安市,市辖区,金安区,裕安区,寿县,霍邱县,舒城县,金寨县,霍山县|亳州市,市辖区,谯城区,涡阳县,蒙城县,利辛县|池州市,市辖区,贵池区,东至县,石台县,青阳县|宣城市,市辖区,宣州区,郎溪县,广德县,泾县,绩溪县,旌德县,宁国市" +
"#福建省$福州市|厦门市|莆田市|三明市,市辖区,梅列区,三元区,明溪县,清流县,宁化县,大田县,尤溪县,沙县,将乐县,泰宁县,建宁县,永安市|泉州市,市辖区,鲤城区,丰泽区,洛江区,泉港区,惠安县,安溪县,永春县,德化县,金门县,石狮市,晋江市,南安市|漳州市,市辖区,芗城区,龙文区,云霄县,漳浦县,诏安县,长泰县,东山县,南靖县,平和县,华安县,龙海市|南平市,市辖区,延平区,顺昌县,浦城县,光泽县,松溪县,政和县,邵武市,武夷山市,建瓯市,建阳市|龙岩市,市辖区,新罗区,长汀县,永定县,上杭县,武平县,连城县,漳平市|宁德市,市辖区,蕉城区,霞浦县,古田县,屏南县,寿宁县,周宁县,柘荣县,福安市,福鼎市" +
"#江西省$南昌市|景德镇市|萍乡市|九江市|新余市|赣州市|吉安市|宜春市|抚州市|上饶市" +
"#山东省$济南市|青岛市|淄博市|枣庄市|东营市|烟台市|潍坊市|济宁市|泰安市|威海市|日照市|莱芜市|临沂市|德州市|聊城市|滨州市|菏泽市" +
"#河南省$郑州市|开封市|洛阳市|平顶山市|安阳市|鹤壁市|焦作市|濮阳市|许昌市|漯河市|三门峡市|南阳市|商丘市|信阳市|周口市|驻马店市" +
"#湖北省$武汉市|黄石市|十堰市|宜昌市|襄樊市|鄂州市|荆门市|孝感市|荆州市|黄冈市|咸宁市|随州市|恩施土家族苗族自治州|仙桃市|潜江市|天门市|神农架林区" +
"#湖南省$长沙市|株洲市|湘潭市|衡阳市|邵阳市|岳阳市|常德市|张家界市|郴州市|永州市|怀化市|娄底市|湘西土家族苗族自治州" +
"#广东省$广州市|韶关市|深圳市|汕头市|佛山市|江门市|湛江市|茂名市|肇庆市|惠州市|梅州市|汕尾市|河源市|阳江市|清远市|东莞市|中山市|潮州市|揭阳市|云浮市" +
"#广西壮族自治区$南宁市|柳州市|桂林市|梧州市|北海市|防城港市|钦州市|贵港市|玉林市|百色市|贺州市|河池市|来宾市|崇左市" +
"#海南省$海口市|三亚市|五指山市|琼海市|儋州市|文昌市|万宁市|东方市|定安县|屯昌县|澄迈县|临高县|白沙黎族自治县|昌江黎族自治县|乐东黎族自治县|陵水黎族自治县|保亭黎族苗族自治|琼中黎族苗族自治县|西沙群岛|南沙群岛|中沙群岛的岛礁及其海域" +
"#重庆市$万州区|涪陵区|渝中区|大渡口区|江北区|沙坪坝区|九龙坡区|南岸区|北碚区|万盛区|双桥区|渝北区|巴南区|黔江区|长寿区|綦江县|潼南县|铜梁县|大足县|荣昌县|璧山县|梁平县|城口县|丰都县|垫江县|武隆县|忠县|开县|云阳县|奉节县|巫山县|巫溪县|石柱土家族自治县|秀山土家族苗族自治县|酉阳土家族苗族自治县|彭水苗族土家族自治县|江津市|合川市|永川市|南川市" +
"#四川省$成都市|自贡市|攀枝花市|泸州市|德阳市|绵阳市|广元市|遂宁市|内江市|乐山市|南充市|眉山市|宜宾市|广安市|达州市|雅安市|巴中市|资阳市|阿坝藏族羌族自治州|甘孜藏族自治州|凉山彝族自治州" +
"#贵州省$贵阳市|六盘水市|遵义市|安顺市|铜仁地区|黔西南布依族苗族自治州|毕节地区|黔东南苗族侗族自治州|黔南布依族苗族自治州" +
"#云南省$昆明市|曲靖市|玉溪市|保山市|昭通市|丽江市|思茅市|临沧市|楚雄彝族自治州|红河哈尼族彝族自治州|文山壮族苗族自治州|西双版纳傣族自治州|大理白族自治州|德宏傣族景颇族自治州|怒江傈僳族自治州|迪庆藏族自治州" +
"#西藏自治区$拉萨市|昌都地区|山南地区|日喀则地区|那曲地区|阿里地区|林芝地区" +
"#陕西省$西安市|铜川市|宝鸡市|咸阳市|渭南市|延安市|汉中市|榆林市|安康市|商洛市" +
"#甘肃省$兰州市|嘉峪关市|金昌市|白银市|天水市|武威市|张掖市|平凉市|酒泉市|庆阳市|定西市|陇南市|临夏回族自治州|甘南藏族自治州" +
"#青海省$西宁市|海东地区|海北藏族自治州|黄南藏族自治州|海南藏族自治州|果洛藏族自治州|玉树藏族自治州|海西蒙古族藏族自治州" +
"#宁夏回族自治区$银川市|石嘴山市|吴忠市|固原市|中卫市" +
"#新疆维吾尔自治区$乌鲁木齐市|克拉玛依市|吐鲁番地区|哈密地区|昌吉回族自治州|博尔塔拉蒙古自治州|巴音郭楞蒙古自治州|阿克苏地区|克孜勒苏柯尔克孜自治州|喀什地区|和田地区|伊犁哈萨克自治州|塔城地区|阿勒泰地区|石河子市|阿拉尔市|图木舒克市|五家渠市" +
"#香港特别行政区$香港,香港特别行政区" +
"#澳门特别行政区$澳门,澳门特别行政区" +
"#台湾省$台湾市" +
"#其它$亚洲,阿富汗,巴林,孟加拉国,不丹,文莱,缅甸,塞浦路斯,印度,印度尼西亚,伊朗,伊拉克,日本,约旦,朝鲜,科威特,老挝,马尔代夫,黎巴嫩,马来西亚,以色列,蒙古,尼泊尔,阿曼,巴基斯坦,巴勒斯坦,菲律宾,沙特阿拉伯,新加坡,斯里兰卡,叙利亚,泰国,柬埔寨,土耳其,阿联酋,越南,也门,韩国,中国,中国香港,中国澳门,中国台湾|非洲,阿尔及利亚,安哥拉,厄里特里亚,法罗群鸟,加那利群岛(西)(拉斯帕尔马斯),贝宁,博茨瓦纳,布基纳法索,布隆迪,喀麦隆,加那利群岛(西)(圣克鲁斯),佛得角,中非,乍得,科摩罗,刚果,吉布提,埃及,埃塞俄比亚,赤道几内亚,加蓬,冈比亚,加纳,几内亚,南非,几内亚比绍,科特迪瓦,肯尼亚,莱索托,利比里亚,利比亚,马达加斯加,马拉维,马里,毛里塔尼亚,毛里求斯,摩洛哥,莫桑比克,尼日尔,尼日利亚,留尼旺岛,卢旺达,塞内加尔,塞舌尔,塞拉利昂,索马里,苏丹,斯威士兰,坦桑尼亚,圣赤勒拿,多哥,突尼斯,乌干达,扎伊尔,赞比亚,津巴布韦,纳米比亚,迪戈加西亚,桑给巴尔,马约特岛,圣多美和普林西比|欧洲,阿尔巴尼亚,安道尔,奥地利,比利时,保加利亚,捷克,丹麦,芬兰,法国,德国,直布罗陀(英),希腊,匈牙利,冰岛,爱尔兰,意大利,列支敦士登,斯洛伐克,卢森堡,马耳他,摩纳哥,荷兰,挪威,波兰,葡萄牙,马其顿,罗马尼亚,南斯拉夫,圣马力诺,西班牙,瑞典,瑞士,英国,科罗地亚,斯洛文尼亚,梵蒂冈,波斯尼亚和塞哥维那,俄罗斯联邦,亚美尼亚共和国,白俄罗斯共和国,格鲁吉亚共和国,哈萨克斯坦共和国,吉尔吉斯坦共和国,乌兹别克斯坦共和国,塔吉克斯坦共和国,土库曼斯坦共和国,乌克兰,立陶宛,拉脱维亚,爱沙尼亚,摩尔多瓦,阿塞拜疆|美洲,安圭拉岛,安提瓜和巴布达,阿根廷,阿鲁巴岛,阿森松,巴哈马,巴巴多斯,伯利兹,百慕大群岛,玻利维亚,巴西,加拿大,开曼群岛,智利,哥伦比亚,多米尼加联邦,哥斯达黎加,古巴,多米尼加共和国,厄瓜多尔,萨尔瓦多,法属圭亚那,格林纳达,危地马拉,圭亚那,海地,洪都拉斯,牙买加,马提尼克(法),墨西哥,蒙特塞拉特岛,荷属安的列斯群岛,尼加拉瓜,巴拿马,巴拉圭,秘鲁,波多黎哥,圣皮埃尔岛密克隆岛(法),圣克里斯托弗和尼维斯,圣卢西亚,福克兰群岛,维尔京群岛(英),圣文森特岛(英),维尔京群岛(美),苏里南,特立尼达和多巴哥,乌拉圭,美国,委内瑞拉,格陵兰岛,特克斯和凯科斯群岛,瓜多罗普|大洋洲,澳大利亚,科克群岛,斐济,法属波里尼西亚、塔希提,瓦努阿图,关岛,基里巴斯,马里亚纳群岛,中途岛,瑙鲁,新咯里多尼亚群岛,新西兰,巴布亚新几内亚,东萨摩亚,西萨摩亚,所罗门群岛,汤加,对诞岛,威克岛,科科斯岛,夏威夷,诺福克岛,帕劳,纽埃岛,图瓦卢,托克鲁,密克罗尼西亚,马绍尔群岛,瓦里斯加富士那群岛";
if (ShowT)PCAD = SPT + "$" + SCT + "," + SAT + "#" + PCAD;
PCAArea = [];
PCAP = [];
PCAC = [];
PCAA = [];
PCAN = PCAD.split("#");
for (i = 0; i < PCAN.length; i++) {
    PCAA[i] = [];
    TArea = PCAN[i].split("$")[1].split("|");
    for (j = 0; j < TArea.length; j++) {
        PCAA[i][j] = TArea[j].split(",");
        if (PCAA[i][j].length == 1)PCAA[i][j][1] = SAT;
        TArea[j] = TArea[j].split(",")[0]
    }
    PCAArea[i] = PCAN[i].split("$")[0] + "," + TArea.join(",");
    PCAP[i] = PCAArea[i].split(",")[0];
    PCAC[i] = PCAArea[i].split(',')
}
function PCAS() {
    this.SelP = document.getElementsByName(arguments[0])[0];
    this.SelC = document.getElementsByName(arguments[1])[0];
    this.SelA = document.getElementsByName(arguments[2])[0];
    this.DefP = this.SelA ? arguments[3] : arguments[2];
    this.DefC = this.SelA ? arguments[4] : arguments[3];
    this.DefA = this.SelA ? arguments[5] : arguments[4];
    this.SelP.PCA = this;
    this.SelC.PCA = this;
    this.SelP.onchange = function () {
        PCAS.SetC(this.PCA)
    };
    if (this.SelA)this.SelC.onchange = function () {
        PCAS.SetA(this.PCA)
    };
    PCAS.SetP(this)
};
PCAS.SetP = function (PCA) {
    for (i = 0; i < PCAP.length; i++) {
        PCAPT = PCAPV = PCAP[i];
        if (PCAPT == SPT)PCAPV = "";
        PCA.SelP.options.add(new Option(PCAPT, PCAPV));
        if (PCA.DefP == PCAPV)PCA.SelP[i].selected = true
    }
    PCAS.SetC(PCA)
};
PCAS.SetC = function (PCA) {
    PI = PCA.SelP.selectedIndex;
    PCA.SelC.length = 0;
    for (i = 1; i < PCAC[PI].length; i++) {
        PCACT = PCACV = PCAC[PI][i];
        if (PCACT == SCT)PCACV = "";
        PCA.SelC.options.add(new Option(PCACT, PCACV));
        if (PCA.DefC == PCACV)PCA.SelC[i - 1].selected = true
    }
    if (PCA.SelA)PCAS.SetA(PCA)
};
PCAS.SetA = function (PCA) {
    PI = PCA.SelP.selectedIndex;
    CI = PCA.SelC.selectedIndex;
    PCA.SelA.length = 0;
    for (i = 1; i < PCAA[PI][CI].length; i++) {
        PCAAT = PCAAV = PCAA[PI][CI][i];
        if (PCAAT == SAT)PCAAV = "";
        PCA.SelA.options.add(new Option(PCAAT, PCAAV));
        if (PCA.DefA == PCAAV)PCA.SelA[i - 1].selected = true
    }
}