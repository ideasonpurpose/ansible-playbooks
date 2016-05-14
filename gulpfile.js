var os = require('os');
var gulp = require('gulp');
var gutil = require('gulp-util');
var chalk = gutil.colors;
var sass = require('gulp-sass');
var rename = require('gulp-rename');
var clone = require('gulp-clone');
var mergeStream = require('merge-stream');
var inlinesource = require('gulp-inline-source');
var prettify = require('gulp-jsbeautifier');
var nunjucksRender = require('gulp-nunjucks-render');
var faker = require('faker');
var browserSync = require('browser-sync').create();

gulp.task('styles', function() {
  return gulp.src('./templates/src/styles.scss')
  .pipe(sass({
    outputStyle: 'expanded'
  })
    .on('data', function(data) {
      gutil.log('Sass: compiled', chalk.cyan(data.relative));
    })
    .on('error', sass.logError))
  .pipe(gulp.dest('./templates/preview'))
  .pipe(browserSync.stream());
});


gulp.task('build', ['styles'], function() {
  var fakeData = {
    fullname: faker.name.findName(),
    title: faker.name.jobTitle(),
    username: faker.name.firstName().toLowerCase(),
    password: faker.internet.password(9),
    wifi_password: faker.internet.password(9),
    fileserver_address: 'smb://' + faker.internet.domainName(),
    webmail_url: 'http://mail.' + faker.internet.domainName(),
    google_apps_url: 'http://docs.' + faker.internet.domainName()
  };

  var templateBase = gulp.src('./templates/src/welcome*.html.j2')
    .pipe(prettify());

  var template = templateBase
    .pipe(clone())
    .pipe(inlinesource({ rootpath: './templates/preview' }))
    .pipe(gulp.dest('./templates'))
    .on('data', function(data) {
      gutil.log('Generated template', chalk.cyan(data.relative));
    });

  var preview = templateBase
    .pipe(nunjucksRender({ data: fakeData }))
    .pipe(rename(function(path) {
      path.basename = path.basename.replace('welcome', 'index');
      path.extname = '';  // seems like a bug, basename still has the extension
    }))
    .pipe(gulp.dest('./templates/preview'))
    .pipe(browserSync.stream())
    .on('data', function(data) {
      gutil.log('Rendered preview template', chalk.cyan(data.relative));
    });

  return mergeStream(template, preview);
});


gulp.task('watch', ['build'], function() {
  browserSync.init({
    host: os.hostname().toLowerCase().replace(/(\.local)*$/, '.local'),
    open: false,
    logConnections: true,
    logPrefix: 'BrowserSync',
    server: './templates/preview'
  });
  gulp.watch('./templates/src/*.html.j2', ['build']);
  gulp.watch('./templates/src/*.scss', ['styles']);
});
