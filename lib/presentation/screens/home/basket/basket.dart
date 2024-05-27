import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tennis_store/presentation/screens/home/basket/widgets/basket_product.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/styles/app_text_styles.dart';

class Basket extends StatefulWidget {
  const Basket({super.key});

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  User? _user;
  double total = 0.0;
  List<Map<String, dynamic>> products = [];

  Future<void> calculateTotal() async {
    double newTotal = 0.0;
    // Get reference to Firestore collection
    CollectionReference itemsRef = FirebaseFirestore.instance.collection('baskets').doc(_user!.uid).collection('items');

    // Fetch all documents in the 'items' collection
    QuerySnapshot querySnapshot = await itemsRef.get();

    products = querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return {
        'imageName': data['imageName'],
        'productName': data['productName'],
        'price': double.parse(data['price'].toString()),
        'quantity': data['quantity'],
      };
    }).toList();

    // Iterate over each document and sum up the 'price' * 'quantity'
    querySnapshot.docs.forEach((doc) {
      double price = double.parse(doc['price']);
      int quantity = doc['quantity'];
      print('cena: $price quantity: $quantity');

      newTotal += price * quantity;
    });

    setState(() {
      total = double.parse(newTotal.toStringAsFixed(2));
    });
  }

  Future<void> sendOrderEmail() async {
    String orderDetails = products.map((product) {
      return '${product['productName']} - \$${product['price']} x ${product['quantity']}';
    }).join('\n');

    HttpsCallable callable = _functions.httpsCallable('sendOrderEmail');
    try {
      await callable.call({
        'email': _user!.email,
        'userName': _user!.displayName ?? _user!.email!.split('@')[0],
        'orderDetails': orderDetails,
        'total': total.toStringAsFixed(2),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order email sent successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send order email: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _user = user;
        });
        calculateTotal();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorStyles.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            'Please log in to view your basket.',
                            style: AppTextStyles.normaltext(),
                          )),
                        ],
                      ),
                    );
                  }

                  User? user = snapshot.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Basket',
                                    style: AppTextStyles.normaltext(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.67,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('baskets')
                                        .doc(user!.uid)
                                        .collection('items')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                        return const Center(child: Text('Your basket is empty.'));
                                      }

                                      var products = snapshot.data!.docs.map((doc) {
                                        var data = doc.data() as Map<String, dynamic>;
                                        print('Produkty ${data}');
                                        return {
                                          'imageUrl': 'assets/images/${data['imageName']}',
                                          'productName': data['productName'] ?? 'Unknown Product',
                                          'price': data['price'] is double
                                              ? data['price']
                                              : double.tryParse(data['price'].toString()) ?? 0.0,
                                          'quantity': data['quantity'] ?? 1,
                                        };
                                      }).toList();

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          var product = products[index];
                                          return BasketProduct(
                                            imageUrl: product['imageUrl'],
                                            productName: product['productName'],
                                            price: product['price'],
                                            quantity: product['quantity'],
                                            onIncrease: () async {
                                              // Handle increase quantity
                                              var newQuantity = product['quantity'] + 1;
                                              await FirebaseFirestore.instance
                                                  .collection('baskets')
                                                  .doc(user.uid)
                                                  .collection('items')
                                                  .doc(snapshot.data!.docs[index].id)
                                                  .update({'quantity': newQuantity});
                                              calculateTotal();
                                            },
                                            onDecrease: () async {
                                              // Handle decrease quantity
                                              var newQuantity = product['quantity'] > 1 ? product['quantity'] - 1 : 1;
                                              await FirebaseFirestore.instance
                                                  .collection('baskets')
                                                  .doc(user.uid)
                                                  .collection('items')
                                                  .doc(snapshot.data!.docs[index].id)
                                                  .update({'quantity': newQuantity});
                                              calculateTotal();
                                            },
                                            onDelete: () async {
                                              // Handle delete product
                                              await FirebaseFirestore.instance
                                                  .collection('baskets')
                                                  .doc(user.uid)
                                                  .collection('items')
                                                  .doc(snapshot.data!.docs[index].id)
                                                  .delete();
                                              calculateTotal();
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            (snapshot.hasData)
                                ? Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total: \$${total.toStringAsFixed(2)}',
                                          style: AppTextStyles.normaltext(),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.resolveWith(
                                            (states) => AppColorStyles.background,
                                          )),
                                          onPressed: () {
                                            sendOrderEmail();
                                          },
                                          child: Text(
                                            'BUY',
                                            style: AppTextStyles.buttonText(true).copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ],
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
