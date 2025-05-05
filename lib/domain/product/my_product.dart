import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';

import 'my_product.dart';

class MyProduct {
  static List<ProductModel> categoryList = [
    ProductModel(
      title: "Shoes",
      image: MyImages.shoes,
    ),
    ProductModel(
      title: "Watch",
      image: MyImages.watch,
    ),
    ProductModel(
      title: "Mens Fashion",
      image: MyImages.mensFashion,
    ),
    ProductModel(
      title: "Headphone",
      image: MyImages.headphone,
    ),
    ProductModel(
      title: "Electronics",
      image: MyImages.electronics,
    ),
    ProductModel(
      title: "Bag",
      image: MyImages.bag,
    ),
  ];

  static List<ProductModel> bannerList = [
    ProductModel(
      title: "Banner",
      image: MyImages.banner_2,
    ),
    ProductModel(
      title: "Banner",
      image: MyImages.banner_1,
    ),
    ProductModel(
      title: "Banner",
      image: MyImages.banner_5,
    ),
    ProductModel(
      title: "Banner",
      image: MyImages.banner_3,
    ),
  ];

  static List<ProductModel> companyLogoList = List.generate(ProductListDummy.watchList.length, (index) {
    return ProductModel(title: ProductListDummy.watchList[index].title, image: "assets/company_logo/Fictional company logo (${index + 1}).png", price: ProductListDummy.watchList[index].price, description: MyStrings.watchDec, brand: ProductListDummy.watchList[index].brand, size: ProductListDummy.watchList[index].size);
  });

  static List<ProductModel> watchList = List.generate(10, (index) {
    return ProductModel(title: ProductListDummy.watchList[index].title, image: "assets/product/watch/watch (${index + 1}).png", price: ProductListDummy.watchList[index].price, description: MyStrings.watchDec, brand: ProductListDummy.watchList[index].brand, size: ProductListDummy.watchList[index].size);
  });

  static List<ProductModel> bagList = List.generate(10, (index) {
    return ProductModel(title: "Bag", image: "assets/product/bag/bag (${index + 1}).png", description: MyStrings.bagDec);
  });

  static List<ProductModel> headPhoneList = List.generate(10, (index) {
    return ProductModel(title: "Headphone", image: "assets/product/head_phone/headphone (${index + 1}).png", description: MyStrings.headphoneDec);
  });

  static List<ProductModel> electronicsList = List.generate(10, (index) {
    return ProductModel(title: "Electronics", image: "assets/product/electronics/electronics (${index + 1}).png", description: MyStrings.smartPhoneDec);
  });

  static List<ProductModel> mensFashionList = List.generate(10, (index) {
    return ProductModel(title: "Fashion", image: "assets/product/mens_fashion/Mens collections (${index + 1}).png", description: MyStrings.fashionDec);
  });

  static List<ProductModel> shoeList = List.generate(10, (index) {
    return ProductModel(title: "Shoes", image: "assets/product/shoes/shoe (${index + 1}).png", description: MyStrings.shoesDec);
  });

  static List<ProductModel> detailsPageProductList = List.generate(3, (index) {
    return ProductModel(title: "Fashion", image: "assets/product/shoes/shoe (${4 - index}).png", description: MyStrings.shoesDec);
  });

