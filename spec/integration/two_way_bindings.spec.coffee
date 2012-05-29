{Serenade} = require '../../src/serenade'

describe 'Two-way bindings', ->
  beforeEach ->
    @setupDom()

  it 'updates plain model when event triggers', ->
    model = {}
    @render 'input[type="text" binding:keyup=name]', model, {}
    input = @body.find('input').get(0)
    input.value = "Test"
    @fireEvent input, "keyup"
    expect(model.name).toEqual("Test")

  it 'updates serenade model when event triggers', ->
    class MyModel extends Serenade.Model
      @property 'name'
    model = new MyModel()
    @render 'input[type="text" binding:keyup=name]', model, {}
    input = @body.find('input').get(0)
    input.value = "Test"
    @fireEvent input, "keyup"
    expect(model.name).toEqual("Test")

  it 'sets value of input to models value', ->
    model = {name: "My name"}
    @render 'input[type="text" binding:keyup=name]', model, {}
    input = @body.find('input').get(0)
    expect(input.value).toEqual("My name")

  it 'sets value of textarea to models value', ->
    model = {name: "My name"}
    @render 'textarea[binding:keyup=name]', model, {}
    input = @body.find('textarea').get(0)
    expect(input.value).toEqual("My name")

  it 'updates the value of input when model changes', ->
    class MyModel extends Serenade.Model
      @property 'name'
    model = new MyModel({name: "My name"})
    @render 'input[type="text" binding:keyup=name]', model, {}
    model.set("name", "Changed name")
    input = @body.find('input').get(0)
    expect(input.value).toEqual("Changed name")

  it 'rejects none-input elements', ->
    expect(=> @render 'div[binding:keyup=name]', {}, {}).toThrow()

  # Note: Jasmine seems to set input.value to "" when we set it to undefined.
  # Actual browsers will set it to "undefined".
  it 'sets value to empty string when model property is undefined', ->
    model = {name: undefined}
    @render 'input[type="text" binding:change=name]', model
    input = @body.find("input").get(0)
    expect(input.value).toEqual("")