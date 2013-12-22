module.exports = function(grunt) {

    // 1. CONFIG
    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),

        jshint: {
            options: {
                reporter: require("jshint-stylish"),

                globals: {
                    console:    true,
                    $:          true,
                    jQuery:     true,
                }
            },

            target: ["/.bigfoot.js"]
        },

        uglify: {
            build: {
                src: "./bigfoot.js",
                dest: "./bigfoot.min.js"
            }
        },

        sass: {
            dist: {
                options: { style: "compressed" },

                files: {
                    "styles/bigfoot-bottom/bigfoot-bottom.css": "styles/bigfoot-bottom/bigfoot-bottom.scss",
                    "styles/bigfoot-daring/bigfoot-daring.css": "styles/bigfoot-daring/bigfoot-daring.scss",
                    "styles/bigfoot-default/bigfoot-default.css": "styles/bigfoot-default/bigfoot-default.scss",
                    "styles/bigfoot-hypercritical/bigfoot-hypercritical.css": "styles/bigfoot-hypercritical/bigfoot-hypercritical.scss",
                    "styles/bigfoot-number/bigfoot-number.css": "styles/bigfoot-number/bigfoot-number.scss"
                }
            }
        },

        autoprefixer: {
            dist: {
                files: {
                    "styles/bigfoot-bottom/bigfoot-bottom.css": "styles/bigfoot-bottom/bigfoot-bottom.css",
                    "styles/bigfoot-daring/bigfoot-daring.css": "styles/bigfoot-daring/bigfoot-daring.css",
                    "styles/bigfoot-default/bigfoot-default.css": "styles/bigfoot-default/bigfoot-default.css",
                    "styles/bigfoot-hypercritical/bigfoot-hypercritical.css": "styles/bigfoot-hypercritical/bigfoot-hypercritical.css",
                    "styles/bigfoot-number/bigfoot-number.css": "styles/bigfoot-number/bigfoot-number.css"
                }
            }
        },

        watch: {
            options: { livereload: false },

            js: {
                files: ["./bigfoot.js"],
                tasks: ["uglify", "jshint"],
                options: { spawn: false }
            },

            scss: {
                files: ["styles/*/*.scss"],
                tasks: ["sass"],
                options: { spawn: false }
            },

            css: {
                files: ["styles/*/*.css"],
                tasks: ["autoprefixer"],
                options: { spawn: false }
            }
        },

    });

    // 2. TASKS
    require("load-grunt-tasks")(grunt);

    // 3. PERFORM
    grunt.registerTask("default", ["jshint", "autoprefixer", "uglify", "sass", "watch"]);

}