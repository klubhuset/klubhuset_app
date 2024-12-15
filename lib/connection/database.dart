// import 'package:drift/drift.dart';
// import 'package:drift_postgres/drift_postgres.dart';
// import 'package:postgres/postgres.dart' as pg;

// part 'database.g.dart';

// class Player extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name => text().withLength(min: 6, max: 128)();
//   BoolColumn get isTeamOwner => boolean()();
//   DateTimeColumn get createdAt => dateTime().nullable()();
//   DateTimeColumn get updatedAt => dateTime().nullable()();
// }

// @DriftDatabase(tables: [Player])
// class AppDatabase extends _$AppDatabase {
//   // After generating code, this class needs to define a `schemaVersion` getter
//   // and a constructor telling drift where the database should be stored.
//   // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 2;

//   static QueryExecutor _openConnection() {
//     // TODO 1: Should be done with .env file
//     String host = 'localhost';
//     String user = 'klubhuset';
//     String pass = '1234';
//     String name = 'klubhuset';

//     return PgDatabase(
//       settings: pg.ConnectionSettings(sslMode: pg.SslMode.disable),
//       endpoint: pg.Endpoint(
//         host: host,
//         database: name,
//         username: user,
//         password: pass,
//       ),
//     );
//   }
// }
