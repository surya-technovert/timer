sealed class Result<S> {
  const Result();
}

final class Success<S> extends Result<S> {
  const Success(this.value);
  final S value;
}

final class Failure<S> extends Result<S> {
  const Failure(this.exception, this.stackTrace);
  final Exception exception;
  final StackTrace stackTrace;
}

final class Loading<S> extends Result<S> {}
