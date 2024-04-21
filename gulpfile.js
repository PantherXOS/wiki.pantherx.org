import gulp from "gulp";
import concat from "gulp-concat";
import cleanCss from "gulp-clean-css";
import uglify from "gulp-uglify-es";
import imagemin from "gulp-imagemin";
import pump from "pump";

const { series, src, dest } = gulp;

function css() {
  return src([
      "node_modules/bulma/css/bulma.min.css",
      "src/prism.css",
      "src/panther.css",
      "src/custom.css",
    ])
    .pipe(concat("custom.min.css"))
    .pipe(cleanCss())
    .pipe(dest("assets/css"));
}

function css_desktop() {
  return src([
      "node_modules/bulma/css/bulma.min.css",
      "src/prism.css",
      "src/panther.css",
      "src/custom.css",
      "src/custom_desktop.css",
    ])
    .pipe(concat("custom_desktop.min.css"))
    .pipe(cleanCss())
    .pipe(dest("assets/css"));
}

function js(cb) {
  pump(
    [
      src([
        "node_modules/vue/dist/vue.js",
        "node_modules/lunr/lunr.js",
        "src/prism.js",
        "src/mermaid.min.js",
        "src/custom.js",
      ]),
      concat("bundle.min.js"),
      uglify.default(),
      dest("assets/js"),
    ],
    cb
  );
}

function fonts() {
  return src("src/fonts/**/*").pipe(dest("assets/fonts"));
}

function images() {
  return src("src/images/**/*")
    .pipe(imagemin())
    .pipe(dest("assets/images"));
}

function watch() {
  gulp.watch("src/*.css", css);
  gulp.watch("src/*.js", js);
  gulp.watch("src/images/**/*.{jpg,png,svg}", images);
}

export default series(css, css_desktop, js, fonts, images);
export const watchTask = series(watch);