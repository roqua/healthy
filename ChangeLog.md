### 1.2.1

* Improved heuristic to pick cell phone numbers out of commonly used hl7 messages

### 1.2.0

* Added support for MEDOQ hl7 a19 identities encoded in JSON

### 1.1.9

* Handle upgraded mirth error messages

### 1.1.8

* Handle new Impulse/User name format

### 1.1.7

* Bumped roqua-support to 0.1.18 to use Roqua.stats (through with_instrumentation)

### 1.1.6

* For CDIS name parser, now return last name that includes maiden name

### 1.1.5

* Added support for QAK segments that signal that a patient record was not found

### 1.1.4

* Better handling for 403 and 404 responses.

### 1.1.3

* No idea. Someone forgot to update changelog

### 1.1.2

* Fall back to PID.13.1 for cell_phone when type is undefined

### 1.1.1

* Added `Roqua::Healthy::Error` and `Roqua::Healthy::ConnectionError` base classes for exceptions
  thrown by Healthy.

### 1.1.0 / 2014-01-29

* Added possibility to work with more than one endpoint simultaneously through `Roqua::Healthy::Client`.

### 1.0.1

* Made compatible with ActiveSupport 4.x

### 1.0.0 / 2014-01-22

* Released under the name 'roqua-healthy' to work around name collision on Rubygems.org.
  This new name also makes it clearer that this gem is probably not very useful to others.
  Note that everything is now nested under the Roqua::Healthy module instead of Healthy.

### 0.1.0 / 2013-09-24

* Initial release:

