import 'dart:async';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../frequency.dart';
import 'l10n.dart';

@immutable
class RruleL10nDe extends RruleL10n {
  const RruleL10nDe._();

  static Future<RruleL10nDe> create() async {
    await initializeDateFormatting('de');
    return const RruleL10nDe._();
  }

  static RruleL10nDe createSync() {
    unawaited(initializeDateFormatting('de'));
    return const RruleL10nDe._();
  }

  @override
  String get locale => 'de_DE';

  @override
  String frequencyInterval(Frequency frequency, int interval) {
    String plurals({
      required String one,
      required String accusativeForEvery,
      required String singular,
    }) {
      switch (interval) {
        case 1:
          return one;
        default:
          return '$accusativeForEvery $interval. $singular';
      }
    }

    return {
      Frequency.secondly: plurals(
        one: 'Sekündlich',
        accusativeForEvery: 'Jede',
        singular: 'Sekunde',
      ),
      Frequency.minutely: plurals(
        one: 'Minütlich',
        accusativeForEvery: 'Jede',
        singular: 'Minute',
      ),
      Frequency.hourly: plurals(
        one: 'Stündlich',
        accusativeForEvery: 'Jede',
        singular: 'Stunde',
      ),
      Frequency.daily: plurals(
        one: 'Täglich',
        accusativeForEvery: 'Jeden',
        singular: 'Tag',
      ),
      Frequency.weekly: plurals(
        one: 'Wöchentlich',
        accusativeForEvery: 'Jede',
        singular: 'Woche',
      ),
      Frequency.monthly: plurals(
        one: 'Monatlich',
        accusativeForEvery: 'Jeden',
        singular: 'Monat',
      ),
      Frequency.yearly: plurals(
        one: 'Jährlich',
        accusativeForEvery: 'Jedes',
        singular: 'Jahr',
      ),
    }[frequency]!;
  }

  @override
  String until(DateTime until, Frequency frequency) =>
      ', bis ${formatWithIntl(() => DateFormat.yMMMMEEEEd().add_jms().format(until))}';

  @override
  String count(int count) {
    switch (count) {
      case 1:
        return ', ein Mal';
      case 2:
        return ', zwei Mal';
      default:
        return ', $count Mal';
    }
  }

  @override
  String onInstances(String instances) => 'on the $instances instance';

  @override
  String inMonths(String months, {InOnVariant variant = InOnVariant.simple}) =>
      '${_inVariant(variant)} $months';

  @override
  String inWeeks(String weeks, {InOnVariant variant = InOnVariant.simple}) =>
      '${_inVariant(variant)} the $weeks week of the year';

  String _inVariant(InOnVariant variant) {
    switch (variant) {
      case InOnVariant.simple:
        return 'in';
      case InOnVariant.also:
        return 'that are also in';
      case InOnVariant.instanceOf:
        return 'of';
    }
  }

  @override
  String onDaysOfWeek(
    String days, {
    bool indicateFrequency = false,
    DaysOfWeekFrequency? frequency = DaysOfWeekFrequency.monthly,
    InOnVariant variant = InOnVariant.simple,
  }) {
    assert(variant != InOnVariant.also);

    final frequencyString =
        frequency == DaysOfWeekFrequency.monthly ? 'month' : 'year';
    final suffix = indicateFrequency ? ' of the $frequencyString' : '';
    return '${_onVariant(variant)} $days$suffix';
  }

  @override
  String? get weekdaysString => 'weekdays';
  @override
  String get everyXDaysOfWeekPrefix => 'every ';
  @override
  String nthDaysOfWeek(Iterable<int> occurrences, String daysOfWeek) {
    if (occurrences.isEmpty) return daysOfWeek;

    final ordinals = list(
      occurrences.map(ordinal).toList(),
      ListCombination.conjunctiveShort,
    );
    return 'the $ordinals $daysOfWeek';
  }

  @override
  String onDaysOfMonth(
    String days, {
    DaysOfVariant daysOfVariant = DaysOfVariant.dayAndFrequency,
    InOnVariant variant = InOnVariant.simple,
  }) {
    final suffix = {
      DaysOfVariant.simple: '',
      DaysOfVariant.day: ' day',
      DaysOfVariant.dayAndFrequency: ' day of the month',
    }[daysOfVariant];
    return '${_onVariant(variant)} the $days$suffix';
  }

  @override
  String onDaysOfYear(
    String days, {
    InOnVariant variant = InOnVariant.simple,
  }) =>
      '${_onVariant(variant)} the $days day of the year';

  String _onVariant(InOnVariant variant) {
    switch (variant) {
      case InOnVariant.simple:
        return 'on';
      case InOnVariant.also:
        return 'that are also';
      case InOnVariant.instanceOf:
        return 'of';
    }
  }

  @override
  String list(List<String> items, ListCombination combination) {
    String two;
    String end;
    switch (combination) {
      case ListCombination.conjunctiveShort:
        two = ' & ';
        end = ' & ';
        break;
      case ListCombination.conjunctiveLong:
        two = ' and ';
        end = ', and ';
        break;
      case ListCombination.disjunctive:
        two = ' or ';
        end = ', or ';
        break;
    }
    return RruleL10n.defaultList(items, two: two, end: end);
  }

  @override
  String ordinal(int number) {
    assert(number != 0);
    if (number == -1) return 'last';

    final n = number.abs();
    String string;
    if (n % 10 == 1 && n % 100 != 11) {
      string = '${n}st';
    } else if (n % 10 == 2 && n % 100 != 12) {
      string = '${n}nd';
    } else if (n % 10 == 3 && n % 100 != 13) {
      string = '${n}rd';
    } else {
      string = '${n}th';
    }

    return number < 0 ? '$string-to-last' : string;
  }
}
