import 'package:drift/drift.dart';
import 'package:e1547/identity/data/database.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';

@UseRowClass(Task, generateInsertable: true)
class TasksTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => textEnum<TaskAction>()();
  IntColumn get postId => integer()();
  TextColumn get status => textEnum<TaskStatus>()();
  TextColumn get error => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get metadata => text()
      .map(
        JsonSqlConverter<TaskMetadata>(
          decode: (value) =>
              TaskMetadata.fromJson(value as Map<String, dynamic>),
        ),
      )
      .nullable()();
}

@DataClassName('TaskIdentity')
class TasksIdentitiesTable extends Table {
  IntColumn get identity => integer().references(
    IdentitiesTable,
    #id,
    onDelete: KeyAction.noAction,
    onUpdate: KeyAction.noAction,
  )();
  IntColumn get task => integer().references(
    TasksTable,
    #id,
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {identity, task};
}

@DriftAccessor(tables: [TasksTable, TasksIdentitiesTable, IdentitiesTable])
class TaskRepository extends DatabaseAccessor<GeneratedDatabase>
    with $TaskRepositoryMixin {
  TaskRepository({required GeneratedDatabase database}) : super(database);

  StreamFuture<Task> get(int id) => (select(
    tasksTable,
  )..where((tbl) => tbl.id.equals(id))).watchSingle().future;

  Expression<bool> _identityQuery($TasksTableTable tbl, int? identity) {
    final subQuery = tasksIdentitiesTable.selectOnly()
      ..addColumns([tasksIdentitiesTable.task])
      ..where(
        Variable(identity).isNull() |
            tasksIdentitiesTable.identity.equalsNullable(identity),
      );

    return tbl.id.isInQuery(subQuery);
  }

  SimpleSelectStatement<TasksTable, Task> _querySelect({
    int? limit,
    int? offset,
    int? identity,
    Set<TaskAction>? actions,
    Set<TaskStatus>? statuses,
  }) {
    final selectable = select(tasksTable)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ])
      ..where((tbl) => _identityQuery(tbl, identity));
    if (actions != null) {
      selectable.where((tbl) => tbl.action.isIn(actions.map((e) => e.name)));
    }
    if (statuses != null) {
      selectable.where((tbl) => tbl.status.isIn(statuses.map((e) => e.name)));
    }
    assert(
      offset == null || limit != null,
      'Cannot specify offset without limit!',
    );
    if (limit != null) {
      selectable.limit(limit, offset: offset);
    }
    return selectable;
  }

  StreamFuture<List<Task>> page({
    int? page,
    int? limit,
    int? identity,
    Set<TaskAction>? actions,
    Set<TaskStatus>? statuses,
  }) {
    page ??= 1;
    limit ??= 80;
    final int offset = (page < 1 ? 0 : page - 1) * limit;
    return _querySelect(
      limit: limit,
      offset: offset,
      identity: identity,
      actions: actions,
      statuses: statuses,
    ).watch().future;
  }

  StreamFuture<List<Task>> all({int? identity}) =>
      _querySelect(identity: identity).watch().future;

  StreamFuture<List<Task>> active({int? identity}) => _querySelect(
    identity: identity,
    statuses: {TaskStatus.pending, TaskStatus.running},
  ).watch().future;

  StreamFuture<int> length({
    int? identity,
    Set<TaskAction>? actions,
    Set<TaskStatus>? statuses,
  }) {
    final Expression<int> count = tasksTable.id.count();
    final selectable = selectOnly(tasksTable)
      ..where(_identityQuery(tasksTable, identity))
      ..addColumns([count]);
    if (actions != null) {
      selectable.where(tasksTable.action.isIn(actions.map((e) => e.name)));
    }
    if (statuses != null) {
      selectable.where(tasksTable.status.isIn(statuses.map((e) => e.name)));
    }
    return selectable.map((row) => row.read(count)!).watchSingle().future;
  }

  Future<Task> add(TaskRequest item, int identity) async {
    final Task task = await into(tasksTable).insertReturning(
      TaskCompanion(
        action: Value(item.action),
        postId: Value(item.postId),
        status: const Value(TaskStatus.pending),
        createdAt: Value(DateTime.now()),
        metadata: Value(item.metadata),
      ),
    );
    await into(tasksIdentitiesTable).insert(
      TaskIdentityCompanion(identity: Value(identity), task: Value(task.id)),
    );
    return task;
  }

  Future<List<Task>> addAll(Iterable<TaskRequest> items, int identity) =>
      transaction(() async {
        final DateTime now = DateTime.now();
        final List<Task> created = [];
        for (final item in items) {
          final Task task = await into(tasksTable).insertReturning(
            TaskCompanion(
              action: Value(item.action),
              postId: Value(item.postId),
              status: const Value(TaskStatus.pending),
              createdAt: Value(now),
              metadata: Value(item.metadata),
            ),
          );
          created.add(task);
        }
        await batch((b) {
          b.insertAll(
            tasksIdentitiesTable,
            created
                .map(
                  (task) => TaskIdentityCompanion(
                    identity: Value(identity),
                    task: Value(task.id),
                  ),
                )
                .toList(),
          );
        });
        return created;
      });

  Future<Task?> claimNext({int? identity, Set<TaskAction>? actions}) async =>
      transaction(() async {
        final query = select(tasksTable)
          ..where((tbl) => _identityQuery(tbl, identity))
          ..where((tbl) => tbl.status.equals(TaskStatus.pending.name));
        if (actions != null) {
          query.where((tbl) => tbl.action.isIn(actions.map((e) => e.name)));
        }
        query
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt),
            (t) => OrderingTerm(expression: t.id),
          ])
          ..limit(1);
        final Task? next = await query.getSingleOrNull();
        if (next == null) return null;
        return (update(tasksTable)..where((tbl) => tbl.id.equals(next.id)))
            .writeReturning(
              const TaskCompanion(status: Value(TaskStatus.running)),
            )
            .then((rows) => rows.single);
      });

  Future<void> markCompleted(int id) =>
      (update(tasksTable)..where((tbl) => tbl.id.equals(id))).write(
        TaskCompanion(
          status: const Value(TaskStatus.completed),
          error: const Value(null),
          completedAt: Value(DateTime.now()),
        ),
      );

  Future<void> markFailed(int id, String error) =>
      (update(tasksTable)..where((tbl) => tbl.id.equals(id))).write(
        TaskCompanion(
          status: const Value(TaskStatus.failed),
          error: Value(error),
          completedAt: Value(DateTime.now()),
        ),
      );

  Future<void> markCanceled(int id) =>
      (update(tasksTable)..where((tbl) => tbl.id.equals(id))).write(
        TaskCompanion(
          status: const Value(TaskStatus.canceled),
          error: const Value(null),
          completedAt: Value(DateTime.now()),
        ),
      );

  /// Returns a claimed running task to the pending queue, e.g. when the
  /// controller that claimed it is disposed. Tasks that were canceled or
  /// already finished in the meantime keep their status.
  Future<void> release(int id) =>
      (update(tasksTable)
            ..where((tbl) => tbl.id.equals(id))
            ..where((tbl) => tbl.status.equals(TaskStatus.running.name)))
          .write(const TaskCompanion(status: Value(TaskStatus.pending)));

  Future<int> cancelAll({int? identity}) =>
      (update(tasksTable)
            ..where((tbl) => _identityQuery(tbl, identity))
            ..where(
              (tbl) => tbl.status.isIn(
                [TaskStatus.pending, TaskStatus.running].map((e) => e.name),
              ),
            ))
          .write(
            TaskCompanion(
              status: const Value(TaskStatus.canceled),
              error: const Value(null),
              completedAt: Value(DateTime.now()),
            ),
          );

  Future<int> clear({required Set<TaskStatus> statuses, int? identity}) =>
      (delete(tasksTable)
            ..where((tbl) => _identityQuery(tbl, identity))
            ..where((tbl) => tbl.status.isIn(statuses.map((e) => e.name))))
          .go();

  Future<TaskStatus?> readStatus(int id) async {
    final task = await (select(
      tasksTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return task?.status;
  }

  Future<void> resetRunning({int? identity}) =>
      (update(tasksTable)
            ..where((tbl) => _identityQuery(tbl, identity))
            ..where((tbl) => tbl.status.equals(TaskStatus.running.name)))
          .write(const TaskCompanion(status: Value(TaskStatus.pending)));

  Future<void> remove(int id) => removeAll([id]);

  Future<void> removeAll(List<int>? ids, {int? identity}) {
    final query = delete(tasksTable)
      ..where((tbl) => _identityQuery(tbl, identity));
    if (ids != null) {
      query.where((tbl) => tbl.id.isIn(ids));
    }
    return query.go();
  }

  Future<int> sweep({
    required TaskAction action,
    required TaskStatus status,
    required Duration maxAge,
  }) {
    final threshold = DateTime.now().subtract(maxAge);
    return (delete(tasksTable)
          ..where((tbl) => tbl.action.equals(action.name))
          ..where((tbl) => tbl.status.equals(status.name))
          ..where((tbl) => tbl.completedAt.isSmallerThanValue(threshold)))
        .go();
  }
}
