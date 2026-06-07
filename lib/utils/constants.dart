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
  'ha-giang': defaultBackground,
  'cao-bang': defaultBackground,
  'bac-kan': defaultBackground,
  'tuyen-quang': defaultBackground,
  'thai-nguyen': defaultBackground,
  'lang-son': defaultBackground,
  'quang-ninh': defaultBackground,
  'bac-giang': defaultBackground,
  'phu-tho': defaultBackground,

  'lao-cai': defaultBackground,
  'dien-bien': defaultBackground,
  'lai-chau': defaultBackground,
  'son-la': defaultBackground,
  'yen-bai': defaultBackground,
  'hoa-binh': defaultBackground,

  'ha-noi': defaultBackground,
  'vinh-phuc': defaultBackground,
  'bac-ninh': defaultBackground,
  'hai-duong': defaultBackground,
  'hai-phong': defaultBackground,
  'hung-yen': defaultBackground,
  'thai-binh': defaultBackground,
  'ha-nam': defaultBackground,
  'nam-dinh': defaultBackground,
  'ninh-binh': defaultBackground,

  'thanh-hoa': defaultBackground,
  'nghe-an': defaultBackground,
  'ha-tinh': defaultBackground,
  'quang-binh': defaultBackground,
  'quang-tri': defaultBackground,
  'thua-thien-hue': defaultBackground,

  'da-nang':
      'https://cdnphoto.dantri.com.vn/m-g8nlg06kMKlBiZddeSddryC7c=/thumb_w/1020/2024/05/07/a2-3-1715069946395.jpg',

  'quang-nam': defaultBackground,
  'quang-ngai': defaultBackground,
  'binh-dinh': defaultBackground,
  'phu-yen': defaultBackground,
  'khanh-hoa': defaultBackground,
  'ninh-thuan': defaultBackground,
  'binh-thuan': defaultBackground,

  'kon-tum': defaultBackground,
  'gia-lai': defaultBackground,
  'dak-lak': defaultBackground,
  'dak-nong': defaultBackground,
  'lam-dong': defaultBackground,

  'binh-phuoc': defaultBackground,
  'tay-ninh': defaultBackground,
  'binh-duong': defaultBackground,
  'dong-nai': defaultBackground,
  'ba-ria-vung-tau': defaultBackground,
  'ho-chi-minh': defaultBackground,

  'long-an': defaultBackground,
  'tien-giang': defaultBackground,
  'ben-tre': defaultBackground,
  'tra-vinh': defaultBackground,
  'vinh-long': defaultBackground,
  'dong-thap': defaultBackground,
  'an-giang': defaultBackground,
  'kien-giang': defaultBackground,
  'can-tho': defaultBackground,
  'hau-giang': defaultBackground,
  'soc-trang': defaultBackground,
  'bac-lieu': defaultBackground,
  'ca-mau': defaultBackground,
};
