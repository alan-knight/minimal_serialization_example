library minimal_serialization_example;

import "package:serialization/serialization.dart";
import "package:minimal_serialization_example/test_models.dart";
import "package:minimal_serialization_example/test_models_serialization_rules.dart";
import "package:unittest/unittest.dart";

var thing1 = new Thing()
  ..name = "thing1"
  ..howMany = 42
  ..things = ["one", "two", "three"];

var thing2 = new OtherThing()
  ..a = 1
  ..b = 2
  ..c = {"something" : "orother"}
  ..map = {"a" : "A"};

main() {

  var serialization1 = new Serialization();
  rules.values.forEach(serialization1.addRule);
  writer() =>
    serialization1.newWriter(new SimpleJsonFormat(storeRoundTripInfo: true));

  var serialization2 = new Serialization();
  rules.values.forEach(serialization2.addRule);
  reader() =>
      serialization2.newReader(new SimpleJsonFormat(storeRoundTripInfo: true));

  test("Write and Read Thing", () {
    var written = writer().write(thing1);
    var read = reader().read(written);
    expect(read is Thing, isTrue);
    expect(read.name, "thing1");
    expect(read.howMany, 42);
    expect(read.things, ["one", "two", "three"]);
  });

  test("Write and Read Other Thing", () {
    var written = writer().write(thing2);
    var read = reader().read(written);
    expect(read is OtherThing, isTrue);
    expect(read.a, 1);
    expect(read.b, 2);
    expect(read.c, {"something" : "orother"});
    expect(read.map, {"a" : "A"});
  });

  test("Nested", () {
    var nested = new Thing()
      ..name = "nested"
      ..howMany = 1
      ..things = [thing1, thing2];
    var written = writer().write(nested);
    var read = reader().read(written);
    expect(read.things.first is Thing, isTrue);
    expect(read.things.last is OtherThing, isTrue);
    expect(read.things.first.name, "thing1");
    expect(read.things.last.map, {"a" : "A"});

  });
}
