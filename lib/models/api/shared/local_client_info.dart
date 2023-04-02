class LocalClientInfo {
  final int? clientId;
  final String? clientToken;

  LocalClientInfo(this.clientId, this.clientToken);

  Map<String, String?> toJson() => {
        "client_id": clientId.toString(),
        "client_token": clientToken,
      };
}
