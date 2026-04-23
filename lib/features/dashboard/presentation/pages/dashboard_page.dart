import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Ambil data produk segera setelah halaman terbuka [cite: 1530]
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final productProv = context.watch<ProductProvider>();

    return Scaffold(
      app_bar: AppBar(
        title: const Text('Bag Store Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: _buildBody(productProv),
    );
  }

  Widget _buildBody(ProductProvider provider) {
    return switch (provider.status) {
      ProductStatus.loading || ProductStatus.initial => 
        const Center(child: CircularProgressIndicator()),
      ProductStatus.error => 
        Center(child: Text(provider.error ?? 'Error')),
      ProductStatus.loaded => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: provider.products.length,
          itemBuilder: (context, i) {
            final p = provider.products[i];
            return Card(
              child: Column(
                children: [
                  Expanded(child: Image.network(p.imageUrl, fit: BoxFit.cover)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(p.name, fontWeight: FontWeight.bold),
                  ),
                  Text('Rp ${p.price.toStringAsFixed(0)}'),
                ],
              ),
            );
          },
        ),
    };
  }
}