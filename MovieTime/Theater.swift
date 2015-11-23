//
//  Theater.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/4/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import SwiftyJSON

class Theater{
    
    var name: String?
    var address: String?
    var phone: String?
    var area_id: Int?
    var theater_id: Int?
    
    init(name: String, address: String, phone: String, area_id: Int, theater_id: Int){
        self.name = name
        self.address = address
        self.phone = phone
        self.area_id = area_id
        self.theater_id = theater_id
    }
    
    
    static func getTheaterByID(the_theater_id: Int) -> Theater? {
        var the_theater: Theater? = nil
        if let dataFromString = theater_message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let jsonData = JSON(data: dataFromString)
            for theater in jsonData.arrayValue{
                var name: String = ""
                var address: String = ""
                var phone: String = ""
                var area_id: Int = 0
                var theater_id: Int = 0
                
                theater_id = theater["id"].int!
                name = theater["name"].stringValue
                address = theater["address"].stringValue
                phone = theater["phone"].stringValue
                area_id = theater["area_id"].int!
                if(the_theater_id == theater_id){
                    the_theater = Theater.init(name: name, address: address, phone: phone, area_id: area_id, theater_id: theater_id)
                    return the_theater
                }
            }
        }
        return the_theater
    }
    
    
    static func getTheaters(the_area_id: Int) -> [Theater]{
        var theaters = [Theater]()
        if let dataFromString = theater_message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let jsonData = JSON(data: dataFromString)
            for theater in jsonData.arrayValue{
                var name: String = ""
                var address: String = ""
                var phone: String = ""
                var area_id: Int = 0
                var theater_id: Int = 0
                
                theater_id = theater["id"].int!
                name = theater["name"].stringValue
                address = theater["address"].stringValue
                phone = theater["phone"].stringValue
                area_id = theater["area_id"].int!
                if(the_area_id == area_id){
                    let newTheater = Theater.init(name: name, address: address, phone: phone, area_id: area_id, theater_id: theater_id)
                    theaters.append(newTheater)
                }
            }
            return theaters
        }
        return theaters
    }
    
    static let theater_message: String = "[{\"id\":1,\"name\":\"總督影城\",\"address\":\"台北市松山區長安東路二段219號3樓\",\"phone\":\"02-27415991\",\"area_id\":1},{\"id\":2,\"name\":\"誠品電影院\",\"address\":\"台北市信義區菸廠路80號B2\",\"phone\":\"02-66365888\",\"area_id\":1},{\"id\":3,\"name\":\"哈拉數位影城\",\"address\":\"台北市內湖區康寧路三段72號6樓\",\"phone\":\"02-26322693\",\"area_id\":1},{\"id\":4,\"name\":\"喜滿客京華影城\",\"address\":\"台北市八德路四段138號B1(京華城購物中心地下一樓)\",\"phone\":\"02-37622001\",\"area_id\":1},{\"id\":5,\"name\":\"國賓影城(微風廣場)\",\"address\":\"台北市松山區復興南路一段39號10樓\",\"phone\":\"02-87721234\",\"area_id\":1},{\"id\":6,\"name\":\"大千電影院\",\"address\":\"台北市松山區南京東路三段133號\",\"phone\":\"02-87706565\",\"area_id\":1},{\"id\":7,\"name\":\"新民生戲院\",\"address\":\"台北市松山區民生東路五段190號3樓\",\"phone\":\"02-27653373\",\"area_id\":1},{\"id\":8,\"name\":\"梅花數位影城\",\"address\":\"台北市和平東路3段63號2F\",\"phone\":\"02-27326968\",\"area_id\":1},{\"id\":9,\"name\":\"信義威秀影城\",\"address\":\"台北市信義區松壽路18號\",\"phone\":\"02-87805566\",\"area_id\":1},{\"id\":10,\"name\":\"真善美劇院\",\"address\":\"台北市萬華區漢中街116號7樓\",\"phone\":\"02-23312270\",\"area_id\":2},{\"id\":11,\"name\":\"in89豪華數位影城\",\"address\":\"台北市萬華區武昌街二段89號\",\"phone\":\"02-23315077\",\"area_id\":2},{\"id\":12,\"name\":\"光點華山電影館\",\"address\":\"臺北市100中正區八德路一段1號（華山文創園區，中六館）\",\"phone\":\"02-23940622\",\"area_id\":2},{\"id\":13,\"name\":\"喜滿客絕色影城\",\"address\":\"台北市萬華區漢中街52號10、11樓\",\"phone\":\"02-23811339\",\"area_id\":2},{\"id\":14,\"name\":\"國賓大戲院(西門)\",\"address\":\"台北市萬華區成都路88號\",\"phone\":\"02-23611222\",\"area_id\":2},{\"id\":15,\"name\":\"新光影城\",\"address\":\"台北市萬華區西寧南路36號4樓(西門町獅子林商業大樓)\",\"phone\":\"02-23146668\",\"area_id\":2},{\"id\":16,\"name\":\"日新威秀影城\",\"address\":\"台北市萬華區武昌街二段87號2樓\",\"phone\":\"02-23315256\",\"area_id\":2},{\"id\":17,\"name\":\"樂聲影城\",\"address\":\"台北市萬華區武昌街二段85號\",\"phone\":\"02-23118628\",\"area_id\":2},{\"id\":18,\"name\":\"京站威秀影城\",\"address\":\"台北市大同區市民大道一段209號5樓\",\"phone\":\"02-25525511\",\"area_id\":2},{\"id\":19,\"name\":\"今日秀泰影城\",\"address\":\"台北市西門町峨眉街52號4樓\",\"phone\":\"02-23751669\",\"area_id\":2},{\"id\":20,\"name\":\"百老匯數位影城\",\"address\":\"台北市文山區羅斯福路四段200號 4 樓\",\"phone\":\"02-86636128\",\"area_id\":3},{\"id\":21,\"name\":\"東南亞秀泰影城\",\"address\":\"台北市中正區羅斯福路四段 136 巷 3 號\",\"phone\":\"02-23678999\",\"area_id\":3},{\"id\":22,\"name\":\"美麗華(大直影城)\",\"address\":\"台北市中山區敬業三路22號6樓\",\"phone\":\"02-85022208\",\"area_id\":4},{\"id\":24,\"name\":\"華威天母影城\",\"address\":\"台北市士林區忠誠路二段202號4樓\",\"phone\":\"02-28763300\",\"area_id\":4},{\"id\":25,\"name\":\"光點台北電影主題館\",\"address\":\"台北市中山區中山北路2段18號\",\"phone\":\"02-25117786\",\"area_id\":4},{\"id\":26,\"name\":\"國賓影城(台北長春廣場)\",\"address\":\"台北市長春路176號\",\"phone\":\"02-25155755\",\"area_id\":4},{\"id\":27,\"name\":\"士林陽明戲院\",\"address\":\"台北市士林區文林路113號\",\"phone\":\"02-28814636\",\"area_id\":4},{\"id\":28,\"name\":\"欣欣秀泰影城\",\"address\":\"台北市中山區林森北路247號4樓\",\"phone\":\"02-25371889\",\"area_id\":4},{\"id\":30,\"name\":\"鴻金寶麻吉影城\",\"address\":\"新北市新莊區民安路188巷5號\",\"phone\":\"02-22070222\",\"area_id\":5},{\"id\":31,\"name\":\"國賓影城(林口昕境廣場)\",\"address\":\"新北市林口區文化三路一段402巷2號4F（昕境廣場）\",\"phone\":\"02-26080011\",\"area_id\":5},{\"id\":32,\"name\":\"國賓影城(中和環球購物中心)\",\"address\":\"新北市中和區中山路三段122號4樓\",\"phone\":\"02-22268088\",\"area_id\":5},{\"id\":33,\"name\":\"府中15\",\"address\":\"新北市板橋區府中路15號B1\",\"phone\":\"(02)2511-7786\",\"area_id\":5},{\"id\":34,\"name\":\"板橋秀泰影城\",\"address\":\"新北市板橋區縣民大道2段3號\",\"phone\":\"02-22720639\",\"area_id\":5},{\"id\":35,\"name\":\"板橋大遠百威秀影城\",\"address\":\"新北市板橋區新站路28號10樓\",\"phone\":\"02-77386608\",\"area_id\":5},{\"id\":36,\"name\":\"三重天台戲院\",\"address\":\"新北市三重區重新路二段78號4F(天台廣場)\",\"phone\":\"02-29787700\",\"area_id\":5},{\"id\":37,\"name\":\"三重幸福戲院\",\"address\":\"新北市三重區三和路四段163巷12號\",\"phone\":\"02-22876709\",\"area_id\":5},{\"id\":38,\"name\":\"景美佳佳戲院\",\"address\":\"台北市文山區羅斯福路6段403號4樓\",\"phone\":\"02-29330333\",\"area_id\":6},{\"id\":39,\"name\":\"朝代戲院\",\"address\":\"台北市大同區民權西路136號4樓\",\"phone\":\"02-25571300\",\"area_id\":6},{\"id\":40,\"name\":\"湳山戲院\",\"address\":\"台北市大安區通化街24巷1號\",\"phone\":\"02-27023130\",\"area_id\":6},{\"id\":41,\"name\":\"基隆秀泰影城\",\"address\":\"基隆市中正區信一路177號7-10F(基隆市文化中心旁)\",\"phone\":\"02-24212388\",\"area_id\":7},{\"id\":42,\"name\":\"統領戲院\",\"address\":\"桃園縣桃園市中正路56號3-5樓\",\"phone\":\"03-3329398\",\"area_id\":8},{\"id\":43,\"name\":\"美麗華台茂影城\",\"address\":\"桃園縣蘆竹鄉南崁路一段112號7樓\",\"phone\":\"03-3113123\",\"area_id\":8},{\"id\":44,\"name\":\"民和戲院\",\"address\":\"桃園縣八德市廣福路80號3樓\",\"phone\":\"03-3777437\",\"area_id\":8},{\"id\":45,\"name\":\"SBC星橋國際影城\",\"address\":\"桃園縣中壢市中園路二段509號6樓\",\"phone\":\"03-4680080\",\"area_id\":9},{\"id\":46,\"name\":\"威尼斯影城\",\"address\":\"桃園縣中壢市九和一街48號3樓\",\"phone\":\"03-2805018\",\"area_id\":9},{\"id\":47,\"name\":\"中源戲院\",\"address\":\"桃園縣中壢市日新路97號3樓之1\",\"phone\":\"03-4562414\",\"area_id\":9},{\"id\":48,\"name\":\"國際影城國際館\",\"address\":\"新竹市文昌街39號\",\"phone\":\"03-5222134\",\"area_id\":10},{\"id\":49,\"name\":\"國際影城中興館\",\"address\":\"新竹市東區林森路32號7樓\",\"phone\":\"03-5237077\",\"area_id\":10},{\"id\":50,\"name\":\"國賓影城(環球新竹世博店)\",\"address\":\"新竹市東區公道五路三段8號1樓\",\"phone\":\"03-5721128\",\"area_id\":10},{\"id\":51,\"name\":\"新竹大遠百威秀影城\",\"address\":\"新竹市東區西大路323號8樓\",\"phone\":\"03-5452345\",\"area_id\":10},{\"id\":53,\"name\":\"新竹巨城威秀影城\",\"address\":\"新竹市東區民權路176號4樓之3\",\"phone\":\"03-5346999\",\"area_id\":10},{\"id\":54,\"name\":\"新復珍戲院\",\"address\":\"新竹市北門街6號1樓\",\"phone\":\"035-248285\",\"area_id\":10},{\"id\":56,\"name\":\"頭份尚順威秀影城\",\"address\":\"苗栗縣頭份鎮中央路105號7樓\",\"phone\":\"037-686866\",\"area_id\":11},{\"id\":57,\"name\":\"國興戲院\",\"address\":\"苗栗縣苗栗市勝利里國際一巷3號\",\"phone\":\"037-320363\",\"area_id\":11},{\"id\":58,\"name\":\"東聲戲院\",\"address\":\"苗栗縣頭份鎮中華路1091號3樓\",\"phone\":\"037-664735\",\"area_id\":11},{\"id\":59,\"name\":\"華威台中影城\",\"address\":\"台中市西區臺灣大道二段459號17樓\",\"phone\":\"04-23103768\",\"area_id\":12},{\"id\":60,\"name\":\"萬代福戲院\",\"address\":\"台中市中區公園路38號\",\"phone\":\"04-22210356\",\"area_id\":12},{\"id\":61,\"name\":\"親親數位影城\",\"address\":\"台中市北區北屯路14號\",\"phone\":\"04-22319111\",\"area_id\":12},{\"id\":62,\"name\":\"豐源國際影城\",\"address\":\"台中縣豐原市中正路137號\",\"phone\":\"04-25260036\",\"area_id\":12},{\"id\":63,\"name\":\"Tiger City威秀影城(老虎城)\",\"address\":\"台中市西屯區河南路三段120號4樓\",\"phone\":\"04-36065566\",\"area_id\":12},{\"id\":65,\"name\":\"全球影城\",\"address\":\"台中市西區中華路一段1號之1\",\"phone\":\"04-22242588\",\"area_id\":12},{\"id\":66,\"name\":\"台中大遠百威秀影城\",\"address\":\"台中市台中港路二段105號13樓\",\"phone\":\"04-22588511\",\"area_id\":12},{\"id\":67,\"name\":\"新光影城\",\"address\":\"台中市西屯區中港路二段111號13樓\",\"phone\":\"04-22589911\",\"area_id\":12},{\"id\":68,\"name\":\"新時代威秀影城\",\"address\":\"台中市東區復興路四段186號4-5樓\",\"phone\":\"04-36085566\",\"area_id\":12},{\"id\":69,\"name\":\"日新大戲院\",\"address\":\"台中市中華路一段58號\",\"phone\":\"04-22243355\",\"area_id\":12},{\"id\":70,\"name\":\"時代數位3D影城\",\"address\":\"台中市清水區光復街65號3樓\",\"phone\":\"04-26222206\",\"area_id\":12},{\"id\":71,\"name\":\"台灣戲院\",\"address\":\"彰化縣彰化市中正路二段48號\",\"phone\":\"04-7222213\",\"area_id\":13},{\"id\":72,\"name\":\"員林3D影城\",\"address\":\"彰化縣員林鎮南昌路39號3樓\",\"phone\":\"04-8351667\",\"area_id\":13},{\"id\":73,\"name\":\"彰化戲院\",\"address\":\"彰化縣彰化市中正路二段153號5樓\",\"phone\":\"04-7255669\",\"area_id\":13},{\"id\":74,\"name\":\"虎尾白宮影城\",\"address\":\"雲林縣虎尾鎮中正路257號\",\"phone\":\"05-6322328\",\"area_id\":14},{\"id\":75,\"name\":\"中華電影城\",\"address\":\"雲林縣斗六市雲林路二段19號\",\"phone\":\"05-5354828\",\"area_id\":14},{\"id\":76,\"name\":\"南投戲院\",\"address\":\"南投縣南投市大同街87號\",\"phone\":\"049-2234788\",\"area_id\":15},{\"id\":77,\"name\":\"埔里山明戲院\",\"address\":\"南投縣埔里鎮中山路二段289號之1\",\"phone\":\"049-2997878\",\"area_id\":15},{\"id\":78,\"name\":\"嘉年華影城\",\"address\":\"嘉義市東區中山路617號\",\"phone\":\"05-2250289\",\"area_id\":16},{\"id\":79,\"name\":\"新榮戲院\",\"address\":\"嘉義市新榮路52號\",\"phone\":\"05-2255366\",\"area_id\":16},{\"id\":80,\"name\":\"麻豆戲院\",\"address\":\"台南縣麻豆鎮興中路106號3樓\",\"phone\":\"06-5722159\",\"area_id\":17},{\"id\":81,\"name\":\"全美戲院\",\"address\":\"台南市中西區永福路二段187號\",\"phone\":\"06-2224726\",\"area_id\":17},{\"id\":82,\"name\":\"南台電影城\",\"address\":\"台南市中西區友愛街317號1樓\",\"phone\":\"06-2232426-7\",\"area_id\":17},{\"id\":83,\"name\":\"台南南紡夢時代威秀影城\",\"address\":\"台南市東區中華東路一段366號5樓\",\"phone\":\"06-2372255\",\"area_id\":17},{\"id\":85,\"name\":\"台南大遠百威秀影城\",\"address\":\"台南市中西區公園路60號8樓\",\"phone\":\"06-6005566\",\"area_id\":17},{\"id\":86,\"name\":\"國賓影城(台南國賓廣場)\",\"address\":\"台南市東區中華東路一段66號3樓\",\"phone\":\"06-2347166\",\"area_id\":17},{\"id\":87,\"name\":\"新光影城\",\"address\":\"台南市中西區西門路一段658號8樓\",\"phone\":\"06-3031260\",\"area_id\":17},{\"id\":88,\"name\":\"今日戲院\",\"address\":\"台南市中西區中正路249號\",\"phone\":\"06-2205151\",\"area_id\":17},{\"id\":89,\"name\":\"高雄環球數位3D影城\",\"address\":\"高雄市苓雅區大順三路108號\",\"phone\":\"07-7220066\",\"area_id\":18},{\"id\":90,\"name\":\"高雄大遠百威秀影城\",\"address\":\"高雄市苓雅區三多四路21號13樓\",\"phone\":\"07-3345566\",\"area_id\":18},{\"id\":92,\"name\":\"MLD影城\",\"address\":\"高雄市前鎮區忠勤路8號\",\"phone\":\"07-5365388\",\"area_id\":18},{\"id\":93,\"name\":\"十全數位3D影城\",\"address\":\"高雄市三民區十全二路21號\",\"phone\":\"07-3117141\",\"area_id\":18},{\"id\":94,\"name\":\"和春影城\",\"address\":\"高雄市三民區建興路391號\",\"phone\":\"07-3847686\",\"area_id\":18},{\"id\":95,\"name\":\"喜滿客美奇萊影城\",\"address\":\"高雄市三民區十全一路161號\",\"phone\":\"07-3210663\",\"area_id\":18},{\"id\":96,\"name\":\"喜滿客夢時代影城\",\"address\":\"高雄市前鎮區中華5路789號8樓\",\"phone\":\"07-9702001\",\"area_id\":18},{\"id\":97,\"name\":\"國賓影城(高雄義大世界)\",\"address\":\"高雄縣大樹鄉學城路一段12號3樓\",\"phone\":\"07-6568368\",\"area_id\":18},{\"id\":98,\"name\":\"奧斯卡3D數位影城\",\"address\":\"高雄市新興區仁智街287號\",\"phone\":\"07-2412128\",\"area_id\":18},{\"id\":99,\"name\":\"岡山統一戲院\",\"address\":\"高雄縣岡山鎮壽天路103號之10\",\"phone\":\"07-6223300\",\"area_id\":18},{\"id\":100,\"name\":\"三多數位3D影城\",\"address\":\"高雄市苓雅區三多四路123號\",\"phone\":\"07-3346285\",\"area_id\":18},{\"id\":101,\"name\":\"友愛影城\",\"address\":\"宜蘭縣宜蘭市舊城東路50號7樓\",\"phone\":\"039-315035\",\"area_id\":19},{\"id\":102,\"name\":\"新月豪華影城\",\"address\":\"宜蘭縣宜蘭市民權路二段38巷2號 新月廣場3F\",\"phone\":\"03-9328833\",\"area_id\":19},{\"id\":103,\"name\":\"日新戲院\",\"address\":\"宜蘭縣羅東鎮中山西街17號之1\",\"phone\":\"039-542835\",\"area_id\":19},{\"id\":104,\"name\":\"日新戲院統一廳\",\"address\":\"宜蘭縣羅東鎮公園路100號3樓\",\"phone\":\"(03)9571636\",\"area_id\":19},{\"id\":105,\"name\":\"花蓮秀泰影城\",\"address\":\"花蓮縣花蓮市國聯五路69號\",\"phone\":\"03-8337118\",\"area_id\":20},{\"id\":108,\"name\":\"台東秀泰影城\",\"address\":\"台東縣台東市鐵花里5鄰新生路93號\",\"phone\":\"089-320-388\",\"area_id\":21},{\"id\":109,\"name\":\"金獅影城\",\"address\":\"金門縣金湖鎮中山路8-5號(西棟3F)\",\"phone\":\"0800-586-388\",\"area_id\":22},{\"id\":110,\"name\":\"國賓影城(金門昇恆昌金湖廣場)\",\"address\":\"金門縣金湖鎮太湖路二段198號6樓\",\"phone\":\"\",\"area_id\":22},{\"id\":111,\"name\":\"國賓屏東環球影城\",\"address\":\"屏東市仁愛路90號6、7樓\",\"phone\":\"08-7662128\",\"area_id\":23},{\"id\":112,\"name\":\"中影屏東影城\",\"address\":\"屏東市民生路248號3、4樓\",\"phone\":\"08-7322043, 08-7331865\",\"area_id\":23},{\"id\":113,\"name\":\"澎湖中興電影城\",\"address\":\"澎湖縣馬公市文康街37號\",\"phone\":\"069-265-681\",\"area_id\":24},{\"id\":227,\"name\":\"林園電影城\",\"address\":\"新北市板橋區館前西路158號\",\"phone\":\"(02)2960-6099\",\"area_id\":5},{\"id\":37,\"name\":\"三重幸福戲院\",\"address\":\"新北市三重區三和路四段163巷12號\",\"phone\":\"02-22876709\",\"area_id\":25},{\"id\":38,\"name\":\"景美佳佳戲院\",\"address\":\"台北市文山區羅斯福路6段403號4樓\",\"phone\":\"02-29330333\",\"area_id\":25},{\"id\":39,\"name\":\"朝代戲院\",\"address\":\"台北市大同區民權西路136號4樓\",\"phone\":\"02-25571300\",\"area_id\":25},{\"id\":40,\"name\":\"湳山戲院\",\"address\":\"台北市大安區通化街24巷1號\",\"phone\":\"02-27023130\",\"area_id\":25},{\"id\":44,\"name\":\"民和戲院\",\"address\":\"桃園縣八德市廣福路80號3樓\",\"phone\":\"03-3777437\",\"area_id\":25},{\"id\":47,\"name\":\"中源戲院\",\"address\":\"桃園縣中壢市日新路97號3樓之1\",\"phone\":\"03-4562414\",\"area_id\":25},{\"id\":54,\"name\":\"新復珍戲院\",\"address\":\"新竹市北門街6號1樓\",\"phone\":\"035-248285\",\"area_id\":25},{\"id\":58,\"name\":\"東聲戲院\",\"address\":\"苗栗縣頭份鎮中華路1091號3樓\",\"phone\":\"037-664735\",\"area_id\":25},{\"id\":60,\"name\":\"萬代福戲院\",\"address\":\"台中市中區公園路38號\",\"phone\":\"04-22210356\",\"area_id\":25},{\"id\":79,\"name\":\"新榮戲院\",\"address\":\"嘉義市新榮路52號\",\"phone\":\"05-2255366\",\"area_id\":25},{\"id\":81,\"name\":\"全美戲院\",\"address\":\"台南市中西區永福路二段187號\",\"phone\":\"06-2224726\",\"area_id\":25},{\"id\":88,\"name\":\"今日戲院\",\"address\":\"台南市中西區中正路249號\",\"phone\":\"06-2205151\",\"area_id\":25},{\"id\":93,\"name\":\"十全數位3D影城\",\"address\":\"高雄市三民區十全二路21號\",\"phone\":\"07-3117141\",\"area_id\":25},{\"id\":94,\"name\":\"和春影城\",\"address\":\"高雄市三民區建興路391號\",\"phone\":\"07-3847686\",\"area_id\":25},{\"id\":227,\"name\":\"林園電影城\",\"address\":\"新北市板橋區館前西路158號\",\"phone\":\"(02)2960-6099\",\"area_id\":25}]"
    
}
