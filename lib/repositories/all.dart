import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import 'address_repository.dart';
import 'mdb_repository.dart';
import 'redis_mdb_repository.dart';
import 'tiles_repository.dart';

final List<SingleChildWidget> allRepositories = [
  RepositoryProvider(create: AddressRepository.create),
  RepositoryProvider(create: TilesRepository.create),
  RepositoryProvider(
      // use in-memory mdb repository for web
      create:
          kIsWeb ? InMemoryMDBRepository.create : RedisMDBRepository.create),
];
