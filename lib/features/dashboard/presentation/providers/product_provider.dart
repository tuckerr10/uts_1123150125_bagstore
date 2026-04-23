import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  ProductStatus _status = ProductStatus.initial;
  List<ProductModel> _products = [];
  String? _error;

  ProductStatus get status => _status;
  List<ProductModel> get products => _products;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      // Interceptor otomatis menyisipkan Bearer Token [cite: 122, 363]
      final response = await DioClient.instance.get(ApiConstants.products);
      
      final List<dynamic> data = response.data['data'];
      _products = data.map((e) => ProductModel.fromJson(e)).toList();
      
      _status = ProductStatus.loaded;
    } catch (e) {
      _error = 'Gagal memuat koleksi tas';
      _status = ProductStatus.error;
    }
    notifyListeners();
  }
}