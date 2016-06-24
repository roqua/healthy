# Healthy [![Code Climate](https://codeclimate.com/repos/524944dd56b10217490074e8/badges/5dd696b69c4614c83c2d/gpa.png)](https://codeclimate.com/repos/524944dd56b10217490074e8/feed) [![CircleCi](https://circleci.com/gh/roqua/healthy.png?circle-token=ece8f36798b00bc8659d5c76f720b22693d6600a)](https://circleci.com/gh/roqua/healthy)

## Patient details aka QRY\^A19

### Usage

```ruby
Healthy::A19.fetch(patient_identifier)
```

or if you need multiple configurations

```ruby
client = Healthy::A19::Client(a19_endpoint: 'https://...')
client.fetch_a19(patient_identifier)
```

### Adding integration tests

If you find any A19 response that Healthy currently does not handle correctly, please add a fixture and integration test for it.

* `curl --data "method=A19&application=healthy&patient_id=7767853" "http://10.20.11.100:60401"`
* Paste the resulting XML into a new file in `spec/fixtures`. Name this after the specific thing that is different, prefixed with the originating EPD. Don't name this after a specific organization, this repository is open-sourced and our customers might not want to be named publicly here.
* Please run it through an XML pretty printer like `xmllint --format` to get indented output.
* **&lt;blink&gt;Remove/sanitize/anonymize the XML file where needed.&lt;/blink&gt;** We can't do this automatically with a script, because having a script normalize e.g. all names to "Voornaam Achternaam" would defeat the entire point of having multiple fixtures to show the different styles of names we can encounter.
* Add an integration spec example that uses it and checks all currently returned values.

### Manually trying out parsing of a given record

There are two helpers in `bin`: `get_xml_for_patient` and `parse_local_xml`. The first one takes a patient number and ip+port on the mirth machine, and gets the XML from there. The second parses a chunk of XML from either standard input or a given file.

These two commands are then chained together by `bin/get`:

`bin/get 7767853 10.20.11.100:60201` NB: replace with the ip and port of the a19 channel you want to use

## Copyright

Copyright (c) 2016 Marten Veldthuis, Jorn van de Beek, Samuel Esposito, Henk van der Veen
Publicly available under an MIT license. See [LICENSE.txt](https://github.com/roqua/healthy/blob/master/LICENSE.txt) for details.
