import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/products_viewmodel.dart';
class Proda extends StatefulWidget {
  Proda({
    super.key,
  });

  @override
  State<Proda> createState() => _ProdaState();
}

class _ProdaState extends State<Proda> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductsViewmodel>(
      context,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Products Catalog",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: provider.loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                provider.searchProduct(value);
              },
              decoration: InputDecoration(
                hintText: "Search products by name or code...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    provider.searchProduct("");
                    setState(() {});
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: provider.filteredProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "No products found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: EdgeInsets.all(14),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: provider.filteredProducts.length,
              itemBuilder: (context, index) {
                final snap = provider.filteredProducts[index];
                var data = snap.data();

                String image = data['pimage']?.toString() ?? "";
                String name =
                    data['pname']?.toString() ?? "Product";
                String price =
                    data['pselling price']?.toString() ??
                        data['price']?.toString() ??
                        '0';
                int stock = int.tryParse(
                  data['pquantity']?.toString() ?? '0',
                ) ??
                    0;
                bool isLowStock = stock <= 5;
                bool isOutOfStock = stock == 0;

                return Card(
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey.shade50,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              image.isNotEmpty
                                  ? Image.network(
                                image,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {
                                  return Center(
                                    child: Icon(
                                      Icons.inventory_2_outlined,
                                      size: 40,
                                      color: Colors.grey.shade400,
                                    ),
                                  );
                                },
                              )
                                  : Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              if (isOutOfStock)
                                Container(
                                  color: Colors.black45,
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "Out of Stock",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "₹$price",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory,
                                  size: 14,
                                  color: isOutOfStock
                                      ? Colors.red
                                      : isLowStock
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Stock: $stock",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isOutOfStock
                                        ? Colors.red
                                        : isLowStock
                                        ? Colors.orange.shade800
                                        : Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}