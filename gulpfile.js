"use strict";

var gulp = require('gulp');
var livereload = require('gulp-livereload');

gulp.task('watch', function() {
  livereload.listen();
  gulp.watch('*.html')
    .on('change', livereload.changed);
});

/*
 * Simple reload gulpfile, here's the reload tag:
  <script src="http://joes-mbp.local:35729/livereload.js"></script>
 */
