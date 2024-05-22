import 'package:flutter/material.dart';

class Space extends SizedBox {
  const Space._({
    super.key,
    super.width,
    super.height,
  });

  const Space.horizontal(
    double value, {
    Key? key,
  }) : this._(
          key: key,
          width: value,
        );

  const Space.vertical(
    double value, {
    Key? key,
  }) : this._(
          key: key,
          height: value,
        );
}
