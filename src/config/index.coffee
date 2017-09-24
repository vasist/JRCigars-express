path = require 'path'
express_init = require './express'
rootPath = path.normalize(__dirname + '/..')
env = process.env.NODE_ENV || 'development'

config =
    root: rootPath
    app:
      name: 'appname'
    port: 3000
    db: 'mongodb://localhost/test-development'
    viewPath: rootPath+'/views'
    publicPath: rootPath+'/public'

config.init = (app) -> express_init(app, config)

module.exports = config