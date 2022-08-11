class Countdown {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  Countdown(this.days, this.hours, this.minutes, this.seconds);
  const Countdown.zero(
      {this.days = 0, this.hours = 0, this.minutes = 0, this.seconds = 0});
}

extension CountdownExtension on Countdown {
  String get displayLetters {
    return "${days}D ${hours}H ${minutes}M ${seconds}S";
  }
}
