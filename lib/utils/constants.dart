const Map<String, String> provincesMap = {
  // Đông Bắc Bộ
  'Hà Giang': 'ha-giang',
  'Cao Bằng': 'cao-bang',
  'Bắc Kạn': 'bac-kan',
  'Tuyên Quang': 'tuyen-quang',
  'Thái Nguyên': 'thai-nguyen',
  'Lạng Sơn': 'lang-son',
  'Quảng Ninh': 'quang-ninh',
  'Bắc Giang': 'bac-giang',
  'Phú Thọ': 'phu-tho',

  // Tây Bắc Bộ
  'Lào Cai': 'lao-cai',
  'Điện Biên': 'dien-bien',
  'Lai Châu': 'lai-chau',
  'Sơn La': 'son-la',
  'Yên Bái': 'yen-bai',
  'Hòa Bình': 'hoa-binh',

  // Đồng bằng sông Hồng
  'Hà Nội': 'ha-noi',
  'Vĩnh Phúc': 'vinh-phuc',
  'Bắc Ninh': 'bac-ninh',
  'Hải Dương': 'hai-duong',
  'Hải Phòng': 'hai-phong',
  'Hưng Yên': 'hung-yen',
  'Thái Bình': 'thai-binh',
  'Hà Nam': 'ha-nam',
  'Nam Định': 'nam-dinh',
  'Ninh Bình': 'ninh-binh',

  // Bắc Trung Bộ
  'Thanh Hóa': 'thanh-hoa',
  'Nghệ An': 'nghe-an',
  'Hà Tĩnh': 'ha-tinh',
  'Quảng Bình': 'quang-binh',
  'Quảng Trị': 'quang-tri',
  'Thừa Thiên Huế': 'thua-thien-hue',

  // Nam Trung Bộ
  'Đà Nẵng': 'da-nang',
  'Quảng Nam': 'quang-nam',
  'Quảng Ngãi': 'quang-ngai',
  'Bình Định': 'binh-dinh',
  'Phú Yên': 'phu-yen',
  'Khánh Hòa': 'khanh-hoa',
  'Ninh Thuận': 'ninh-thuan',
  'Bình Thuận': 'binh-thuan',

  // Tây Nguyên
  'Kon Tum': 'kon-tum',
  'Gia Lai': 'gia-lai',
  'Đắk Lắk': 'dak-lak',
  'Đắk Nông': 'dak-nong',
  'Lâm Đồng': 'lam-dong',

  // Đông Nam Bộ
  'Bình Phước': 'binh-phuoc',
  'Tây Ninh': 'tay-ninh',
  'Bình Dương': 'binh-duong',
  'Đồng Nai': 'dong-nai',
  'Bà Rịa - Vũng Tàu': 'ba-ria-vung-tau',
  'TP. Hồ Chí Minh': 'ho-chi-minh',

  // Đồng bằng sông Cửu Long
  'Long An': 'long-an',
  'Tiền Giang': 'tien-giang',
  'Bến Tre': 'ben-tre',
  'Trà Vinh': 'tra-vinh',
  'Vĩnh Long': 'vinh-long',
  'Đồng Tháp': 'dong-thap',
  'An Giang': 'an-giang',
  'Kiên Giang': 'kien-giang',
  'Cần Thơ': 'can-tho',
  'Hậu Giang': 'hau-giang',
  'Sóc Trăng': 'soc-trang',
  'Bạc Liêu': 'bac-lieu',
  'Cà Mau': 'ca-mau',
};

const String defaultBackground =
    'https://images.unsplash.com/photo-1601134467661-3d775b999c8b?q=80&w=1080&auto=format&fit=crop';

