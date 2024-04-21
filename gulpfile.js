import gulp from "gulp";
import concat from "gulp-concat";
import cleanCss from "gulp-clean-css";
import uglify from "gulp-uglify-es";
// Broken; Is not producting valid images
// import imagemin from "gulp-imagemin";
import pump from "pump";
import fs from 'fs';
import path from 'path';

function copyFiles(srcPath, destPath) {
  return new Promise((resolve, reject) => {
    fs.readdir(srcPath, (err, files) => {
      if (err) {
        console.error(`Error reading directory ${srcPath}`, err);
        reject(err);
        return;
      }

      files.forEach(file => {
        const srcFile = path.join(srcPath, file);
        const destFile = path.join(destPath, file);

        fs.stat(srcFile, (err, stat) => {
          if (err) {
            console.error(`Error getting stats for file ${srcFile}`, err);
            reject(err);
            return;
          }

          if (stat.isDirectory()) {
            fs.mkdir(destFile, { recursive: true }, (err) => {
              if (err) {
                console.error(`Error creating directory ${destFile}`, err);
                reject(err);
                return;
              }

              copyFiles(srcFile, destFile).then(resolve).catch(reject);
            });
          } else {
            fs.mkdir(path.dirname(destFile), { recursive: true }, (err) => {
              if (err) {
                console.error(`Error creating directory for file ${destFile}`, err);
                reject(err);
                return;
              }

              fs.copyFile(srcFile, destFile, (err) => {
                if (err) {
                  console.error(`Error copying file ${srcFile} to ${destFile}`, err);
                  reject(err);
                  return;
                }

                resolve();
              });
            });
          }
        });
      });
    });
  });
}

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
  const srcPath = 'src/images';
  const destPath = 'assets/images';

  return copyFiles(srcPath, destPath);
}

function watch() {
  gulp.watch("src/*.css", css);
  gulp.watch("src/*.js", js);
  gulp.watch("src/images/**/*.{jpg,png,svg}", images);
}

export default series(css, css_desktop, js, fonts, images);
export const watchTask = series(watch);