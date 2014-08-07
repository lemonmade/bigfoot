module.exports = function(grunt) {

	// 1. CONFIG
	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json"),

		uglify: {
			build: {
				src: "dist/bigfoot.js",
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
				src: [
          "src/scss/foundation/footnote-variables.scss",
          "src/scss/foundation/footnote-mixins.scss",
          "src/scss/button.scss",
          "src/scss/popover.scss"
        ],
				dest: "dist/bigfoot-default.scss"
			}
    },

		coffee: {
			dist: {
				src: "src/coffee/bigfoot.coffee",
				dest: "dist/bigfoot.js"
			}
		},

		sass: {
			dist: {
				options: { style: "expanded" },

				files: {
					"dist/bigfoot-default.css": "dist/bigfoot-default.scss"
				}
			}
		},

		autoprefixer: {
			dist: {
				files: {
					"dist/bigfoot-default.css": "dist/bigfoot-default.css"
				}
			}
		},

		watch: {
			options: { livereload: false },

			coffee: {
				files: ["src/coffee/bigfoot.coffee"],
				tasks: ["coffee", "uglify"],
				options: { spawn: false }
			},

			scss: {
				files: ["src/**/*.scss"],
				tasks: ["concat", "sass", "autoprefixer"],
				options: { spawn: false }
			}
		}
	});

	// 2. TASKS
	require("load-grunt-tasks")(grunt);

	// 3. PERFORM
	grunt.registerTask("default", ["coffee", "uglify", "concat", "sass", "autoprefixer"]);
  grunt.registerTask("styles", ["concat", "sass", "autoprefixer"]);
  grunt.registerTask("scripts", ["coffee", "uglify"]);

}