const Map<String, String> provinceBackgrounds = {
  'ha-giang':
      'https://cdn.xanhsm.com/2025/02/e17bf167-dia-diem-du-lich-ha-giang-1.jpg',
  'cao-bang':
      'https://cdn.tcdulichtphcm.vn/upload/3-2024/images/2024-09-09/1725854808-thac-bg.jpg',
  'bac-kan': 'https://cdn3.ivivu.com/2024/09/ho-ba-be-iVIVU-e1725613566982.jpg',
  'tuyen-quang':
      'https://statics.vinpearl.com/dinh-tan-trao-tuyen-quang_1740055523.jpg',
  'thai-nguyen':
      'https://dulichhonuicoc.vn/wp-content/uploads/2023/07/khu-du-lich-ho-nui-coc-o-thai-nguyen-4.png',
  'lang-son':
      'https://media.vietnamplus.vn/images/c14f6479e83e315b4cf3a2906cc6a51ec695c840d49973876fe5fdac480d33fdf3838af4d318965f9c460d85fa4815b992e80288103f1a438123023cdb097084/ttxvnmau_son8.jpg.webp',
  'quang-ninh':
      'https://vitracotour.com/wp-content/uploads/2024/03/vietgoing_gcn2101205075.jpg.webp',
  'bac-giang':
      'https://bizweb.dktcdn.net/100/101/075/files/hinh-anh-o-tay-yen-tu.jpg?v=1672285321033',
  'phu-tho': 'https://static.vinwonders.com/production/den-hung-top-banner.jpg',

  'lao-cai':
      'https://static.vinwonders.com/production/fansipan-weather-banner.jpg',
  'dien-bien':
      'https://bizweb.dktcdn.net/100/006/093/files/tuong-dai-chien-thang-dien-bien-phu-1.jpg?v=1709521625245',
  'lai-chau':
      'https://sun-ecommerce-cdn.azureedge.net/ecommerce/service-sites/asset/SunWorldFansipan/%E1%BA%A2nh%20B%C3%A0i%20SEO/cau-kinh-sapa/cau-kinh-sapa%20%286%29.jpg',
  'son-la':
      'https://ik.imagekit.io/tvlk/blog/2024/01/du-lich-moc-chau-mua-nao-dep-2.jpg',
  'yen-bai':
      'https://vj-prod-website-cms.s3.ap-southeast-1.amazonaws.com/shutterstock2246073829-1701309980693.jpg',
  'hoa-binh':
      'https://cloudcdnvod.tek4tv.vn/Mam/attach/upload/22092024112130/112136_hothuydienhoabinh.jpg',

  'ha-noi': 'https://static.vinwonders.com/production/thap-rua-ho-guom-2.jpg',
  'vinh-phuc':
      'https://vietsensetravel.com/nview/at_gioi-thieu-du-lich-vinh-phuc_67f128e1c320abcce29a964aa9985bf0.gif',
  'bac-ninh':
      'https://www.phattuvietnam.net/wp-content/uploads/2025/03/Chua-Dau-bac-ninh-6.jpg',
  'hai-duong':
      'https://static.vinwonders.com/production/2025/07/gioi-thieu-den-kiep-bac.jpg',
  'hai-phong':
      'https://sun-ecommerce-cdn.azureedge.net/ecommerce/service-sites/asset/SunWorldCatBa/swold/cat-ba-co-gi-choi/cat-ba-co-gi-choi%20%289%29.jpg',
  'hung-yen':
      'https://static.vinwonders.com/production/chua-chuong-pho-hien-hung-yen.jpg',
  'thai-binh':
      'https://media-cdn-v2.laodong.vn/storage/newsportal/2023/7/30/1222969/Chua-Keo-24.jpg',
  'ha-nam':
      'https://imagevietnam.vnanet.vn//MediaUpload/Org/2024/12/13/313-11-30-34.jpg',
  'nam-dinh': 'https://cdn3.ivivu.com/2023/01/nha-tho-Phu-Nhai-ivivu.jpg',
  'ninh-binh':
      'https://toursdulichninhbinh.com/wp-content/uploads/2021/05/cuoc-dua-lot-vao-top-100-anh-dep-di-san-van-hoa-va-thien-7edf3.jpg',

  'thanh-hoa': 'https://statics.vinpearl.com/thanh-nha-ho-5_1629181204.jpg',
  'nghe-an':
      'https://s-cdn.dbndnghean.vn/dbndna-media/21/12/8/bna_tuong_dai_bac_ho_tai_quang_truong_ho_chi_minh3395990_8122021.jpg?md5=CXxskMdHBf-ZFVtBl7Onig&expires=1780473145',
  'ha-tinh':
      'https://cdn.daidoanket.vn/w1200/uploaded/images/2025/09/08/09aac1d1-5fa1-4e47-b52c-9a597058f430.jpg',
  'quang-binh':
      'https://images2.thanhnien.vn/528068263637045248/2024/1/3/h5-17042820628851891216737.jpg',
  'quang-tri':
      'https://s3-ap-southeast-1.amazonaws.com/cntatr-assets-ap-southeast-1-250226768838-55a62c9399d4d8a6/2023/05/thanh-co-quang-tri-6-1024x768.jpg?tr=q-70,c-at_max,w-1000,h-600',
  'thua-thien-hue':
      'https://image.vietgoing.com/destination/large/vietgoing_awy2103053798.webp',

  'da-nang':
      'https://cdnphoto.dantri.com.vn/m-g8nlg06kMKlBiZddeSddryC7c=/thumb_w/1020/2024/05/07/a2-3-1715069946395.jpg',
  'quang-nam':
      'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/pho_co_hoi_an_69ea262efc.jpg',
  'quang-ngai':
      'https://vcdn1-dulich.vnecdn.net/2025/05/16/8e64ee43e23a57640e2b-174736902-2180-3575-1747370044.jpg?w=1200&h=0&q=100&dpr=1&fit=crop&s=j8VjpJ1BTJCZpil_MYUJxA',
  'binh-dinh':
      'https://letsflytravel.vn/wp-content/uploads/2024/12/86f1489e-ky-co-quy-nhon-1.jpg',
  'phu-yen':
      'https://cdn.tienphong.vn/images/bdfc554ea35983ad68a96e0050b6e2cbe7c45a8e9b0946ed09b63dff3c8ccd03c1e3929cc434d59c277a5090dcf388a15791eca9a4fe6e9028195525f348b3944af3914b2d192a8944cd96cc003f867a/ghenh-da-dia-8-2722.jpg.webp',
  'khanh-hoa':
      'https://cdn.nhandan.vn/images/22f099ca8bc7ae81aa2a8d3416a84bf849cd557cb6f3fd6b5b0c2b71dee43fd337074b0e507bb38fe09f8ccde7b10a53900f19d7f1ce8577fb5d35030d12986b/4-902-6587.jpg.webp',
  'ninh-thuan':
      'https://cdn3.ivivu.com/2022/10/Po-Klong-Garai-ivivu-5-@vanhoachampa1221.jpg',
  'binh-thuan':
      'https://edenseekega.com/wp-content/uploads/2025/01/doi-cat-mui-ne-phan-thiet-check-in-e1763634272927.webp',

  'kon-tum':
      'https://cdn3.ivivu.com/2024/10/nha-tho-go-kontum-ivivu-1-1024x683.jpg',
  'gia-lai': 'https://sakos.vn/wp-content/uploads/2024/08/1-18.jpg',
  'dak-lak':
      'https://lalago.vn/wp-content/uploads/2025/06/Ho-Lak-Dak-Lak-18.jpg',
  'dak-nong':
      'https://images.vietnamtourism.gov.vn/vn/images/2021/Thang_4/ho-ta-dung1.png',
  'lam-dong':
      'https://khamphavn.edu.vn/upload/2025/12/ho-xuan-huong-da-lat-001.webp',

  'binh-phuoc':
      'https://exotrails.com/wp-content/uploads/2025/01/bugiamap5.jpg',
  'tay-ninh':
      'https://static.vinwonders.com/production/2025/07/du-lich-tay-ninh-nui-ba-den.jpg',
  'binh-duong':
      'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2018/06/pn-2.jpg',
  'dong-nai':
      'https://vietrektravel.com/ckeditor/plugins/fileman/Uploads/FLV/Thac-Giang-Dien.jpg',
  'ba-ria-vung-tau':
      'https://static.vinwonders.com/production/2025/06/cong-trinh-kien-truc-tuong-chua-kito.jpg',
  'ho-chi-minh':
      'https://media.istockphoto.com/id/487343244/vi/anh/ch%E1%BB%A3-b%E1%BA%BFn-th%C3%A0nh-v%C3%A0o-s%C3%A1ng-s%E1%BB%9Bm.jpg?s=612x612&w=0&k=20&c=HZeQ_RWW9Edr7VV7qsjK8nPQ15gdoapRB6-kPzhc2a0=',

  'long-an':
      'https://ik.imagekit.io/tvlk/blog/2022/12/dia-diem-du-lich-long-an-2.jpg?tr=q-70,c-at_max,w-1000,h-600',
  'tien-giang':
      'https://dulichviet.com.vn/images/bandidau/cho-noi-cai-be-tien-giang-hanh-trinh-kham-pha-net-dep-song-nuoc.jpg',
  'ben-tre':
      'https://ticotravel.com.vn/wp-content/uploads/2024/12/con-phung-2.jpg',
  'tra-vinh':
      'https://thamhiemmekong.com/wp-content/uploads/2020/06/aobaom-02.jpg',
  'vinh-long':
      'https://cafefcdn.com/203337114487263232/2025/9/19/d23e2420fab553eb0aa4-170201770906349367236-1758182175065991140261-1758243462853-1758243463274543976110.jpg',
  'dong-thap':
      'https://bazaarvietnam.vn/wp-content/uploads/2025/08/harper-bazaar-khu-du-lich-xeo-quyt-dong-thap-2-e1754921826587.jpeg',
  'an-giang':
      'https://media.vietravel.com/images/Content/du-lich-mien-tay-nui-cam-an-giang-3.png',
  'kien-giang':
      'https://photo2.tinhte.vn/data/attachment-files/2025/06/8749364_Ho_Chi_Minh_Phu_Quoc.webp',
  'can-tho':
      'https://cdn-i2.congthuong.vn/stores/news_dataimages/nguyenly/022021/24/14/cho20noi20210224145429.6372740.jpg',
  'hau-giang':
      'https://upload.wikimedia.org/wikipedia/commons/2/29/Lung_Ngoc_Hoang_Trees.jpg',
  'soc-trang':
      'https://thamhiemmekong.com/wp-content/uploads/2020/03/chua-doi.jpg',
  'bac-lieu':
      'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/12/28/1132170/Nha-Cong-Tu-Can-Canh.JPG',
  'ca-mau':
      'https://gody.vn/public/Media_User/ynhacvh9109/3-2019/mui-ca-mau-dat-mui-landmark/75028803-20190312155858-mui-ca-mau-dat-mui-landmark.jpg',
};

