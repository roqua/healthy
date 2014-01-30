module Roqua
  module Healthy
    class Error < StandardError; end
    class ConnectionError < Error; end

    class IllegalMirthResponse < ConnectionError; end
    class Timeout < ConnectionError; end
    class HostUnreachable < ConnectionError; end
    class ConnectionRefused < ConnectionError; end

    class UnknownFailure < Error; end
    class PatientIdNotInRemote < Error; end
    class PatientNotFound < Error; end

    module MirthErrors
      class WrongPatient < Error; end
    end
  end
end
