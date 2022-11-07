load("../other/other.star", "dummy")

def greeting(name):
  dummy()

  return "Hello, {}!".format(name)
