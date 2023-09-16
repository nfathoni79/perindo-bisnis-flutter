import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perindo_bisnis_flutter/models/auction.dart';
import 'package:perindo_bisnis_flutter/models/bid.dart';
import 'package:perindo_bisnis_flutter/models/fish.dart';
import 'package:perindo_bisnis_flutter/models/fish_sell.dart';
import 'package:perindo_bisnis_flutter/models/store.dart';
import 'package:perindo_bisnis_flutter/models/user.dart';

class Repo {
  static List<Fish> fishList = [
    const Fish(id: 1, name: 'Tuna', price: 30000),
    const Fish(id: 2, name: 'Cakalang', price: 10000),
    const Fish(id: 3, name: 'Salem', price: 20000),
  ];

  static List<User> bidders = [
    const User(
      id: 1,
      username: 'agusbudi',
      email: 'ab@cd.ef',
      phone: '1234',
      fullName: 'Agus Budi',
    ),
    const User(
      id: 2,
      username: 'candradoni',
      email: 'ab@cd.ef',
      phone: '5678',
      fullName: 'Candra Doni',
    ),
    const User(
      id: 3,
      username: 'ekafikri',
      email: 'ab@cd.ef',
      phone: '9012',
      fullName: 'Eka Fikri',
    ),
  ];

  static List<Auction> randomAuctions = [
    randomAuction(),
    randomAuction(),
    randomAuction(),
    randomAuction(),
    randomAuction(),
    randomAuction(),
    randomAuction(),
    randomAuction(),
  ];

  static Auction randomAuction() {
    List<Store> stores = getStores();

    DateTime createdAt = DateTime.utc(2023, 7, Random().nextInt(9) + 1);

    return Auction(
      id: Random().nextInt(1000),
      store: stores[Random().nextInt(stores.length)],
      fishSells: [
        FishSell(id: fishList[2].id, fish: fishList[2], quantity: 3),
      ],
      bids: [
        Bid(
          id: Random().nextInt(1000),
          user: bidders[Random().nextInt(bidders.length)],
          value: Random().nextInt(1000) * 100,
          createdAt: DateTime.utc(2023, 7, Random().nextInt(9) + 1),
        ),
        Bid(
          id: Random().nextInt(1000),
          user: bidders[Random().nextInt(bidders.length)],
          value: Random().nextInt(1000) * 100,
          createdAt: DateTime.utc(2023, 7, Random().nextInt(9) + 1),
        ),
      ],
      createdAt: createdAt,
      updatedAt: createdAt,
      expiredAt: createdAt.add(const Duration(hours: 6)),
      status: Random().nextInt(2),
    );
  }

  static List<Auction> getAuctions() {
    List<Store> stores = getStores();

    return [
      Auction(
        id: 999,
        store: stores[0],
        fishSells: [
          FishSell(id: fishList[0].id, fish: fishList[0], quantity: 1),
          FishSell(id: fishList[1].id, fish: fishList[1], quantity: 2),
        ],
        bids: [
          Bid(
            id: Random().nextInt(1000),
            user: bidders[Random().nextInt(bidders.length)],
            value: Random().nextInt(1000) * 100,
            createdAt: DateTime.utc(2023, 7, Random().nextInt(9) + 1),
          ),
          Bid(
            id: Random().nextInt(1000),
            user: bidders[Random().nextInt(bidders.length)],
            value: Random().nextInt(1000) * 100,
            createdAt: DateTime.utc(2023, 7, Random().nextInt(9) + 1),
          ),
        ],
        createdAt: DateTime.utc(2023, 7, 17, 8, 5, 5),
        updatedAt: DateTime.utc(2023, 7, 17, 8, 5, 5),
        expiredAt: DateTime.utc(2023, 7, 18, 16, 5, 5),
      ),
      ...randomAuctions,
    ];
  }

  static List<Store> getStores() => [
        const Store(slug: 'PI0001', name: 'Perindo Coba'),
        const Store(slug: 'PI0002', name: 'Perindo Bacan'),
        const Store(slug: 'PI0003', name: 'Perindo Muara Baru'),
      ];
}
