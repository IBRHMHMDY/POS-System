import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ==========================================
// 1. جدول المستخدمين (Users)
// ==========================================
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 3, max: 50)();
  TextColumn get role => text()(); // الأدوار: Owner, Manager, Cashier
  TextColumn get passcode => text().withLength(min: 4, max: 10)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// ==========================================
// 2. جداول قوائم الطعام (Categories & Products)
// ==========================================
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get barcode => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// ==========================================
// 3. جدول الورديات (Shifts)
// ==========================================
class Shifts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  RealColumn get startingCash => real().withDefault(const Constant(0.0))();
  RealColumn get totalSales => real().withDefault(const Constant(0.0))();
  RealColumn get totalExpenses => real().withDefault(const Constant(0.0))();
  RealColumn get actualCash => real().nullable()();
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();
}

// ==========================================
// 4. جدول المصروفات (Expenses)
// ==========================================
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shiftId => integer().nullable().references(Shifts, #id)();
  IntColumn get userId => integer().references(Users, #id)();
  RealColumn get amount => real()();
  TextColumn get reason => text()();
  DateTimeColumn get date => dateTime()();
}

// ==========================================
// 5. جداول الفواتير (Invoices & InvoiceItems)
// ==========================================
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shiftId => integer().references(Shifts, #id)();
  IntColumn get userId => integer().references(Users, #id)();
  RealColumn get subTotal => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  RealColumn get tax => real().withDefault(const Constant(0.0))();
  RealColumn get grandTotal => real()();
  TextColumn get paymentMethod => text()(); // نقدي، فيزا، أخرى
  DateTimeColumn get date => dateTime()();
}

class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  RealColumn get quantity => real()(); // Real للسماح بالكسور (كالوزن)
  RealColumn get unitPrice => real()();
  RealColumn get totalPrice => real()();
}

// ==========================================
// 6. جدول الإعدادات العامة (AppSettings)
// ==========================================
class AppSettings extends Table {
  TextColumn get settingKey => text()(); 
  TextColumn get settingValue => text()();
  
  @override
  Set<Column> get primaryKey => {settingKey};
}

// ==========================================
// تهيئة قاعدة البيانات (Database Definition)
// ==========================================
@DriftDatabase(tables: [
  Users, Categories, Products, Shifts, Expenses, Invoices, InvoiceItems, AppSettings
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // تفعيل القيود الصارمة للعلاقات (Foreign Keys)
  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pos_egypt_offline.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}