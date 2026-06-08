import 'package:latlong2/latlong.dart';

class Archipelago {
  final String id;
  final String name;
  final LatLng location;

  const Archipelago({
    required this.id,
    required this.name,
    required this.location,
  });
}

class Island {
  final String id;
  final String region;
  final String regionEn;
  final String nameVi;
  final String nameEn;
  final LatLng location;
  final bool occupied;
  final String claimants;
  final String desc;
  final bool isMain;

  const Island({
    required this.id,
    required this.region,
    required this.regionEn,
    required this.nameVi,
    required this.nameEn,
    required this.location,
    required this.occupied,
    required this.claimants,
    required this.desc,
    this.isMain = false,
  });
}

const List<Archipelago> archipelagos = [
  Archipelago(
    id: "label-hs",
    name: "QUẦN ĐẢO HOÀNG SA (VN)",
    location: LatLng(16.5000, 111.6000),
  ),
  Archipelago(
    id: "label-ts",
    name: "QUẦN ĐẢO TRƯỜNG SA (VN)",
    location: LatLng(10.0000, 114.0000),
  ),
];

const List<Island> vnIslands = [
  Island(
    id: "hs-phu-lam",
    region: "Hoàng Sa",
    regionEn: "Paracels",
    nameVi: "Đảo Phú Lâm",
    nameEn: "Woody Island",
    location: LatLng(16.8333, 112.3333),
    occupied: true,
    claimants: "Việt Nam, Trung Quốc (chiếm đóng), Đài Loan",
    desc:
        "Đảo lớn nhất quần đảo Hoàng Sa. Bị Trung Quốc chiếm đóng trái phép và quân sự hóa mạnh mẽ.",
    isMain: true,
  ),
  Island(
    id: "hs-tri-ton",
    region: "Hoàng Sa",
    regionEn: "Paracels",
    nameVi: "Đảo Tri Tôn",
    nameEn: "Triton Island",
    location: LatLng(15.7833, 111.2000),
    occupied: true,
    claimants: "Việt Nam, Trung Quốc (chiếm đóng), Đài Loan",
    desc: "Đảo nằm ở cực tây nam của quần đảo Hoàng Sa.",
  ),
  Island(
    id: "hs-hoang-sa",
    region: "Hoàng Sa",
    regionEn: "Paracels",
    nameVi: "Đảo Hoàng Sa",
    nameEn: "Pattle Island",
    location: LatLng(16.5333, 111.6000),
    occupied: true,
    claimants: "Việt Nam, Trung Quốc (chiếm đóng), Đài Loan",
    desc:
        "Nơi từng đặt bia chủ quyền và trạm khí tượng của Việt Nam trước khi bị chiếm đóng.",
    isMain: true,
  ),

  Island(
    id: "ts-truong-sa-lon",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đảo Trường Sa Lớn",
    nameEn: "Spratly Island",
    location: LatLng(8.644, 111.919),
    occupied: false,
    claimants: "Việt Nam (kiểm soát), Trung Quốc, Đài Loan",
    desc: "Trung tâm hành chính huyện đảo Trường Sa, tỉnh Khánh Hòa.",
    isMain: true,
  ),
  Island(
    id: "ts-nam-yet",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đảo Nam Yết",
    nameEn: "Namyit Island",
    location: LatLng(10.183, 114.366),
    occupied: false,
    claimants: "Việt Nam (kiểm soát), Trung Quốc, Đài Loan, Philippines",
    desc: "Đảo san hô có hình dáng dài, nằm trong cụm Nam Yết.",
    isMain: true,
  ),
  Island(
    id: "ts-sinh-ton",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đảo Sinh Tồn",
    nameEn: "Sin Cowe Island",
    location: LatLng(9.883, 114.316),
    occupied: false,
    claimants: "Việt Nam (kiểm soát), Trung Quốc, Đài Loan, Philippines",
    desc: "Đảo có ý nghĩa chiến lược, nằm gần trung tâm quần đảo Trường Sa.",
  ),
  Island(
    id: "ts-son-ca",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đảo Sơn Ca",
    nameEn: "Sand Cay",
    location: LatLng(10.383, 114.466),
    occupied: false,
    claimants: "Việt Nam (kiểm soát)...",
    desc: "Thuộc cụm Nam Yết, có nhiều cây xanh và chim chóc.",
  ),
  Island(
    id: "ts-phan-vinh",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đảo Phan Vinh",
    nameEn: "Pearson Reef",
    location: LatLng(8.966, 113.683),
    occupied: false,
    claimants: "Việt Nam (kiểm soát)...",
    desc:
        "Đảo được đặt theo tên của Anh hùng lực lượng vũ trang nhân dân Nguyễn Phan Vinh.",
  ),
  Island(
    id: "ts-song-tu-tay",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đảo Song Tử Tây",
    nameEn: "Southwest Cay",
    location: LatLng(11.433, 114.333),
    occupied: false,
    claimants: "Việt Nam (kiểm soát)...",
    desc: "Đảo lớn thứ hai do Việt Nam kiểm soát tại Trường Sa.",
  ),
  Island(
    id: "ts-chu-thap",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đá Chữ Thập",
    nameEn: "Fiery Cross Reef",
    location: LatLng(9.550, 112.883),
    occupied: true,
    claimants: "Việt Nam, Trung Quốc (chiếm đóng)...",
    desc: "Bị Trung Quốc bồi đắp trái phép thành đảo nhân tạo khổng lồ.",
    isMain: true,
  ),
  Island(
    id: "ts-vanh-khan",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đá Vành Khăn",
    nameEn: "Mischief Reef",
    location: LatLng(9.916, 115.533),
    occupied: true,
    claimants: "Việt Nam, Trung Quốc (chiếm đóng)...",
    desc: "Rạn san hô vòng bị Trung Quốc chiếm đóng trái phép và quân sự hóa.",
  ),
  Island(
    id: "ts-xu-bi",
    region: "Trường Sa",
    regionEn: "Spratlys",
    nameVi: "Đá Xu Bi",
    nameEn: "Subi Reef",
    location: LatLng(10.916, 114.083),
    occupied: true,
    claimants: "Việt Nam, Trung Quốc (chiếm đóng)...",
    desc: "Bị biến thành tiền đồn quân sự lớn của Trung Quốc trên Biển Đông.",
  ),
];
