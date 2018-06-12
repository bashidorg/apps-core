var gulp         = require("gulp"),
    sass         = require("gulp-sass"),
    autoprefixer = require("gulp-autoprefixer"),
    hash         = require("gulp-hash"),
    del          = require("del")

gulp.task("scss", function () {
    del(["themes/osprey/static/styles/*.css"])
    gulp.src("themes/osprey/static/styles/scss/main.scss")
        .pipe(sass({outputStyle : "compressed"}))
        .pipe(autoprefixer({browsers : ["last 20 versions"]}))
        .pipe(hash())
        .pipe(gulp.dest("themes/osprey/static/styles/"))
        .pipe(hash.manifest("cachedAssets.json"))
        .pipe(gulp.dest("data"))
})

gulp.task("watch", ["scss"], function () {
    gulp.watch("themes/osprey/static/styles/scss/*", ["scss"])
})

gulp.task("deploy", ["scss"])