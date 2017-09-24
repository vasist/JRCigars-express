gulp = require 'gulp'
coffee = require 'gulp-coffee'
clean = require 'gulp-clean'
es = require 'event-stream' #Used for merging sources
livereload = require 'gulp-livereload'
nodemon = require 'gulp-nodemon'

paths =
  coffee_server: ['src/**/*.coffee', '!src/public/**/*.coffee']
  coffee_client: ['src/public/**/*.coffee']
  views: ['src/views/**/*.jade', 'src/views/**/*.ejs', 'src/**/*.css']
  css: ['src/style/*.css']
  all: ['src/**/*.js', 'src/**/*.json', 'src/**/*.html']
  build: './build'
  vendor_src: ['bower_components/bootstrap/dist/**/*.*']
  vendorjs_src: ['bower_components/jquery/dist/*.js']

server = livereload()

#default task - build project
gulp.task 'default', ['build']
gulp.task 'build', ['coffee', 'views', 'css', 'all', 'vendor']
gulp.task 'dev', ['build', 'watch', 'liveupdate']

#update server side scripts
gulp.task 'coffee_server', ->
  pipe_coffee paths.coffee_server, paths.build, bare: true


#update client side scripts
gulp.task 'coffee_client', ->
  pipe_coffee paths.coffee_client, paths.build + '/public'

gulp.task 'coffee', ['coffee_server', 'coffee_client']


#update server side view
gulp.task 'views', ->
  gulp.src paths.views
    .pipe gulp.dest paths.build + '/views'

gulp.task 'css', ->
  gulp.src paths.css
    .pipe gulp.dest paths.build + '/style'

gulp.task 'all', ->
  gulp.src paths.all
    .pipe gulp.dest paths.build, bare: true


#update the client vendor scripts and styles. Ex: bootstrap, jquery, etc.
gulp.task 'vendor', (cb)->
  es.merge(
    gulp.src(paths.vendor_src)
      .pipe gulp.dest paths.build + '/public/lib'
  ,
    gulp.src paths.vendorjs_src
      .pipe gulp.dest paths.build + '/public/lib/js'
  )


#watch all folders and build the projects as file changes is made.
gulp.task 'watch', ->
  gulp.watch paths.coffee_server, ['coffee_server']
  gulp.watch paths.coffee_client, ['coffee_client']
  gulp.watch paths.views, ['views']


#clean the build folder.
gulp.task 'clean', ->
  gulp.src(paths.build + "/", read: false)
    .pipe(clean())


gulp.task 'liveupdate', ->
  nodemon
    script: './build/app.js',
    watch: 'src',
    ext: 'coffee',
    ignore: ['./build/public/**', './build/views/**'],
    delay: 2

  gulp.watch([paths.build + '/public/**', paths.build + '/views/**'])
    .on 'change', (file)->
  console.log('client in folder changed ' + file.path)
  server.changed(file.path)


#helper functions

pipe_coffee = (source, dest, options) ->
  gulp.src source
    .pipe coffee(options)
    .pipe gulp.dest dest