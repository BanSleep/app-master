// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class CartMainData extends DataClass implements Insertable<CartMainData> {
  final int id;
  final String title;
  final int productId;
  final int catalogId;
  final int count;
  final int bonus;
  final int price;
  final int regularPrice;
  final String image;
  final List<String>? badges;
  final List<Version>? versions;
  final String? versionTitle;
  CartMainData(
      {required this.id,
      required this.title,
      required this.productId,
      required this.catalogId,
      required this.count,
      required this.bonus,
      required this.price,
      required this.regularPrice,
      required this.image,
      this.badges,
      this.versions,
      this.versionTitle});
  factory CartMainData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CartMainData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      productId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id'])!,
      catalogId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}catalog_id'])!,
      count: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}count'])!,
      bonus: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bonus'])!,
      price: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price'])!,
      regularPrice: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}regular_price'])!,
      image: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image'])!,
      badges: $CartMainTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}badges'])),
      versions: $CartMainTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}versions'])),
      versionTitle: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}version_title']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['product_id'] = Variable<int>(productId);
    map['catalog_id'] = Variable<int>(catalogId);
    map['count'] = Variable<int>(count);
    map['bonus'] = Variable<int>(bonus);
    map['price'] = Variable<int>(price);
    map['regular_price'] = Variable<int>(regularPrice);
    map['image'] = Variable<String>(image);
    if (!nullToAbsent || badges != null) {
      final converter = $CartMainTable.$converter0;
      map['badges'] = Variable<String?>(converter.mapToSql(badges));
    }
    if (!nullToAbsent || versions != null) {
      final converter = $CartMainTable.$converter1;
      map['versions'] = Variable<String?>(converter.mapToSql(versions));
    }
    if (!nullToAbsent || versionTitle != null) {
      map['version_title'] = Variable<String?>(versionTitle);
    }
    return map;
  }

  CartMainCompanion toCompanion(bool nullToAbsent) {
    return CartMainCompanion(
      id: Value(id),
      title: Value(title),
      productId: Value(productId),
      catalogId: Value(catalogId),
      count: Value(count),
      bonus: Value(bonus),
      price: Value(price),
      regularPrice: Value(regularPrice),
      image: Value(image),
      badges:
          badges == null && nullToAbsent ? const Value.absent() : Value(badges),
      versions: versions == null && nullToAbsent
          ? const Value.absent()
          : Value(versions),
      versionTitle: versionTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(versionTitle),
    );
  }

  factory CartMainData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CartMainData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      productId: serializer.fromJson<int>(json['productId']),
      catalogId: serializer.fromJson<int>(json['catalogId']),
      count: serializer.fromJson<int>(json['count']),
      bonus: serializer.fromJson<int>(json['bonus']),
      price: serializer.fromJson<int>(json['price']),
      regularPrice: serializer.fromJson<int>(json['regularPrice']),
      image: serializer.fromJson<String>(json['image']),
      badges: serializer.fromJson<List<String>?>(json['badges']),
      versions: serializer.fromJson<List<Version>?>(json['versions']),
      versionTitle: serializer.fromJson<String?>(json['versionTitle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'productId': serializer.toJson<int>(productId),
      'catalogId': serializer.toJson<int>(catalogId),
      'count': serializer.toJson<int>(count),
      'bonus': serializer.toJson<int>(bonus),
      'price': serializer.toJson<int>(price),
      'regularPrice': serializer.toJson<int>(regularPrice),
      'image': serializer.toJson<String>(image),
      'badges': serializer.toJson<List<String>?>(badges),
      'versions': serializer.toJson<List<Version>?>(versions),
      'versionTitle': serializer.toJson<String?>(versionTitle),
    };
  }

  CartMainData copyWith(
          {int? id,
          String? title,
          int? productId,
          int? catalogId,
          int? count,
          int? bonus,
          int? price,
          int? regularPrice,
          String? image,
          List<String>? badges,
          List<Version>? versions,
          String? versionTitle}) =>
      CartMainData(
        id: id ?? this.id,
        title: title ?? this.title,
        productId: productId ?? this.productId,
        catalogId: catalogId ?? this.catalogId,
        count: count ?? this.count,
        bonus: bonus ?? this.bonus,
        price: price ?? this.price,
        regularPrice: regularPrice ?? this.regularPrice,
        image: image ?? this.image,
        badges: badges ?? this.badges,
        versions: versions ?? this.versions,
        versionTitle: versionTitle ?? this.versionTitle,
      );
  @override
  String toString() {
    return (StringBuffer('CartMainData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('productId: $productId, ')
          ..write('catalogId: $catalogId, ')
          ..write('count: $count, ')
          ..write('bonus: $bonus, ')
          ..write('price: $price, ')
          ..write('regularPrice: $regularPrice, ')
          ..write('image: $image, ')
          ..write('badges: $badges, ')
          ..write('versions: $versions, ')
          ..write('versionTitle: $versionTitle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, productId, catalogId, count, bonus,
      price, regularPrice, image, badges, versions, versionTitle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartMainData &&
          other.id == this.id &&
          other.title == this.title &&
          other.productId == this.productId &&
          other.catalogId == this.catalogId &&
          other.count == this.count &&
          other.bonus == this.bonus &&
          other.price == this.price &&
          other.regularPrice == this.regularPrice &&
          other.image == this.image &&
          other.badges == this.badges &&
          other.versions == this.versions &&
          other.versionTitle == this.versionTitle);
}

class CartMainCompanion extends UpdateCompanion<CartMainData> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> productId;
  final Value<int> catalogId;
  final Value<int> count;
  final Value<int> bonus;
  final Value<int> price;
  final Value<int> regularPrice;
  final Value<String> image;
  final Value<List<String>?> badges;
  final Value<List<Version>?> versions;
  final Value<String?> versionTitle;
  const CartMainCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.productId = const Value.absent(),
    this.catalogId = const Value.absent(),
    this.count = const Value.absent(),
    this.bonus = const Value.absent(),
    this.price = const Value.absent(),
    this.regularPrice = const Value.absent(),
    this.image = const Value.absent(),
    this.badges = const Value.absent(),
    this.versions = const Value.absent(),
    this.versionTitle = const Value.absent(),
  });
  CartMainCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int productId,
    required int catalogId,
    required int count,
    required int bonus,
    required int price,
    required int regularPrice,
    required String image,
    this.badges = const Value.absent(),
    this.versions = const Value.absent(),
    this.versionTitle = const Value.absent(),
  })  : title = Value(title),
        productId = Value(productId),
        catalogId = Value(catalogId),
        count = Value(count),
        bonus = Value(bonus),
        price = Value(price),
        regularPrice = Value(regularPrice),
        image = Value(image);
  static Insertable<CartMainData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? productId,
    Expression<int>? catalogId,
    Expression<int>? count,
    Expression<int>? bonus,
    Expression<int>? price,
    Expression<int>? regularPrice,
    Expression<String>? image,
    Expression<List<String>?>? badges,
    Expression<List<Version>?>? versions,
    Expression<String?>? versionTitle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (productId != null) 'product_id': productId,
      if (catalogId != null) 'catalog_id': catalogId,
      if (count != null) 'count': count,
      if (bonus != null) 'bonus': bonus,
      if (price != null) 'price': price,
      if (regularPrice != null) 'regular_price': regularPrice,
      if (image != null) 'image': image,
      if (badges != null) 'badges': badges,
      if (versions != null) 'versions': versions,
      if (versionTitle != null) 'version_title': versionTitle,
    });
  }

  CartMainCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<int>? productId,
      Value<int>? catalogId,
      Value<int>? count,
      Value<int>? bonus,
      Value<int>? price,
      Value<int>? regularPrice,
      Value<String>? image,
      Value<List<String>?>? badges,
      Value<List<Version>?>? versions,
      Value<String?>? versionTitle}) {
    return CartMainCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      productId: productId ?? this.productId,
      catalogId: catalogId ?? this.catalogId,
      count: count ?? this.count,
      bonus: bonus ?? this.bonus,
      price: price ?? this.price,
      regularPrice: regularPrice ?? this.regularPrice,
      image: image ?? this.image,
      badges: badges ?? this.badges,
      versions: versions ?? this.versions,
      versionTitle: versionTitle ?? this.versionTitle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (catalogId.present) {
      map['catalog_id'] = Variable<int>(catalogId.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<int>(bonus.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (regularPrice.present) {
      map['regular_price'] = Variable<int>(regularPrice.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (badges.present) {
      final converter = $CartMainTable.$converter0;
      map['badges'] = Variable<String?>(converter.mapToSql(badges.value));
    }
    if (versions.present) {
      final converter = $CartMainTable.$converter1;
      map['versions'] = Variable<String?>(converter.mapToSql(versions.value));
    }
    if (versionTitle.present) {
      map['version_title'] = Variable<String?>(versionTitle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartMainCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('productId: $productId, ')
          ..write('catalogId: $catalogId, ')
          ..write('count: $count, ')
          ..write('bonus: $bonus, ')
          ..write('price: $price, ')
          ..write('regularPrice: $regularPrice, ')
          ..write('image: $image, ')
          ..write('badges: $badges, ')
          ..write('versions: $versions, ')
          ..write('versionTitle: $versionTitle')
          ..write(')'))
        .toString();
  }
}

class $CartMainTable extends CartMain
    with TableInfo<$CartMainTable, CartMainData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartMainTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 300),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int?> productId = GeneratedColumn<int?>(
      'product_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _catalogIdMeta = const VerificationMeta('catalogId');
  @override
  late final GeneratedColumn<int?> catalogId = GeneratedColumn<int?>(
      'catalog_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int?> count = GeneratedColumn<int?>(
      'count', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<int?> bonus = GeneratedColumn<int?>(
      'bonus', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int?> price = GeneratedColumn<int?>(
      'price', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _regularPriceMeta =
      const VerificationMeta('regularPrice');
  @override
  late final GeneratedColumn<int?> regularPrice = GeneratedColumn<int?>(
      'regular_price', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String?> image = GeneratedColumn<String?>(
      'image', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 200),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _badgesMeta = const VerificationMeta('badges');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String?> badges =
      GeneratedColumn<String?>('badges', aliasedName, true,
              additionalChecks: GeneratedColumn.checkTextLength(
                  minTextLength: 0, maxTextLength: 200),
              type: const StringType(),
              requiredDuringInsert: false)
          .withConverter<List<String>>($CartMainTable.$converter0);
  final VerificationMeta _versionsMeta = const VerificationMeta('versions');
  @override
  late final GeneratedColumnWithTypeConverter<List<Version>?, String?>
      versions = GeneratedColumn<String?>('versions', aliasedName, true,
              additionalChecks: GeneratedColumn.checkTextLength(
                  minTextLength: 0, maxTextLength: 400),
              type: const StringType(),
              requiredDuringInsert: false)
          .withConverter<List<Version>?>($CartMainTable.$converter1);
  final VerificationMeta _versionTitleMeta =
      const VerificationMeta('versionTitle');
  @override
  late final GeneratedColumn<String?> versionTitle = GeneratedColumn<String?>(
      'version_title', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 200),
      type: const StringType(),
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        productId,
        catalogId,
        count,
        bonus,
        price,
        regularPrice,
        image,
        badges,
        versions,
        versionTitle
      ];
  @override
  String get aliasedName => _alias ?? 'cart_main';
  @override
  String get actualTableName => 'cart_main';
  @override
  VerificationContext validateIntegrity(Insertable<CartMainData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('catalog_id')) {
      context.handle(_catalogIdMeta,
          catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta));
    } else if (isInserting) {
      context.missing(_catalogIdMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('bonus')) {
      context.handle(
          _bonusMeta, bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta));
    } else if (isInserting) {
      context.missing(_bonusMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('regular_price')) {
      context.handle(
          _regularPriceMeta,
          regularPrice.isAcceptableOrUnknown(
              data['regular_price']!, _regularPriceMeta));
    } else if (isInserting) {
      context.missing(_regularPriceMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    context.handle(_badgesMeta, const VerificationResult.success());
    context.handle(_versionsMeta, const VerificationResult.success());
    if (data.containsKey('version_title')) {
      context.handle(
          _versionTitleMeta,
          versionTitle.isAcceptableOrUnknown(
              data['version_title']!, _versionTitleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartMainData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CartMainData.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CartMainTable createAlias(String alias) {
    return $CartMainTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converter0 =
      const StrListToColumnConv();
  static TypeConverter<List<Version>?, String> $converter1 =
      const VersionToColumnConv();
}

class CartAddData extends DataClass implements Insertable<CartAddData> {
  final int id;
  final int productId;
  final int mainId;
  final String title;
  final String image;
  final int price;
  CartAddData(
      {required this.id,
      required this.productId,
      required this.mainId,
      required this.title,
      required this.image,
      required this.price});
  factory CartAddData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CartAddData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      productId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id'])!,
      mainId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}main_id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      image: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image'])!,
      price: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['main_id'] = Variable<int>(mainId);
    map['title'] = Variable<String>(title);
    map['image'] = Variable<String>(image);
    map['price'] = Variable<int>(price);
    return map;
  }

  CartAddCompanion toCompanion(bool nullToAbsent) {
    return CartAddCompanion(
      id: Value(id),
      productId: Value(productId),
      mainId: Value(mainId),
      title: Value(title),
      image: Value(image),
      price: Value(price),
    );
  }

  factory CartAddData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CartAddData(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      mainId: serializer.fromJson<int>(json['mainId']),
      title: serializer.fromJson<String>(json['title']),
      image: serializer.fromJson<String>(json['image']),
      price: serializer.fromJson<int>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'mainId': serializer.toJson<int>(mainId),
      'title': serializer.toJson<String>(title),
      'image': serializer.toJson<String>(image),
      'price': serializer.toJson<int>(price),
    };
  }

  CartAddData copyWith(
          {int? id,
          int? productId,
          int? mainId,
          String? title,
          String? image,
          int? price}) =>
      CartAddData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        mainId: mainId ?? this.mainId,
        title: title ?? this.title,
        image: image ?? this.image,
        price: price ?? this.price,
      );
  @override
  String toString() {
    return (StringBuffer('CartAddData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('mainId: $mainId, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, mainId, title, image, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartAddData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.mainId == this.mainId &&
          other.title == this.title &&
          other.image == this.image &&
          other.price == this.price);
}

class CartAddCompanion extends UpdateCompanion<CartAddData> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> mainId;
  final Value<String> title;
  final Value<String> image;
  final Value<int> price;
  const CartAddCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.mainId = const Value.absent(),
    this.title = const Value.absent(),
    this.image = const Value.absent(),
    this.price = const Value.absent(),
  });
  CartAddCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int mainId,
    required String title,
    required String image,
    required int price,
  })  : productId = Value(productId),
        mainId = Value(mainId),
        title = Value(title),
        image = Value(image),
        price = Value(price);
  static Insertable<CartAddData> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? mainId,
    Expression<String>? title,
    Expression<String>? image,
    Expression<int>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (mainId != null) 'main_id': mainId,
      if (title != null) 'title': title,
      if (image != null) 'image': image,
      if (price != null) 'price': price,
    });
  }

  CartAddCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<int>? mainId,
      Value<String>? title,
      Value<String>? image,
      Value<int>? price}) {
    return CartAddCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      mainId: mainId ?? this.mainId,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (mainId.present) {
      map['main_id'] = Variable<int>(mainId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartAddCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('mainId: $mainId, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $CartAddTable extends CartAdd with TableInfo<$CartAddTable, CartAddData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartAddTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int?> productId = GeneratedColumn<int?>(
      'product_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _mainIdMeta = const VerificationMeta('mainId');
  @override
  late final GeneratedColumn<int?> mainId = GeneratedColumn<int?>(
      'main_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 300),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String?> image = GeneratedColumn<String?>(
      'image', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 200),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int?> price = GeneratedColumn<int?>(
      'price', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, mainId, title, image, price];
  @override
  String get aliasedName => _alias ?? 'cart_add';
  @override
  String get actualTableName => 'cart_add';
  @override
  VerificationContext validateIntegrity(Insertable<CartAddData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('main_id')) {
      context.handle(_mainIdMeta,
          mainId.isAcceptableOrUnknown(data['main_id']!, _mainIdMeta));
    } else if (isInserting) {
      context.missing(_mainIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartAddData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CartAddData.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CartAddTable createAlias(String alias) {
    return $CartAddTable(attachedDatabase, alias);
  }
}

class FavoriteData extends DataClass implements Insertable<FavoriteData> {
  final int favoriteId;
  final int id;
  final String sku;
  final String title;
  final String image;
  final int price;
  final int maxPrice;
  final int regularPrice;
  final int priceTime;
  final int bonus;
  final List<String>? badges;
  final double? averageMark;
  FavoriteData(
      {required this.favoriteId,
      required this.id,
      required this.sku,
      required this.title,
      required this.image,
      required this.price,
      required this.maxPrice,
      required this.regularPrice,
      required this.priceTime,
      required this.bonus,
      this.badges,
      this.averageMark});
  factory FavoriteData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FavoriteData(
      favoriteId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}favorite_id'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      sku: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sku'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      image: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image'])!,
      price: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price'])!,
      maxPrice: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}max_price'])!,
      regularPrice: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}regular_price'])!,
      priceTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price_time'])!,
      bonus: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bonus'])!,
      badges: $FavoritesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}badges'])),
      averageMark: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}average_mark']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['favorite_id'] = Variable<int>(favoriteId);
    map['id'] = Variable<int>(id);
    map['sku'] = Variable<String>(sku);
    map['title'] = Variable<String>(title);
    map['image'] = Variable<String>(image);
    map['price'] = Variable<int>(price);
    map['max_price'] = Variable<int>(maxPrice);
    map['regular_price'] = Variable<int>(regularPrice);
    map['price_time'] = Variable<int>(priceTime);
    map['bonus'] = Variable<int>(bonus);
    if (!nullToAbsent || badges != null) {
      final converter = $FavoritesTable.$converter0;
      map['badges'] = Variable<String?>(converter.mapToSql(badges));
    }
    if (!nullToAbsent || averageMark != null) {
      map['average_mark'] = Variable<double?>(averageMark);
    }
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      favoriteId: Value(favoriteId),
      id: Value(id),
      sku: Value(sku),
      title: Value(title),
      image: Value(image),
      price: Value(price),
      maxPrice: Value(maxPrice),
      regularPrice: Value(regularPrice),
      priceTime: Value(priceTime),
      bonus: Value(bonus),
      badges:
          badges == null && nullToAbsent ? const Value.absent() : Value(badges),
      averageMark: averageMark == null && nullToAbsent
          ? const Value.absent()
          : Value(averageMark),
    );
  }

  factory FavoriteData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FavoriteData(
      favoriteId: serializer.fromJson<int>(json['favoriteId']),
      id: serializer.fromJson<int>(json['id']),
      sku: serializer.fromJson<String>(json['sku']),
      title: serializer.fromJson<String>(json['title']),
      image: serializer.fromJson<String>(json['image']),
      price: serializer.fromJson<int>(json['price']),
      maxPrice: serializer.fromJson<int>(json['maxPrice']),
      regularPrice: serializer.fromJson<int>(json['regularPrice']),
      priceTime: serializer.fromJson<int>(json['priceTime']),
      bonus: serializer.fromJson<int>(json['bonus']),
      badges: serializer.fromJson<List<String>?>(json['badges']),
      averageMark: serializer.fromJson<double?>(json['averageMark']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'favoriteId': serializer.toJson<int>(favoriteId),
      'id': serializer.toJson<int>(id),
      'sku': serializer.toJson<String>(sku),
      'title': serializer.toJson<String>(title),
      'image': serializer.toJson<String>(image),
      'price': serializer.toJson<int>(price),
      'maxPrice': serializer.toJson<int>(maxPrice),
      'regularPrice': serializer.toJson<int>(regularPrice),
      'priceTime': serializer.toJson<int>(priceTime),
      'bonus': serializer.toJson<int>(bonus),
      'badges': serializer.toJson<List<String>?>(badges),
      'averageMark': serializer.toJson<double?>(averageMark),
    };
  }

  FavoriteData copyWith(
          {int? favoriteId,
          int? id,
          String? sku,
          String? title,
          String? image,
          int? price,
          int? maxPrice,
          int? regularPrice,
          int? priceTime,
          int? bonus,
          List<String>? badges,
          double? averageMark}) =>
      FavoriteData(
        favoriteId: favoriteId ?? this.favoriteId,
        id: id ?? this.id,
        sku: sku ?? this.sku,
        title: title ?? this.title,
        image: image ?? this.image,
        price: price ?? this.price,
        maxPrice: maxPrice ?? this.maxPrice,
        regularPrice: regularPrice ?? this.regularPrice,
        priceTime: priceTime ?? this.priceTime,
        bonus: bonus ?? this.bonus,
        badges: badges ?? this.badges,
        averageMark: averageMark ?? this.averageMark,
      );
  @override
  String toString() {
    return (StringBuffer('FavoriteData(')
          ..write('favoriteId: $favoriteId, ')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('price: $price, ')
          ..write('maxPrice: $maxPrice, ')
          ..write('regularPrice: $regularPrice, ')
          ..write('priceTime: $priceTime, ')
          ..write('bonus: $bonus, ')
          ..write('badges: $badges, ')
          ..write('averageMark: $averageMark')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(favoriteId, id, sku, title, image, price,
      maxPrice, regularPrice, priceTime, bonus, badges, averageMark);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteData &&
          other.favoriteId == this.favoriteId &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.title == this.title &&
          other.image == this.image &&
          other.price == this.price &&
          other.maxPrice == this.maxPrice &&
          other.regularPrice == this.regularPrice &&
          other.priceTime == this.priceTime &&
          other.bonus == this.bonus &&
          other.badges == this.badges &&
          other.averageMark == this.averageMark);
}

class FavoritesCompanion extends UpdateCompanion<FavoriteData> {
  final Value<int> favoriteId;
  final Value<int> id;
  final Value<String> sku;
  final Value<String> title;
  final Value<String> image;
  final Value<int> price;
  final Value<int> maxPrice;
  final Value<int> regularPrice;
  final Value<int> priceTime;
  final Value<int> bonus;
  final Value<List<String>?> badges;
  final Value<double?> averageMark;
  const FavoritesCompanion({
    this.favoriteId = const Value.absent(),
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.title = const Value.absent(),
    this.image = const Value.absent(),
    this.price = const Value.absent(),
    this.maxPrice = const Value.absent(),
    this.regularPrice = const Value.absent(),
    this.priceTime = const Value.absent(),
    this.bonus = const Value.absent(),
    this.badges = const Value.absent(),
    this.averageMark = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.favoriteId = const Value.absent(),
    required int id,
    required String sku,
    required String title,
    required String image,
    required int price,
    required int maxPrice,
    required int regularPrice,
    required int priceTime,
    required int bonus,
    this.badges = const Value.absent(),
    this.averageMark = const Value.absent(),
  })  : id = Value(id),
        sku = Value(sku),
        title = Value(title),
        image = Value(image),
        price = Value(price),
        maxPrice = Value(maxPrice),
        regularPrice = Value(regularPrice),
        priceTime = Value(priceTime),
        bonus = Value(bonus);
  static Insertable<FavoriteData> custom({
    Expression<int>? favoriteId,
    Expression<int>? id,
    Expression<String>? sku,
    Expression<String>? title,
    Expression<String>? image,
    Expression<int>? price,
    Expression<int>? maxPrice,
    Expression<int>? regularPrice,
    Expression<int>? priceTime,
    Expression<int>? bonus,
    Expression<List<String>?>? badges,
    Expression<double?>? averageMark,
  }) {
    return RawValuesInsertable({
      if (favoriteId != null) 'favorite_id': favoriteId,
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (title != null) 'title': title,
      if (image != null) 'image': image,
      if (price != null) 'price': price,
      if (maxPrice != null) 'max_price': maxPrice,
      if (regularPrice != null) 'regular_price': regularPrice,
      if (priceTime != null) 'price_time': priceTime,
      if (bonus != null) 'bonus': bonus,
      if (badges != null) 'badges': badges,
      if (averageMark != null) 'average_mark': averageMark,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int>? favoriteId,
      Value<int>? id,
      Value<String>? sku,
      Value<String>? title,
      Value<String>? image,
      Value<int>? price,
      Value<int>? maxPrice,
      Value<int>? regularPrice,
      Value<int>? priceTime,
      Value<int>? bonus,
      Value<List<String>?>? badges,
      Value<double?>? averageMark}) {
    return FavoritesCompanion(
      favoriteId: favoriteId ?? this.favoriteId,
      id: id ?? this.id,
      sku: sku ?? this.sku,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      maxPrice: maxPrice ?? this.maxPrice,
      regularPrice: regularPrice ?? this.regularPrice,
      priceTime: priceTime ?? this.priceTime,
      bonus: bonus ?? this.bonus,
      badges: badges ?? this.badges,
      averageMark: averageMark ?? this.averageMark,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (favoriteId.present) {
      map['favorite_id'] = Variable<int>(favoriteId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (maxPrice.present) {
      map['max_price'] = Variable<int>(maxPrice.value);
    }
    if (regularPrice.present) {
      map['regular_price'] = Variable<int>(regularPrice.value);
    }
    if (priceTime.present) {
      map['price_time'] = Variable<int>(priceTime.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<int>(bonus.value);
    }
    if (badges.present) {
      final converter = $FavoritesTable.$converter0;
      map['badges'] = Variable<String?>(converter.mapToSql(badges.value));
    }
    if (averageMark.present) {
      map['average_mark'] = Variable<double?>(averageMark.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('favoriteId: $favoriteId, ')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('price: $price, ')
          ..write('maxPrice: $maxPrice, ')
          ..write('regularPrice: $regularPrice, ')
          ..write('priceTime: $priceTime, ')
          ..write('bonus: $bonus, ')
          ..write('badges: $badges, ')
          ..write('averageMark: $averageMark')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, FavoriteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _favoriteIdMeta = const VerificationMeta('favoriteId');
  @override
  late final GeneratedColumn<int?> favoriteId = GeneratedColumn<int?>(
      'favorite_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String?> sku = GeneratedColumn<String?>(
      'sku', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 300),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 300),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String?> image = GeneratedColumn<String?>(
      'image', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 200),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int?> price = GeneratedColumn<int?>(
      'price', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _maxPriceMeta = const VerificationMeta('maxPrice');
  @override
  late final GeneratedColumn<int?> maxPrice = GeneratedColumn<int?>(
      'max_price', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _regularPriceMeta =
      const VerificationMeta('regularPrice');
  @override
  late final GeneratedColumn<int?> regularPrice = GeneratedColumn<int?>(
      'regular_price', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _priceTimeMeta = const VerificationMeta('priceTime');
  @override
  late final GeneratedColumn<int?> priceTime = GeneratedColumn<int?>(
      'price_time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<int?> bonus = GeneratedColumn<int?>(
      'bonus', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _badgesMeta = const VerificationMeta('badges');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String?> badges =
      GeneratedColumn<String?>('badges', aliasedName, true,
              additionalChecks: GeneratedColumn.checkTextLength(
                  minTextLength: 0, maxTextLength: 200),
              type: const StringType(),
              requiredDuringInsert: false)
          .withConverter<List<String>>($FavoritesTable.$converter0);
  final VerificationMeta _averageMarkMeta =
      const VerificationMeta('averageMark');
  @override
  late final GeneratedColumn<double?> averageMark = GeneratedColumn<double?>(
      'average_mark', aliasedName, true,
      type: const RealType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        favoriteId,
        id,
        sku,
        title,
        image,
        price,
        maxPrice,
        regularPrice,
        priceTime,
        bonus,
        badges,
        averageMark
      ];
  @override
  String get aliasedName => _alias ?? 'favorites';
  @override
  String get actualTableName => 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('favorite_id')) {
      context.handle(
          _favoriteIdMeta,
          favoriteId.isAcceptableOrUnknown(
              data['favorite_id']!, _favoriteIdMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('max_price')) {
      context.handle(_maxPriceMeta,
          maxPrice.isAcceptableOrUnknown(data['max_price']!, _maxPriceMeta));
    } else if (isInserting) {
      context.missing(_maxPriceMeta);
    }
    if (data.containsKey('regular_price')) {
      context.handle(
          _regularPriceMeta,
          regularPrice.isAcceptableOrUnknown(
              data['regular_price']!, _regularPriceMeta));
    } else if (isInserting) {
      context.missing(_regularPriceMeta);
    }
    if (data.containsKey('price_time')) {
      context.handle(_priceTimeMeta,
          priceTime.isAcceptableOrUnknown(data['price_time']!, _priceTimeMeta));
    } else if (isInserting) {
      context.missing(_priceTimeMeta);
    }
    if (data.containsKey('bonus')) {
      context.handle(
          _bonusMeta, bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta));
    } else if (isInserting) {
      context.missing(_bonusMeta);
    }
    context.handle(_badgesMeta, const VerificationResult.success());
    if (data.containsKey('average_mark')) {
      context.handle(
          _averageMarkMeta,
          averageMark.isAcceptableOrUnknown(
              data['average_mark']!, _averageMarkMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {favoriteId};
  @override
  FavoriteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FavoriteData.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converter0 =
      const StrListToColumnConv();
}

class AddressData extends DataClass implements Insertable<AddressData> {
  final int id;
  final String address;
  final String? title;
  final String? entrance;
  final String? apartment;
  final String? intercom;
  final bool tmp;
  final double lat;
  final double long;
  final DateTime used;
  AddressData(
      {required this.id,
      required this.address,
      this.title,
      this.entrance,
      this.apartment,
      this.intercom,
      required this.tmp,
      required this.lat,
      required this.long,
      required this.used});
  factory AddressData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AddressData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      address: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}address'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title']),
      entrance: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}entrance']),
      apartment: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}apartment']),
      intercom: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}intercom']),
      tmp: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tmp'])!,
      lat: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}lat'])!,
      long: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}long'])!,
      used: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}used'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String?>(title);
    }
    if (!nullToAbsent || entrance != null) {
      map['entrance'] = Variable<String?>(entrance);
    }
    if (!nullToAbsent || apartment != null) {
      map['apartment'] = Variable<String?>(apartment);
    }
    if (!nullToAbsent || intercom != null) {
      map['intercom'] = Variable<String?>(intercom);
    }
    map['tmp'] = Variable<bool>(tmp);
    map['lat'] = Variable<double>(lat);
    map['long'] = Variable<double>(long);
    map['used'] = Variable<DateTime>(used);
    return map;
  }

  AddressesCompanion toCompanion(bool nullToAbsent) {
    return AddressesCompanion(
      id: Value(id),
      address: Value(address),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      entrance: entrance == null && nullToAbsent
          ? const Value.absent()
          : Value(entrance),
      apartment: apartment == null && nullToAbsent
          ? const Value.absent()
          : Value(apartment),
      intercom: intercom == null && nullToAbsent
          ? const Value.absent()
          : Value(intercom),
      tmp: Value(tmp),
      lat: Value(lat),
      long: Value(long),
      used: Value(used),
    );
  }

  factory AddressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AddressData(
      id: serializer.fromJson<int>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      title: serializer.fromJson<String?>(json['title']),
      entrance: serializer.fromJson<String?>(json['entrance']),
      apartment: serializer.fromJson<String?>(json['apartment']),
      intercom: serializer.fromJson<String?>(json['intercom']),
      tmp: serializer.fromJson<bool>(json['tmp']),
      lat: serializer.fromJson<double>(json['lat']),
      long: serializer.fromJson<double>(json['long']),
      used: serializer.fromJson<DateTime>(json['used']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'address': serializer.toJson<String>(address),
      'title': serializer.toJson<String?>(title),
      'entrance': serializer.toJson<String?>(entrance),
      'apartment': serializer.toJson<String?>(apartment),
      'intercom': serializer.toJson<String?>(intercom),
      'tmp': serializer.toJson<bool>(tmp),
      'lat': serializer.toJson<double>(lat),
      'long': serializer.toJson<double>(long),
      'used': serializer.toJson<DateTime>(used),
    };
  }

  AddressData copyWith(
          {int? id,
          String? address,
          String? title,
          String? entrance,
          String? apartment,
          String? intercom,
          bool? tmp,
          double? lat,
          double? long,
          DateTime? used}) =>
      AddressData(
        id: id ?? this.id,
        address: address ?? this.address,
        title: title ?? this.title,
        entrance: entrance ?? this.entrance,
        apartment: apartment ?? this.apartment,
        intercom: intercom ?? this.intercom,
        tmp: tmp ?? this.tmp,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        used: used ?? this.used,
      );
  @override
  String toString() {
    return (StringBuffer('AddressData(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('title: $title, ')
          ..write('entrance: $entrance, ')
          ..write('apartment: $apartment, ')
          ..write('intercom: $intercom, ')
          ..write('tmp: $tmp, ')
          ..write('lat: $lat, ')
          ..write('long: $long, ')
          ..write('used: $used')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, address, title, entrance, apartment, intercom, tmp, lat, long, used);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddressData &&
          other.id == this.id &&
          other.address == this.address &&
          other.title == this.title &&
          other.entrance == this.entrance &&
          other.apartment == this.apartment &&
          other.intercom == this.intercom &&
          other.tmp == this.tmp &&
          other.lat == this.lat &&
          other.long == this.long &&
          other.used == this.used);
}

class AddressesCompanion extends UpdateCompanion<AddressData> {
  final Value<int> id;
  final Value<String> address;
  final Value<String?> title;
  final Value<String?> entrance;
  final Value<String?> apartment;
  final Value<String?> intercom;
  final Value<bool> tmp;
  final Value<double> lat;
  final Value<double> long;
  final Value<DateTime> used;
  const AddressesCompanion({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.title = const Value.absent(),
    this.entrance = const Value.absent(),
    this.apartment = const Value.absent(),
    this.intercom = const Value.absent(),
    this.tmp = const Value.absent(),
    this.lat = const Value.absent(),
    this.long = const Value.absent(),
    this.used = const Value.absent(),
  });
  AddressesCompanion.insert({
    this.id = const Value.absent(),
    required String address,
    this.title = const Value.absent(),
    this.entrance = const Value.absent(),
    this.apartment = const Value.absent(),
    this.intercom = const Value.absent(),
    this.tmp = const Value.absent(),
    required double lat,
    required double long,
    this.used = const Value.absent(),
  })  : address = Value(address),
        lat = Value(lat),
        long = Value(long);
  static Insertable<AddressData> custom({
    Expression<int>? id,
    Expression<String>? address,
    Expression<String?>? title,
    Expression<String?>? entrance,
    Expression<String?>? apartment,
    Expression<String?>? intercom,
    Expression<bool>? tmp,
    Expression<double>? lat,
    Expression<double>? long,
    Expression<DateTime>? used,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (address != null) 'address': address,
      if (title != null) 'title': title,
      if (entrance != null) 'entrance': entrance,
      if (apartment != null) 'apartment': apartment,
      if (intercom != null) 'intercom': intercom,
      if (tmp != null) 'tmp': tmp,
      if (lat != null) 'lat': lat,
      if (long != null) 'long': long,
      if (used != null) 'used': used,
    });
  }

  AddressesCompanion copyWith(
      {Value<int>? id,
      Value<String>? address,
      Value<String?>? title,
      Value<String?>? entrance,
      Value<String?>? apartment,
      Value<String?>? intercom,
      Value<bool>? tmp,
      Value<double>? lat,
      Value<double>? long,
      Value<DateTime>? used}) {
    return AddressesCompanion(
      id: id ?? this.id,
      address: address ?? this.address,
      title: title ?? this.title,
      entrance: entrance ?? this.entrance,
      apartment: apartment ?? this.apartment,
      intercom: intercom ?? this.intercom,
      tmp: tmp ?? this.tmp,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      used: used ?? this.used,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (title.present) {
      map['title'] = Variable<String?>(title.value);
    }
    if (entrance.present) {
      map['entrance'] = Variable<String?>(entrance.value);
    }
    if (apartment.present) {
      map['apartment'] = Variable<String?>(apartment.value);
    }
    if (intercom.present) {
      map['intercom'] = Variable<String?>(intercom.value);
    }
    if (tmp.present) {
      map['tmp'] = Variable<bool>(tmp.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (long.present) {
      map['long'] = Variable<double>(long.value);
    }
    if (used.present) {
      map['used'] = Variable<DateTime>(used.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AddressesCompanion(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('title: $title, ')
          ..write('entrance: $entrance, ')
          ..write('apartment: $apartment, ')
          ..write('intercom: $intercom, ')
          ..write('tmp: $tmp, ')
          ..write('lat: $lat, ')
          ..write('long: $long, ')
          ..write('used: $used')
          ..write(')'))
        .toString();
  }
}

class $AddressesTable extends Addresses
    with TableInfo<$AddressesTable, AddressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AddressesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _addressMeta = const VerificationMeta('address');
  @override
  late final GeneratedColumn<String?> address = GeneratedColumn<String?>(
      'address', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 400),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 400),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _entranceMeta = const VerificationMeta('entrance');
  @override
  late final GeneratedColumn<String?> entrance = GeneratedColumn<String?>(
      'entrance', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 10),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _apartmentMeta = const VerificationMeta('apartment');
  @override
  late final GeneratedColumn<String?> apartment = GeneratedColumn<String?>(
      'apartment', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 10),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _intercomMeta = const VerificationMeta('intercom');
  @override
  late final GeneratedColumn<String?> intercom = GeneratedColumn<String?>(
      'intercom', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 10),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _tmpMeta = const VerificationMeta('tmp');
  @override
  late final GeneratedColumn<bool?> tmp = GeneratedColumn<bool?>(
      'tmp', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (tmp IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double?> lat = GeneratedColumn<double?>(
      'lat', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _longMeta = const VerificationMeta('long');
  @override
  late final GeneratedColumn<double?> long = GeneratedColumn<double?>(
      'long', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _usedMeta = const VerificationMeta('used');
  @override
  late final GeneratedColumn<DateTime?> used = GeneratedColumn<DateTime?>(
      'used', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, address, title, entrance, apartment, intercom, tmp, lat, long, used];
  @override
  String get aliasedName => _alias ?? 'addresses';
  @override
  String get actualTableName => 'addresses';
  @override
  VerificationContext validateIntegrity(Insertable<AddressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('entrance')) {
      context.handle(_entranceMeta,
          entrance.isAcceptableOrUnknown(data['entrance']!, _entranceMeta));
    }
    if (data.containsKey('apartment')) {
      context.handle(_apartmentMeta,
          apartment.isAcceptableOrUnknown(data['apartment']!, _apartmentMeta));
    }
    if (data.containsKey('intercom')) {
      context.handle(_intercomMeta,
          intercom.isAcceptableOrUnknown(data['intercom']!, _intercomMeta));
    }
    if (data.containsKey('tmp')) {
      context.handle(
          _tmpMeta, tmp.isAcceptableOrUnknown(data['tmp']!, _tmpMeta));
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('long')) {
      context.handle(
          _longMeta, long.isAcceptableOrUnknown(data['long']!, _longMeta));
    } else if (isInserting) {
      context.missing(_longMeta);
    }
    if (data.containsKey('used')) {
      context.handle(
          _usedMeta, used.isAcceptableOrUnknown(data['used']!, _usedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AddressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return AddressData.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AddressesTable createAlias(String alias) {
    return $AddressesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $CartMainTable cartMain = $CartMainTable(this);
  late final $CartAddTable cartAdd = $CartAddTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $AddressesTable addresses = $AddressesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cartMain, cartAdd, favorites, addresses];
}
