import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/widgets/space.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String imageName;
  final String price;
  final String manufacturer;
  final void Function()? addToBasket;

  const ProductCard({
    required this.productName,
    required this.imageName,
    required this.price,
    required this.manufacturer,
    this.addToBasket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50.0,
      width: 300.0,
      child: Card(
        color: AppColorStyles.primary,
        elevation: 10,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(image: AssetImage('assets/images/$imageName'), fit: BoxFit.fill)),
              ),
              const Space.vertical(20.0),
              Text(
                '$manufacturer',
                style: const TextStyle(fontSize: 10.0),
              ),
              Text(
                productName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // const Space.vertical(5.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        color: AppColorStyles.background),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price: \$$price',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Container(
                            decoration: const BoxDecoration(color: AppColorStyles.blackText, shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: addToBasket,
                                icon: const Icon(
                                  Icons.add,
                                  color: AppColorStyles.primary,
                                )))
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
