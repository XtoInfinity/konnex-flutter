import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'instruction.dart';

part 'instruction_set.g.dart';

@JsonSerializable(explicitToJson: true)
class NavigationObject {
  String title;
  @JsonKey(defaultValue: [])
  List<InstructionSet> steps;

  NavigationObject({this.title, this.steps});

  factory NavigationObject.fromJson(Map<String, dynamic> json) =>
      _$NavigationObjectFromJson(json);
  Map<String, dynamic> toJson() => _$NavigationObjectToJson(this);
}

class InstructionSet {
  /// Page Name
  final String uniqueRouteName;

  @JsonKey(defaultValue: false)
  final bool canSkip;

  /// Duation of time this instruction is to be shown over the screen
  @JsonKey(defaultValue: [])
  final List<Instruction> instructions;

  InstructionSet({this.uniqueRouteName, this.instructions, this.canSkip});

  factory InstructionSet.fromJson(Map<String, dynamic> json) {
    return InstructionSet(
      uniqueRouteName: json['uniqueRouteName'] as String,
      canSkip: json['canSkip'] as bool ?? false,
      instructions: (json['instructions'] as List)?.map((e) {
            if (e == null) return null;
            final data = e as Map<String, dynamic>;
            if (data.containsKey('id')) {
              return InstructionById.fromJson(e as Map<String, dynamic>);
            } else if (data.containsKey('x')) {
              return InstructionByCoordinate.fromJson(
                  e as Map<String, dynamic>);
            } else {
              return null;
            }
          })?.toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uniqueRouteName': this.uniqueRouteName,
        'canSkip': this.canSkip,
        'instructions': this.instructions?.map((e) => e?.toJson())?.toList(),
      };
}

Future<void> pushNavigationsInFirestore() async {
  final String appId = 'pa5309JvtnfFLqwNCJr5';
  final ref =
      FirebaseFirestore.instance.collection('application/$appId/navigations/');
  await ref.doc('10AddItemToCart').set(addToCart);
  await ref.doc('20RemoveItemFromCart').set(removeItemFromCart);
  await ref.doc('30AddAddress').set(addAnAddress);
  await ref.doc('40PlaceOrder').set(placeTheOrder);
}

var addToCart = {
  'title': 'How to Add item to a cart?',
  'steps': [
    {
      'uniqueRouteName': '/CategoryScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': '0',
          'description': 'Select a category.',
          'waitInMils': 2000,
        }
      ],
    },
    {
      'uniqueRouteName': '/ProductsScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': '0AddToCart',
          'description': 'Add items you want to buy.',
          'waitInMils': 1500,
        },
        {
          'id': 'cartButton',
          'description': 'Tap Here to check you cart.',
          'waitInMils': 1500,
        }
      ],
    },
  ],
};

var removeItemFromCart = {
  'title': 'How to remove an item from the cart?',
  'steps': [
    {
      'uniqueRouteName': '/CategoryScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': 'cartButton',
          'description': 'Tap Here to open you cart.',
          'waitInMils': 1500,
        }
      ],
    },
    {
      'uniqueRouteName': '/ProductsScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': 'cartButton',
          'description': 'Tap Here to open you cart.',
          'waitInMils': 1500,
        }
      ],
    },
    {
      'uniqueRouteName': '/CartScreen',
      'canSkip': false,
      'instructions': [
        {
          'id': '0RemoveButton',
          'description': 'Tap Here to remove the item from your cart.',
          'waitInMils': 1500,
        }
      ],
    },
  ],
};

var addAnAddress = {
  'title': 'How to add a new address for the delivery ?',
  'steps': [
    {
      'uniqueRouteName': '/CategoryScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': 'cartButton',
          'description': 'Tap Here to open you cart.',
          'waitInMils': 1500,
        }
      ],
    },
    {
      'uniqueRouteName': '/ProductsScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': 'cartButton',
          'description': 'Tap Here to open you cart.',
          'waitInMils': 1500,
        }
      ],
    },
    {
      'uniqueRouteName': '/CartScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': 'addDeliveryButton',
          'description': 'Tap Here to see all delivery addess.',
          'waitInMils': 1500,
        }
      ],
    },
    {
      'uniqueRouteName': '/AddressScreen',
      'canSkip': false,
      'instructions': [
        {
          'id': 'addAdressButton',
          'description': 'Tap Here to Add new delivery addess.',
          'waitInMils': 1500,
        }
      ],
    },
    {
      'uniqueRouteName': '/AddAddressScreen',
      'canSkip': false,
      'instructions': [
        {
          'id': 'nameEditText',
          'description': 'Tap Here to Enter a name.',
          'waitInMils': 1500,
        },
        {
          'id': 'addressEditText',
          'description': 'Tap Here to Enter the address.',
          'waitInMils': 1500,
        },
        {
          'id': 'cityEditText',
          'description': 'Tap Here to Enter the city.',
          'waitInMils': 1500,
        },
        {
          'id': 'stateEditText',
          'description': 'Tap Here to Enter the state.',
          'waitInMils': 1500,
        },
        {
          'id': 'pinCodeEditText',
          'description': 'Tap Here to Enter the Pin Code.',
          'waitInMils': 1500,
        },
        {
          'id': 'addAddressButton',
          'description': 'Save the address.',
          'waitInMils': 1500,
        }
      ],
    },
  ],
};

var placeTheOrder = {
  'title': 'How to place an order?',
  'steps': [
    {
      'uniqueRouteName': '/CategoryScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': '0',
          'description': 'Select a category.',
          'waitInMils': 2000,
        }
      ],
    },
    {
      'uniqueRouteName': '/ProductsScreen',
      'canSkip': true,
      'instructions': [
        {
          'id': '0AddToCart',
          'description': 'Add items you want to buy.',
          'waitInMils': 1500,
        },
        {
          'id': 'cartButton',
          'description': 'Tap Here to check you cart.',
          'waitInMils': 1500,
        }
      ],
    },
    {
      'uniqueRouteName': '/CartScreen',
      'canSkip': false,
      'instructions': [
        {
          'id': 'deliverAddressContainer',
          'description': 'Choose a delivery addess.',
          'waitInMils': 2500,
        },
        {
          'id': 'placeOrderButton',
          'description': 'Tap here to place your order.',
          'waitInMils': 4500,
        }
      ],
    },
  ],
};
