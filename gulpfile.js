var gulp = require('gulp');
var concat = require('gulp-concat');
var cleanCss = require('gulp-clean-css');
var uglify = require('gulp-uglify-es').default;
const imagemin = require('gulp-imagemin');
var pump = require('pump');

const { series } = require('gulp');
const { src, dest } = require('gulp');

function css() {
	return gulp.src
    ([
	  	'node_modules/bulma/css/bulma.min.css',
	    'src/prism.css',
	    'src/panther.css',
	  	'src/custom.css'
    ])
    .pipe(concat('custom.min.css'))
    .pipe(cleanCss())
    .pipe(gulp.dest('assets/css'));
}

function js(cb) {
	pump([
			gulp.src
			([
				'node_modules/vue/dist/vue.js',
				'node_modules/lunr/lunr.js',
				'src/prism.js',
				'src/custom.js'
			]),
			concat('bundle.min.js'),
			uglify(),
			gulp.dest('assets/js')
		],
		cb
	);
}

function images() {
	return gulp.src('src/images/**/*')
		.pipe(imagemin())
		.pipe(gulp.dest('assets/images'))
}

function watch() {
	gulp.watch('src/*.css', ['css']);
	gulp.watch('src/*.js', ['js']);
	gulp.watch('src/images/**/*.{jpg,png,svg}', ['images']);
}

exports.default = series(css, js, images)
exports.watch = series(watch)
