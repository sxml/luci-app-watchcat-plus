log = SimpleForm("logview")
log.submit = false
log.reset = false

t = log:field(DummyValue, '', '')
t.rawhtml = true
t.template = 'watchcat-plus/log'

return log