#### Express + MongoDB + Jade + CoffeeScript + Gulp Application
#### Passport login 
#### Author : Eshwar 

Technology
-----------
* gulp: http://gulpjs.com/
	
* express: http://expressjs.com/
	
* coffescript: http://coffeescript.org/	

Getting Started
---------------

... 'src' : This folder contains the coffescript and jade template. 
... 'build': this folder is genetated after running 'gulp' 

```sh
	npm install
```
Make sure Gulp is installed globally then run 'gulp'  this will compile and copy coffeescript/jade files to the new folder called 'build';	

```sh
gulp
```

```sh
cd build
// to run the application
$ node app.js
(or)
$ nodemon app.js // make sure nodemon package is installed globally
```

to compile the application into the build application run
```sh
	gulp
```	

to watch files for changes and automatically update the build folder run
```sh	
	gulp watch
```	
