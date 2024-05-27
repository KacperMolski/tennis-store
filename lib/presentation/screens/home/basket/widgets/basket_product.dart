import 'package:flutter/material.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/styles/app_text_styles.dart';
import 'package:tennis_store/presentation/widgets/space.dart';

class BasketProduct extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const BasketProduct({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    print('$imageUrl');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 100.0,
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Space.horizontal(10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: AppTextStyles.normaltext().copyWith(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
                Text(
                  '\$$price',
                  style: AppTextStyles.normaltext().copyWith(fontSize: 20),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ],
            ),
          ),
          const Space.horizontal(15),
          Row(
            children: [
              Container(
                width: 30,
                decoration: const BoxDecoration(
                  color: AppColorStyles.blackText,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 14,
                  onPressed: onDecrease,
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              const Space.horizontal(5),
              Text('$quantity'),
              const Space.horizontal(5),
              Container(
                width: 30,
                decoration: const BoxDecoration(
                  color: AppColorStyles.background,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 14,
                  onPressed: onIncrease,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              const Space.horizontal(5),
              Container(
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 230, 82, 65),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 14,
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
