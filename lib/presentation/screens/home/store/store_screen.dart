import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_store/presentation/routing/route_names.dart';
import 'package:tennis_store/presentation/screens/home/store/widgets/product_card.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/styles/app_text_styles.dart';
import 'package:tennis_store/presentation/widgets/bottom_nav_bar.dart';
import 'package:tennis_store/presentation/widgets/newsletter_container.dart';
import 'package:tennis_store/presentation/widgets/space.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  void _addToBasket(Map<String, dynamic> product) async {
    if (_user != null) {
      CollectionReference basketCollection =
          FirebaseFirestore.instance.collection('baskets').doc(_user!.uid).collection('items');

      QuerySnapshot existingProducts =
          await basketCollection.where('productName', isEqualTo: product['productName']).get();

      if (existingProducts.docs.isNotEmpty) {
        // Product already in basket, update quantity
        DocumentSnapshot existingProduct = existingProducts.docs.first;
        int currentQuantity = existingProduct['quantity'];
        await basketCollection.doc(existingProduct.id).update({'quantity': currentQuantity + 1});
      } else {
        // Product not in basket, add new entry
        product['quantity'] = 1;
        await basketCollection.add(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');

    return Scaffold(
      backgroundColor: AppColorStyles.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Welcome',
                              style: AppTextStyles.normaltext(),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              NewsletterContainer(
                                path: 'https://i.pinimg.com/564x/fd/83/b7/fd83b7a2ece4f1676e27e535b7e98072.jpg',
                                title: '-15% Promo Code \n For You',
                                buttonText: '15% OFF | CODE: MINUS15',
                                onPressed: () {},
                              ),
                              NewsletterContainer(
                                path: 'https://i.pinimg.com/564x/00/0c/01/000c015e1bafc6b680bb15dcda345324.jpg',
                                title: 'New Collection',
                                buttonText: 'SEE NOW',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const Space.vertical(25.0),
                        Row(
                          children: [
                            Text(
                              'Products',
                              style: AppTextStyles.greenText().copyWith(color: AppColorStyles.blackText),
                            ),
                          ],
                        ),
                        const Space.vertical(10.0),
                        SizedBox(
                          height: 500.0, // Adjust the height as needed
                          child: StreamBuilder<QuerySnapshot>(
                            stream: productsCollection.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return const Center(child: Text('Something went wrong'));
                              }

                              final products = snapshot.data?.docs ?? [];

                              return ListView.builder(
                                itemCount: products.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final productData = product.data() as Map<String, dynamic>;

                                  return ProductCard(
                                    productName: productData['product_name'],
                                    imageName: productData['image_name'],
                                    price: productData['price'],
                                    manufacturer: productData['manufacturer'],
                                    addToBasket: () {
                                      _addToBasket({
                                        'productName': productData['product_name'],
                                        'imageName': productData['image_name'],
                                        'price': productData['price'],
                                        'manufacturer': productData['manufacturer'],
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
