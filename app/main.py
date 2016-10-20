def application(env, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [b"<b>Hola, soy un ejemplo de aplicacion corriendo en Docker</b>"]