const Map<String, List<String>> regionsMap = {
  'Đông Bắc Bộ': [
    'Hà Giang',
    'Cao Bằng',
    'Bắc Kạn',
    'Tuyên Quang',
    'Thái Nguyên',
    'Lạng Sơn',
    'Quảng Ninh',
    'Bắc Giang',
    'Phú Thọ',
  ],
  'Tây Bắc Bộ': [
    'Lào Cai',
    'Điện Biên',
    'Lai Châu',
    'Sơn La',
    'Yên Bái',
    'Hòa Bình',
  ],
  'ĐBSH': [
    'Hà Nội',
    'Vĩnh Phúc',
    'Bắc Ninh',
    'Hải Dương',
    'Hải Phòng',
    'Hưng Yên',
    'Thái Bình',
    'Hà Nam',
    'Nam Định',
    'Ninh Bình',
  ],
  'Bắc Trung Bộ': [
    'Thanh Hóa',
    'Nghệ An',
    'Hà Tĩnh',
    'Quảng Bình',
    'Quảng Trị',
    'Thừa Thiên Huế',
  ],
  'Nam Trung Bộ': [
    'Đà Nẵng',
    'Quảng Nam',
    'Quảng Ngãi',
    'Bình Định',
    'Phú Yên',
    'Khánh Hòa',
    'Ninh Thuận',
    'Bình Thuận',
  ],
  'Tây Nguyên': ['Kon Tum', 'Gia Lai', 'Đắk Lắk', 'Đắk Nông', 'Lâm Đồng'],
  'Đông Nam Bộ': [
    'Bình Phước',
    'Tây Ninh',
    'Bình Dương',
    'Đồng Nai',
    'Bà Rịa - Vũng Tàu',
    'TP. Hồ Chí Minh',
  ],
  'ĐBSCL': [
    'Long An',
    'Tiền Giang',
    'Bến Tre',
    'Trà Vinh',
    'Vĩnh Long',
    'Đồng Tháp',
    'An Giang',
    'Kiên Giang',
    'Cần Thơ',
    'Hậu Giang',
    'Sóc Trăng',
    'Bạc Liêu',
    'Cà Mau',
  ],
};
