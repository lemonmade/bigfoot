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

            target: ["src/bigfoot.js"]
        },

        uglify: {
            build: {
                src: "src/bigfoot.js",
                dest: "dist/bigfoot.min.js"
            }
        },

        concat: {
            options: {
                stripBanners: true,
                banner: "// <%= pkg.name %> - v<%= pkg.version %> - " +
                        "<%= grunt.template.today(\"yyyy.mm.dd\") %>\n\n\n",
                separator: "\n\n\n// -----\n\n\n"
            },

            main: {
                src: ["src/_mixins/_bigfoot-mixins.scss", "src/_*/*-default.scss"],
                dest: "dist/bigfoot-default.scss"
            },

            number: {
                src: ["src/_mixins/_bigfoot-mixins.scss", "src/_*/*-number.scss", "src/_popovers/_popover-default.scss"],
                dest: "dist/bigfoot-number.scss"
            },

            daring: {
                src: ["src/_mixins/_bigfoot-mixins.scss", "src/_*/*-daring.scss"],
                dest: "dist/bigfoot-daring.scss"
            },

            hypercritical: {
                src: ["src/_mixins/_bigfoot-mixins.scss", "src/_*/*-hypercritical.scss"],
                dest: "dist/bigfoot-hypercritical.scss"
            },

            bottom: {
                src: ["src/_mixins/_bigfoot-mixins.scss", "src/_buttons/_button-default.scss", "src/_*/*-bottom.scss"],
                dest: "dist/bigfoot-bottom.scss"
            },
        },

        sass: {
            dist: {
                options: { style: "expanded", loadPath: require("node-bourbon").includePaths },

                files: {
                    "dist/bigfoot-bottom.css": "dist/bigfoot-bottom.scss",
                    "dist/bigfoot-daring.css": "dist/bigfoot-daring.scss",
                    "dist/bigfoot-default.css": "dist/bigfoot-default.scss",
                    "dist/bigfoot-hypercritical.css": "dist/bigfoot-hypercritical.scss",
                    "dist/bigfoot-number.css": "dist/bigfoot-number.scss"
                }
            }
        },

        autoprefixer: {
            dist: {
                files: {
                    "dist/bigfoot-bottom.css": "dist/bigfoot-bottom.css",
                    "dist/bigfoot-daring.css": "dist/bigfoot-daring.css",
                    "dist/bigfoot-default.css": "dist/bigfoot-default.css",
                    "dist/bigfoot-hypercritical.css": "dist/bigfoot-hypercritical.css",
                    "dist/bigfoot-number.css": "dist/bigfoot-number.css"
                }
            }
        },

        shell: {
            copyMain: {
                command: 'cp src/bigfoot.js dist/bigfoot.js'
            }
        },

        watch: {
            options: { livereload: false },

            js: {
                files: ["src/bigfoot.js"],
                tasks: ["uglify", "jshint", "shell:copyMain"],
                options: { spawn: false }
            },

            scss: {
                files: ["src/**/*.scss"],
                tasks: ["concat", "sass"],
                options: { spawn: false }
            },

            css: {
                files: ["dist/**/*.css"],
                tasks: ["autoprefixer"],
                options: { spawn: false }
            }
        }
    });

    // 2. TASKS
    require("load-grunt-tasks")(grunt);

    // 3. PERFORM
    grunt.registerTask("default", ["jshint", "autoprefixer", "uglify", "concat", "sass", "shell"]);

}