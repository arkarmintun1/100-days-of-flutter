/// What kind of thing went wrong, so the UI can show the right icon and
/// only offer "Try again" when trying again can help.
enum ErrorKind {
  /// No internet, or the connection timed out.
  network,

  /// HTTP 429: the Pexels rate limit was reached.
  rateLimited,

  /// HTTP 401: the API key is missing or wrong.
  unauthorized,

  /// HTTP 404: the photo (or page) doesn't exist.
  notFound,

  /// HTTP 5xx: a problem on the server's side.
  server,

  /// Anything else, e.g. another HTTP status or JSON with an unexpected
  /// shape.
  unknown;

  /// Whether the problem may go away by itself in a few seconds (a flaky
  /// connection, a busy server), so the app can try again on its own.
  /// A rate limit or a wrong API key won't, so retrying would only waste
  /// requests.
  bool get mayFixItself => switch (this) {
    network || server => true,
    rateLimited || unauthorized || notFound || unknown => false,
  };

  /// Whether pressing "Try again" might work.
  bool get canRetry => switch (this) {
    unauthorized || notFound => false,
    network || rateLimited || server || unknown => true,
  };
}
