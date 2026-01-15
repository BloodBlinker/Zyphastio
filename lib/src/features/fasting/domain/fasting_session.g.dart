// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasting_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFastingSessionCollection on Isar {
  IsarCollection<FastingSession> get fastingSessions => this.collection();
}

const FastingSessionSchema = CollectionSchema(
  name: r'FastingSession',
  id: -2153100464674934738,
  properties: {
    r'endTime': PropertySchema(
      id: 0,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'protocolLabel': PropertySchema(
      id: 1,
      name: r'protocolLabel',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 2,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'targetDurationMinutes': PropertySchema(
      id: 3,
      name: r'targetDurationMinutes',
      type: IsarType.long,
    )
  },
  estimateSize: _fastingSessionEstimateSize,
  serialize: _fastingSessionSerialize,
  deserialize: _fastingSessionDeserialize,
  deserializeProp: _fastingSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _fastingSessionGetId,
  getLinks: _fastingSessionGetLinks,
  attach: _fastingSessionAttach,
  version: '3.1.0+1',
);

int _fastingSessionEstimateSize(
  FastingSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.protocolLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _fastingSessionSerialize(
  FastingSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endTime);
  writer.writeString(offsets[1], object.protocolLabel);
  writer.writeDateTime(offsets[2], object.startTime);
  writer.writeLong(offsets[3], object.targetDurationMinutes);
}

FastingSession _fastingSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FastingSession();
  object.endTime = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.protocolLabel = reader.readStringOrNull(offsets[1]);
  object.startTime = reader.readDateTimeOrNull(offsets[2]);
  object.targetDurationMinutes = reader.readLongOrNull(offsets[3]);
  return object;
}

P _fastingSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fastingSessionGetId(FastingSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _fastingSessionGetLinks(FastingSession object) {
  return [];
}

void _fastingSessionAttach(
    IsarCollection<dynamic> col, Id id, FastingSession object) {
  object.id = id;
}

extension FastingSessionQueryWhereSort
    on QueryBuilder<FastingSession, FastingSession, QWhere> {
  QueryBuilder<FastingSession, FastingSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FastingSessionQueryWhere
    on QueryBuilder<FastingSession, FastingSession, QWhereClause> {
  QueryBuilder<FastingSession, FastingSession, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FastingSessionQueryFilter
    on QueryBuilder<FastingSession, FastingSession, QFilterCondition> {
  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      endTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'protocolLabel',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'protocolLabel',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protocolLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'protocolLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'protocolLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protocolLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      protocolLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'protocolLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      startTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      startTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      startTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      targetDurationMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetDurationMinutes',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      targetDurationMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetDurationMinutes',
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      targetDurationMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      targetDurationMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      targetDurationMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterFilterCondition>
      targetDurationMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FastingSessionQueryObject
    on QueryBuilder<FastingSession, FastingSession, QFilterCondition> {}

extension FastingSessionQueryLinks
    on QueryBuilder<FastingSession, FastingSession, QFilterCondition> {}

extension FastingSessionQuerySortBy
    on QueryBuilder<FastingSession, FastingSession, QSortBy> {
  QueryBuilder<FastingSession, FastingSession, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      sortByProtocolLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolLabel', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      sortByProtocolLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolLabel', Sort.desc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      sortByTargetDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      sortByTargetDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDurationMinutes', Sort.desc);
    });
  }
}

extension FastingSessionQuerySortThenBy
    on QueryBuilder<FastingSession, FastingSession, QSortThenBy> {
  QueryBuilder<FastingSession, FastingSession, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      thenByProtocolLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolLabel', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      thenByProtocolLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protocolLabel', Sort.desc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      thenByTargetDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QAfterSortBy>
      thenByTargetDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDurationMinutes', Sort.desc);
    });
  }
}

extension FastingSessionQueryWhereDistinct
    on QueryBuilder<FastingSession, FastingSession, QDistinct> {
  QueryBuilder<FastingSession, FastingSession, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<FastingSession, FastingSession, QDistinct>
      distinctByProtocolLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protocolLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FastingSession, FastingSession, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<FastingSession, FastingSession, QDistinct>
      distinctByTargetDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDurationMinutes');
    });
  }
}

extension FastingSessionQueryProperty
    on QueryBuilder<FastingSession, FastingSession, QQueryProperty> {
  QueryBuilder<FastingSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FastingSession, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<FastingSession, String?, QQueryOperations>
      protocolLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protocolLabel');
    });
  }

  QueryBuilder<FastingSession, DateTime?, QQueryOperations>
      startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<FastingSession, int?, QQueryOperations>
      targetDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDurationMinutes');
    });
  }
}
