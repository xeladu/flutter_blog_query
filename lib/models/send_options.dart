class SendOptions {
  final bool includeDescriptions;
  final bool includeTags;
  final bool includeDates;

  SendOptions(this.includeDescriptions, this.includeTags, this.includeDates);

  SendOptions.def() : this(true, true, true);
}
