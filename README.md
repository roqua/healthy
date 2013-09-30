# Healthy [![Code Climate](https://codeclimate.com/repos/524944dd56b10217490074e8/badges/5dd696b69c4614c83c2d/gpa.png)](https://codeclimate.com/repos/524944dd56b10217490074e8/feed) [![CircleCi](https://circleci.com/gh/roqua/healthy.png?circle-token=ece8f36798b00bc8659d5c76f720b22693d6600a)](https://circleci.com/gh/roqua/healthy)

## Adding integration tests

* `curl --data "method=A19&application=healthy&patient_id=7767853" "http://10.20.11.100:60401"`
* Paste the resulting XML into a new file in `spec/fixtures`
* Please run it through an XML pretty printer like `xmllint --format` to get indented output.
* Remove/sanitize/anonymize the XML file where needed.
* Add an integration spec example that uses it and checks all currently returned values.

## Copyright

Copyright (c) 2013 Marten Veldthuis. Publicly available under an MIT license. See [LICENSE.txt](https://github.com/roqua/healthy/blob/master/LICENSE.txt) for details.
