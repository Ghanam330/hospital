import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/screen_utils.dart';

class ProductsCard extends StatelessWidget {
  final bool isLeft;
  final bool isSelected;
  final bool noPadding;
  final Function addHandler;

  final String image;
  final String name;
  final String price;
  final String description;

  ProductsCard(
      {required this.image,
      required this.name,
      required this.price,
      required this.description,
      required this.isLeft,
      required this.isSelected,
      required this.addHandler,
      this.noPadding = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        addHandler();
      } ,
      child: Container(
        padding: EdgeInsets.all(
          getProportionateScreenWidth(5.0),
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(
            getProportionateScreenWidth(
              8,
            ),
          ),
          boxShadow: [
            isSelected
                ? BoxShadow(
                    color: kShadowColor,
                    offset: Offset(
                      getProportionateScreenWidth(24),
                      getProportionateScreenWidth(24),
                    ),
                    blurRadius: 80,
                  )
                : const BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kGreyShade5,
                    borderRadius: BorderRadius.circular(
                      getProportionateScreenWidth(8.0),
                    ),
                  ),
                  child: Image.network(
                    image,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenWidth(10),
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
                Text(
                 description,
                  maxLines: 2,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: getProportionateScreenWidth(12),
                    color: kTextColorAccent,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        price,
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        addHandler();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      fillColor: kPrimaryBlue,
                      constraints: BoxConstraints.tightFor(
                        width: getProportionateScreenWidth(
                          40,
                        ),
                        height: getProportionateScreenWidth(
                          40,
                        ),
                      ),
                      elevation: 0,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: getProportionateScreenWidth(
                    10,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