  static List<ProductModel> mixProductList = [
    ProductModel(title: "Urban Voyager Backpack", image: "assets/product/bag/bag (${1}).png", price: 0.0, size: "Medium, Black", status: MyStrings.pending, description: MyStrings.bagDec, brand: "UrbanCarry"),
    /* ProductModel(title: "Moto Edge 50 pro", image: "assets/product/electronics/electronics (${3}).png", price: "1000", size: "8/256 gb", status: MyStrings.delivered, description: MyStrings.smartPhoneDec, brand: "Motorolla"),
    ProductModel(title: "LuxeLayer Jacket", image: "assets/product/mens_fashion/Mens collections (${10}).png", price: "395", status: MyStrings.dispatched, description: MyStrings.fashionDec, brand: "ClassicEdge"),
    ProductModel(title: "StridePro Running Shoes", image: "assets/product/shoes/shoe (9).png", price: "499", size: "Mixon 12", status: MyStrings.delivered, description: MyStrings.shoesDec, brand: "StrideMaster"),
    ProductModel(title: "Elegance Tote", image: "assets/product/bag/bag (${7}).png", size: "14 inches (W)", price: "485", status: MyStrings.dispatched, description: MyStrings.bagDec, brand: "VoyageGear"),
    ProductModel(title: "High Quality Headphone", image: "assets/product/head_phone/headphone (${6}).png", size: "EchoWave X1", price: "764", status: MyStrings.delivered, description: MyStrings.headphoneDec, brand: "SoundWave"),
    ProductModel(title: "StrideFlex Sneakers", image: "assets/product/shoes/shoe (10).png", size: " Xtreme Grip 2024", status: MyStrings.pending, description: MyStrings.shoesDec, brand: "RunFlex"),
    ProductModel(title: "One plus Nord CE", image: "assets/product/electronics/electronics (${2}).png", price: "899", size: "4/64 gb", status: MyStrings.delivered, description: MyStrings.smartPhoneDec, brand: "One Plus"),
    ProductModel(title: "SonicPulse Wireless Headphones", image: "assets/product/head_phone/headphone (${2}).png", size: "PureSound Pro 500", price: "499", status: MyStrings.pending, description: MyStrings.headphoneDec, brand: "EchoTune"),
    ProductModel(title: "ChronoLux Watch", image: "assets/product/watch/watch (${2}).png", size: "Pure gold", price: "1200", status: MyStrings.delivered, description: MyStrings.watchDec, brand: "TimelessTech"),
 */
  ];

  static List<ProductModel> reverseProductList = mixProductList.reversed.toList();
}

class ProductModel {
  String title;
  String image;
  int quantity;
  int productID;
  double price;
  String size;
  String? status = MyStrings.pending;
  String description;
  String brand;
  double onlinePriceBeforeDiscount;
  String sellingCurrencyLogo;
  ProductModel({required this.title, required this.image, this.quantity = 1, this.price = 0.0, this.size = "L, Black", this.status, this.description = "", this.brand = "Samsung", this.onlinePriceBeforeDiscount = 0.0, this.sellingCurrencyLogo = "", this.productID = 0});
}

class ProductListDummy {
  static List<ProductModel> watchList = [
    ProductModel(title: "EchoWave Headphones", image: "assets/product/watch/watch (1).png", size: "Over-ear", price: 0.0, status: MyStrings.delivered, description: MyStrings.headphoneDec, brand: "SoundWave"),
    /*ProductModel(title: "StrideFlex Sneakers", image: "assets/product/watch/watch (2).png", size: "Men's 10", price: "100", status: MyStrings.delivered, description: MyStrings.watchDec, brand: "RunFlex"),
    ProductModel(title: "LuxeLayer Jacket", image: "assets/product/watch/watch (3).png", size: "Medium", price: "250", status: MyStrings.delivered, description: MyStrings.fashionDec, brand: "ClassicEdge"),
    ProductModel(title: "TechNova Smartphone", image: "assets/product/watch/watch (4).png", size: "6.5 inch screen", price: "800", status: MyStrings.delivered, description: MyStrings.watchDec, brand: "PrimeEdge"),
    ProductModel(title: "Elegance Tote", image: "assets/product/watch/watch (5).png", size: "Large", price: "80", status: MyStrings.delivered, description: MyStrings.bagDec, brand: "UrbanCarry"),
    ProductModel(title: "ChronoMaster Elite", image: "assets/product/watch/watch (6).png", size: "Stainless Steel", price: "1500", status: MyStrings.delivered, description: MyStrings.watchDec, brand: "EliteChrono"),
    ProductModel(title: "VividView 4K Smart TV", image: "assets/product/watch/watch (7).png", size: "55 inch", price: "1200", status: MyStrings.delivered, description: MyStrings.watchDec, brand: "VisionTech"),
    ProductModel(title: "Urban Voyager Backpack", image: "assets/product/watch/watch (8).png", size: "Medium", price: "90", status: MyStrings.delivered, description: MyStrings.bagDec, brand: "VoyageGear"),
    ProductModel(title: "PureSound Pro 500", image: "assets/product/watch/watch (9).png", size: "Over-ear", price: "200", status: MyStrings.delivered, description: MyStrings.headphoneDec, brand: "EchoTune"),
    ProductModel(title: "ApexTime Smartwatch", image: "assets/product/watch/watch (10).png", size: "Leather Strap", price: "250", status: MyStrings.delivered, description: MyStrings.watchDec, brand: "TimelessTech"),
  */
  ];
}
