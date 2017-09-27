require 'rails_helper'

class Presenter
  def present(text)
    puts text
  end
end

class Person
  def display(box)
    Presenter.new.present(box.name)
  end
end

def our_double(_name, methods)
  object = Object.new
  methods.each { |key, value| object.define_singleton_method(key) { value } }
  object
end

describe 'double test' do
  xit 'learn how double works' do
    box_double = our_double('Box', name: 'Secret')
    expect_any_instance_of(Presenter).to receive(:present).with('Secret')
    Person.new.display(box_double)
  end
end
