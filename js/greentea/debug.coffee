
class A extends Ajax.Request

  constructor: ( url, @form ) -> super url

  initial: => @form.disable()
  final: => @form.enable()

  success: (json) =>
    if json.success == true
      e = document.querySelector 'p'
      e.innerHTML = json.data.message
      Log.warn json.data.message
    else
      alert json.data.message




class F extends Form

  submit: (Ev) =>
    try
      Event.Form.stop Ev
      a = new A 'http://dev/greentea/sample.login.py', @
      a.send @serialize()
    catch E
      Log.error E.message





try
  Log.warn 'What ever'
  new F 'form'
catch E
  Log.error E.message
