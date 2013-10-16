module Healthy
  class UnknownFailure < StandardError; end
  class IllegalMirthResponse < StandardError; end
  class PatientIdNotInRemote < StandardError; end
  class Timeout < StandardError; end
  class HostUnreachable < StandardError; end
  class ConnectionRefused < StandardError; end
end
